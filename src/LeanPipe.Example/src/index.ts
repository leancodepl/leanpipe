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

interface Envelope {
  topicType: string;
  notificationType: string;
  topic: object;
  notification: object;
}

connection.on("notify", (message: Envelope) => {
  const m = document.createElement("div");

  m.innerHTML = `<div>${JSON.stringify(message)}</div>`;

  divMessages.appendChild(m);
  divMessages.scrollTop = divMessages.scrollHeight;
});

connection.start().catch((err) => document.write(err));

btnSubscribe.addEventListener("click", () => {
  connection.send("SubscribeAsync", {
    TopicType: "LeanPipe.Example.Contracts.Auction",
    Topic: JSON.stringify({ AuctionId: tbTopic.value }),
  });
});
btnUnsubscribe.addEventListener("click", () => {
  connection.send("UnsubscribeAsync", {
    TopicType: "LeanPipe.Example.Contracts.Auction",
    Topic: JSON.stringify({ AuctionId: tbTopic.value }),
  });
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
