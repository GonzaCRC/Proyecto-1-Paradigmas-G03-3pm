import { Component, OnInit, ViewChild, ElementRef } from "@angular/core";
import { Message } from "src/models/Message";
import { HttpClient } from "@angular/common/http";

@Component({
  selector: "app-root",
  templateUrl: "./app.component.html",
  styleUrls: ["./app.component.scss"]
})
export class AppComponent implements OnInit {
  @ViewChild("messagesDiv", { static: false }) messagesDiv: ElementRef;
  typedMessage: string;
  messages: Message[];
  userPicture: string = "assets/img/user.jpg";
  botPicture: string = "assets/img/bot2.png";

  url: string = "http://localhost:3000/api2";

  constructor(private http: HttpClient) { }

  ngOnInit() {
    this.http
      .get("http://localhost:3000/api/chats?id=0")
      .toPromise()
      .then(data => {
        this.messages = data["data"].messages;
      });
  }

  onSendMessage(input) {
    if (input.value) {
      this.messages.push({ _id: 0, owner: "User", body: input.value });
      this.messagesDiv.nativeElement.scrollTop = this.messagesDiv.nativeElement.scrollHeight;

      let postData = { id: 0, owner: "User", body: input.value };

      setTimeout(() => {
        this.messages.push({ _id: 0, owner: "Bot", body: "..." });

        setTimeout(() => {
          this.messages.pop();

          this.http
            .post(this.url, postData)
            .toPromise()
            .then(data => {
              this.messages = data["data"].messages;
          });
          this.messagesDiv.nativeElement.scrollTop = this.messagesDiv.nativeElement.scrollHeight;
        }, Math.floor(Math.random() * (3000 - 1000 + 1) + 1000));
      }, 750);

      input.value = "";
    }
  }
}
