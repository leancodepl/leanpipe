import * as signalR from "@microsoft/signalr";
import "./css/main.css";

const divMessages: HTMLDivElement = document.querySelector("#divMessages");
const tbTopic: HTMLInputElement = document.querySelector("#tbTopic");
const tbAmount: HTMLInputElement = document.querySelector("#tbAmount");
const btnSubscribe: HTMLButtonElement = document.querySelector("#btnSubscribe");
const btnUnsubscribe: HTMLButtonElement =
  document.querySelector("#btnUnsubscribe");
const btnBid: HTMLButtonElement = document.querySelector("#btnBid");
const btnBuy: HTMLButtonElement = document.querySelector("#btnBuy");
const username = new Date().getTime();

const connection = new signalR.HubConnectionBuilder().withUrl("/pipe").build();

interface NotificationEnvelope {
  id: string;
  topicType: string;
  notificationType: string;
  topic: object;
  notification: object;
}

interface SubscriptionEnvelope {
  Id: string;
  TopicType: string;
  Topic: string;
}

enum SubscriptionStatus {
  Success = 0,
  Unauthorized = 1,
  Malformed = 2,
}

interface SubscriptionResult {
  SubscriptionId: string;
  Status: SubscriptionStatus;
}

connection.on("subscriptionResult", (message: SubscriptionResult) => {
  const m = document.createElement("div");

  m.innerHTML = `<div>${JSON.stringify(message)}</div>`;

  divMessages.appendChild(m);
  divMessages.scrollTop = divMessages.scrollHeight;
});

connection.on("notify", (message: NotificationEnvelope) => {
  const m = document.createElement("div");

  m.innerHTML = `<div>${JSON.stringify(message)}</div>`;

  divMessages.appendChild(m);
  divMessages.scrollTop = divMessages.scrollHeight;
});

connection.start().catch((err) => document.write(err));

btnSubscribe.addEventListener("click", () => {
  const envelope: SubscriptionEnvelope = {
    Id: crypto.randomUUID(),
    TopicType: "LeanPipe.Example.Contracts.Auction",
    Topic: JSON.stringify({ AuctionId: tbTopic.value }),
  };
  connection.send("SubscribeAsync", envelope);
});
btnUnsubscribe.addEventListener("click", () => {
  const envelope: SubscriptionEnvelope = {
    Id: crypto.randomUUID(),
    TopicType: "LeanPipe.Example.Contracts.Auction",
    Topic: JSON.stringify({ AuctionId: tbTopic.value }),
  };
  connection.send("UnsubscribeAsync", envelope);
});
btnBid.addEventListener("click", (event) => {
  fetch(normalize("/cqrs/command/LeanPipe.Example.Contracts.PlaceBid"), {
    method: "POST",
    body: JSON.stringify({
      AuctionId: tbTopic.value,
      Amount: Number(tbAmount.value),
      UserId: username.toString(),
    }),
    headers: {
      "Content-type": "application/json; charset=UTF-8",
    },
  });
  event.preventDefault();
});
btnBuy.addEventListener("click", (event) => {
  fetch(normalize("/cqrs/command/LeanPipe.Example.Contracts.Buy"), {
    method: "POST",
    body: JSON.stringify({
      AuctionId: tbTopic.value,
      UserId: username.toString(),
    }),
    headers: {
      "Content-type": "application/json; charset=UTF-8",
    },
  });
  event.preventDefault();
});

function normalize(uri) {
  const aTag = window.document.createElement("a");
  aTag.href = uri;
  return aTag.href;
}
