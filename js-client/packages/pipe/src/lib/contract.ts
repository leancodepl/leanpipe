import { Observable } from "rxjs";

export type SubscriptionState = {
    topicType: string;
    topic: unknown;
    notifications$: Observable<unknown>;
};

export type NotificationEnvelope = {
    Id: string;
    TopicType: string;
    NotificationType: string;
    Topic: unknown;
    Notification: unknown;
};

export type SubscriptionResult = {
    SubscriptionId: string;
    Status: SubscriptionStatus;
    Type: OperationType;
};

export enum SubscriptionStatus {
    Success = 0,
    Unauthorized = 1,
    Malformed = 2,
    Invalid = 3,
    InternalServerError = 4,
}

export enum OperationType {
    Subscribe = 0,
    Unsubscribe = 1,
}
