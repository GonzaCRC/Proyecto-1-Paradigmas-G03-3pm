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

  //heders = new HttpHeaders();
  //headers = this.heders.set('Content-Type', 'application/json');

  constructor(private http: HttpClient) {}

  ngOnInit() {
    console.log(this.messages);

    this.messages = [
      { id: 0, owner: "User", body: "Hello.." },
      { id: 0, owner: "Bot", body: "How are you doing? :)" }
    ];
  }

  onSendMessage(input) {
    if (input.value) {
      this.messages.push({ id: 0, owner: "User", body: input.value });
      this.messagesDiv.nativeElement.scrollTop = this.messagesDiv.nativeElement.scrollHeight;

      let postData = { text: input.value };
      let resData;
      this.http
        .post(this.url, postData)
        .toPromise()
        .then(data => {
          resData = data["text"];
        });
      setTimeout(() => {
        this.messages.push({ id: 0, owner: "Bot", body: "..." });

        setTimeout(() => {
          this.messages.pop();

          this.messages.push({
            id: 0,
            owner: "Bot",
            body: resData
          });
          this.messagesDiv.nativeElement.scrollTop = this.messagesDiv.nativeElement.scrollHeight;
        }, Math.floor(Math.random() * (3000 - 1000 + 1) + 1000));
      }, 750);

      input.value = "";
    }
  }
}
