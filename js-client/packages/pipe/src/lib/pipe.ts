import { HubConnection, HubConnectionBuilder } from "@microsoft/signalr";
import { find, matches, pull } from "lodash";
import { Observable, ReplaySubject, fromEvent, throwError } from "rxjs";
import { filter, first, map, share, shareReplay, switchMap, tap, timeout } from "rxjs/operators";
import {
    SubscriptionState,
    NotificationEnvelope,
    SubscriptionResult,
    OperationType,
    SubscriptionStatus,
} from "./contract";

export class Pipe {
    #connection$;
    #subscriptions: SubscriptionState[] = [];

    constructor({ url }: { url: string }) {
        this.#connection$ = new Observable<HubConnection>(subscriber => {
            const connection = new HubConnectionBuilder()
                .withUrl(url)
                .withAutomaticReconnect({
                    nextRetryDelayInMilliseconds: ({ previousRetryCount }) =>
                        [0, 500, 1000].at(previousRetryCount) ?? 2000,
                })
                .build();

            connection.start().then(() => subscriber.next(connection));
            connection.onreconnected(() => subscriber.next(connection));

            return () => connection.stop();
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
        );
    }

    topic<TNotifications extends Record<string, unknown>>(topicType: string, topic: unknown) {
        let subscription = find(this.#subscriptions, { topic, topicType });

        if (!subscription) {
            const finish = new ReplaySubject<() => void>(1);
            finish.next(() => undefined);

            subscription = {
                topicType,
                topic,
                notifications$: this.#connection$.pipe(
                    switchMap(({ connection, notifications$, subscriptionResults$ }) => {
                        const subscriptionId = crypto.randomUUID();
                        const payload = { Id: subscriptionId, TopicType: topicType, Topic: topic };

                        connection.send("Subscribe", payload);
                        finish.next(() => {
                            connection.send("Unsubscribe", payload);
                            pull(this.#subscriptions, subscription);
                        });

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
                        );
                    }),
                    filter<NotificationEnvelope>(matches({ TopicType: topicType, Topic: topic })),
                    map(
                        ({ NotificationType, Notification }) =>
                            [NotificationType, Notification] as NotificationsUnion<TNotifications>,
                    ),
                    share({ resetOnRefCountZero: () => finish.pipe(tap(apply)) }),
                ) satisfies Observable<NotificationsUnion<TNotifications>>,
            };

            this.#subscriptions.push(subscription);
        }

        return subscription.notifications$ as Observable<NotificationsUnion<TNotifications>>;
    }
}

function apply<T>(x: () => T) {
    return x();
}

export type NotificationsUnion<T extends Record<string, unknown>> = Values<{ [TKey in keyof T]: [TKey, T[TKey]] }>;
type Values<T> = T[keyof T];
