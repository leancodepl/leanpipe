import { HubConnection, HubConnectionBuilder, IHttpConnectionOptions } from "@microsoft/signalr"
import deepEqual from "deep-equal"
import { matches, pull } from "lodash"
import { Observable, ReplaySubject, fromEvent, throwError } from "rxjs"
import { filter, first, map, share, shareReplay, switchMap, tap, timeout } from "rxjs/operators"
import {
    NotificationEnvelope,
    OperationType,
    SubscriptionResult,
    SubscriptionState,
    SubscriptionStatus,
} from "./contract"

/**
 * Manages real-time subscriptions to topics using SignalR connections.
 * 
 * @param url - SignalR hub URL to connect to
 * @param options - Optional SignalR connection configuration
 * @example
 * ```typescript
 * const pipe = new Pipe({ 
 *   url: "https://api.example.com/pipe",
 *   options: { accessTokenFactory: () => getToken() }
 * });
 * ```
 */
export class Pipe {
    #connection$
    #subscriptions: SubscriptionState[] = []

    constructor({ url, options }: { url: string; options?: IHttpConnectionOptions }) {
        this.#connection$ = new Observable<HubConnection>(subscriber => {
            const connection = new HubConnectionBuilder()
                .withUrl(url, options ?? {})
                .withAutomaticReconnect({
                    nextRetryDelayInMilliseconds: ({ previousRetryCount }) =>
                        [0, 500, 1000].at(previousRetryCount) ?? 2000,
                })
                .build()

            connection.start().then(() => subscriber.next(connection))
            connection.onreconnected(() => subscriber.next(connection))

            return () => connection.stop()
        }).pipe(
            map(connection => ({
                connection,
                notifications$: fromEvent<NotificationEnvelope>(connection, "notify").pipe(share()),
                subscriptionResults$: fromEvent<SubscriptionResult>(connection, "subscriptionResult").pipe(share()),
            })),
            shareReplay({
                refCount: true,
                bufferSize: 1,
            }),
        )
    }

    /**
     * Subscribes to a topic and returns an observable of notifications.
     * 
     * @template TNotifications - Type mapping of notification types to their payload types
     * @param topicType - Type identifier for the topic
     * @param topic - Topic parameters or filters
     * @returns Observable that emits notification tuples [NotificationType, Notification]
     * @throws {Error} When subscription fails or times out after 3 seconds
     * @example
     * ```typescript
     * interface Notifications {
     *   UserUpdated: { id: string; name: string };
     *   UserDeleted: { id: string };
     * }
     * 
     * const notifications$ = pipe.topic<Notifications>("User", { userId: "123" });
     * notifications$.subscribe(([type, data]) => {
     *   console.log(`Received ${type}:`, data);
     * });
     * ```
     */
    topic<TNotifications extends Record<string, unknown>>(topicType: string, topic: unknown) {
        let subscription = this.#subscriptions.find(matchesTopic(topicType, topic))

        if (!subscription) {
            const finish = new ReplaySubject<() => void>(1)
            finish.next(() => undefined)

            subscription = {
                topicType,
                topic,
                notifications$: this.#connection$.pipe(
                    switchMap(({ connection, notifications$, subscriptionResults$ }) => {
                        const subscriptionId = crypto.randomUUID()
                        const payload = { Id: subscriptionId, TopicType: topicType, Topic: topic }

                        connection.send("Subscribe", payload)
                        finish.next(() => {
                            connection.send("Unsubscribe", payload)
                            pull(this.#subscriptions, subscription)
                        })

                        return subscriptionResults$.pipe(
                            first<SubscriptionResult>(
                                matches({ SubscriptionId: subscriptionId, Type: OperationType.Subscribe }),
                            ),
                            timeout({ first: 3000 }),
                            switchMap(({ Status }) =>
                                Status === SubscriptionStatus.Success
                                    ? notifications$
                                    : throwError(() => new Error(`Error: ${SubscriptionStatus[Status].toString()}`)),
                            ),
                        )
                    }),
                    filter<NotificationEnvelope>(matchesTopic(topicType, topic)),
                    map(
                        ({ NotificationType, Notification }) =>
                            [NotificationType, Notification] as NotificationsUnion<TNotifications>,
                    ),
                    share({ resetOnRefCountZero: () => finish.pipe(tap(apply)) }),
                ) satisfies Observable<NotificationsUnion<TNotifications>>,
            }

            this.#subscriptions.push(subscription)
        }

        return subscription.notifications$ as Observable<NotificationsUnion<TNotifications>>
    }
}

/**
 * Applies a function and returns its result.
 * 
 * @param x - Function to execute
 * @returns Result of the function execution
 */
function apply<T>(x: () => T) {
    return x()
}

/**
 * Creates a predicate function that matches topics by type and content.
 * 
 * @param topicType - Topic type to match
 * @param topic - Topic content to match
 * @returns Function that returns true if topic matches
 */
function matchesTopic(topicType: string, topic: unknown) {
    return (t: NotificationEnvelope | SubscriptionState) =>
        "Topic" in t
            ? t.TopicType === topicType && deepEqual(t.Topic, topic)
            : t.topicType === topicType && deepEqual(t.topic, topic)
}

/**
 * Union type representing all possible notification tuples for a given notification mapping.
 * 
 * @template T - Record mapping notification types to their payload types
 */
export type NotificationsUnion<T extends Record<string, unknown>> = Values<{ [TKey in keyof T]: [TKey, T[TKey]] }>
type Values<T> = T[keyof T]
