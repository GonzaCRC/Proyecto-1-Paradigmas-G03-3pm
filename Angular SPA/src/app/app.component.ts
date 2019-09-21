import { Component, OnInit } from "@angular/core";
import { Message } from "src/models/Message";

@Component({
  selector: "app-root",
  templateUrl: "./app.component.html",
  styleUrls: ["./app.component.scss"]
})
export class AppComponent implements OnInit {
  typedMessage: string;
  messages: Message[];
  userPicture: string = "assets/img/user.jpg";
  botPicture: string = "assets/img/bot2.png";

  ngOnInit() {
    this.messages = [
      { id: 0, owner: "User", body: "Hello.." },
      { id: 0, owner: "Bot", body: "How are you doing? :)" }
    ];
  }

  onSendMessage(input) {
    if (input.value) {
      this.messages.push({ id: 0, owner: "User", body: input.value });

      input.value = "";

      setTimeout(() => {
        this.messages.push({ id: 0, owner: "Bot", body: "..." });

        setTimeout(() => {
          this.messages.pop();

          this.messages.push({
            id: 0,
            owner: "Bot",
            body: "Bot not implemented yet"
          });
        }, Math.floor(Math.random() * (3000 - 1000 + 1) + 1000));
      }, 750);
    }
  }
}
