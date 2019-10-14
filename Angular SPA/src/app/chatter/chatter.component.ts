import { Component, OnInit, ViewChild, ElementRef } from "@angular/core";
import { Message } from "src/models/Message";
import { HttpClient } from "@angular/common/http";

@Component({
  selector: "app-chatter",
  templateUrl: "./chatter.component.html",
  styleUrls: ["./chatter.component.scss"]
})
export class ChatterComponent implements OnInit {
  @ViewChild("messagesDiv", { static: false }) messagesDiv: ElementRef;
  @ViewChild("messageInput", { static: false }) messageInput: ElementRef;

  messages: Message[] = [];
  userPicture: string = "assets/img/user.jpg";
  botPicture: string = "assets/img/bot2.png";

  url: string = "http://localhost:3000/api2";
  messageBeingSent: boolean;

  constructor(private http: HttpClient) {}

  ngOnInit() {
    this.messages = [
      { owner: "User", body: "Hello.." },
      { owner: "Bot", body: "Hellooo" }
    ];
  }

  onSendMessage(message) {
    if (message) {
      this.messageBeingSent = true;
      this.messages.push({ _id: 0, owner: "User", body: message });
      this.messagesDiv.nativeElement.scrollTop = this.messagesDiv.nativeElement.scrollHeight;

      let postData = { id: 0, owner: "User", body: message };

      setTimeout(() => {
        this.messages.push({ _id: 0, owner: "Bot", body: "..." });

        setTimeout(() => {
          this.messages.pop();

          this.http
            .post(this.url, postData)
            .toPromise()
            .then(data => {
              if (data != null) this.messages = data["data"].messages;
            });
          this.messagesDiv.nativeElement.scrollTop = this.messagesDiv.nativeElement.scrollHeight;

          this.messageBeingSent = false;
        }, Math.floor(Math.random() * (3000 - 1000 + 1) + 1000));
      }, 750);

      this.messageInput.nativeElement.value = "";
    }
  }
}
