import {
  Component,
  OnInit,
  ViewChild,
  ElementRef,
  OnDestroy
} from "@angular/core";
import { ChatService } from "../chat.service";
import { Subscription } from "rxjs";
import { Message } from "src/models/Message";
import { RivescriptFilesService } from "../rivescript-files.service";
import { ActivatedRoute } from "@angular/router";
import { HttpClient } from "@angular/common/http";
import { environment } from "src/environments/environment";

@Component({
  selector: "app-chatter",
  templateUrl: "./chatter.component.html",
  styleUrls: ["./chatter.component.scss"]
})
export class ChatterComponent implements OnInit {
  @ViewChild("messagesDiv", { static: false }) messagesDiv: ElementRef;
  @ViewChild("messageInput", { static: false }) messageInput: ElementRef;

  messages: Object = {};
  userPicture: string = "assets/img/user.jpg";
  botPicture: string = "assets/img/brain.png";
  messageBeingSent: boolean;
  chatSubscription: Subscription;
  filesSubscription: Subscription;
  botsNames: string[];
  selectedBot: string;

  constructor(
    private chatService: ChatService,
    private http: HttpClient,
    private rivescriptFilesService: RivescriptFilesService
  ) {}

  ngOnInit() {
    this.filesSubscription = this.rivescriptFilesService
      .getRivescriptFilesNames()
      .subscribe((res: string[]) => {
        this.botsNames = res;

        if (this.botsNames.length) {
          this.selectedBot = this.botsNames[0];

          this.getBotsMessages();
        }
      });

    this.subscribeToWebSocket();
  }

  getBotsMessages(botIndex = 0) {
    this.http
      .post(environment.staticServerUrl + "/getChat", {
        user: localStorage.getItem("username"),
        bot: this.botsNames[botIndex]
      })
      .subscribe((res: any) => {
        this.messages[this.botsNames[botIndex]] = res.chat.map((message, i) => {
          if (i % 2 == 0) return { owner: "User", body: message };
          else return { owner: "Bot", body: message };
        });

        if (botIndex < this.botsNames.length - 1) {
          this.getBotsMessages(botIndex + 1);
        }
      });
  }

  subscribeToWebSocket() {
    this.chatSubscription = this.chatService.messages.subscribe(
      msg => {
        this.messages[this.selectedBot].push(msg);

        this.scrollChat();
      },
      err => {
        console.log(err);
      },
      () => {
        setTimeout(this.subscribeToWebSocket, 1000);
      }
    );
  }

  onSendMessage(message) {
    if (message) {
      this.messageBeingSent = true;

      this.messages[this.selectedBot].push({ owner: "User", body: message });

      this.chatService.messages.next({
        body: message,
        brainName: this.selectedBot,
        user: localStorage.getItem("username")
      });

      this.messageBeingSent = false;

      this.messageInput.nativeElement.value = "";
    }
  }

  scrollChat() {
    setTimeout(() => {
      this.messagesDiv.nativeElement.scrollTop = this.messagesDiv.nativeElement.scrollHeight;
    }, 5);
  }
}
