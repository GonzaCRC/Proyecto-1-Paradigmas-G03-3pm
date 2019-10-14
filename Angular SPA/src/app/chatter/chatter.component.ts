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

@Component({
  selector: "app-chatter",
  templateUrl: "./chatter.component.html",
  styleUrls: ["./chatter.component.scss"]
})
export class ChatterComponent implements OnInit, OnDestroy {
  @ViewChild("messagesDiv", { static: false }) messagesDiv: ElementRef;
  @ViewChild("messageInput", { static: false }) messageInput: ElementRef;

  messages: Message[] = [];
  userPicture: String = "assets/img/user.jpg";
  botPicture: String = "assets/img/brain.png";
  messageBeingSent: boolean;
  chatSubscription: Subscription;
  botsNames: String[];
  selectedBot: String;

  constructor(
    private chatService: ChatService,
    private rivescriptFilesService: RivescriptFilesService
  ) {}

  ngOnInit() {
    console.log("Subscribe");

    this.rivescriptFilesService
      .getRivescriptFilesNames()
      .subscribe((res: String[]) => {
        this.botsNames = res;

        this.selectedBot = this.botsNames[0];
      });

    this.chatSubscription = this.chatService.messages.subscribe(msg => {
      this.messages.push(msg);
      this.scrollChat();
    });
  }

  ngOnDestroy() {
    console.log("Unsubscribe");

    this.chatSubscription.unsubscribe();
  }

  onSendMessage(message) {
    if (message) {
      this.messageBeingSent = true;

      this.messages.push({ owner: "User", body: message });

      this.scrollChat();

      setTimeout(() => {
        this.messages.push({ owner: "Bot", body: "..." });

        this.scrollChat();

        setTimeout(() => {
          this.messages.pop();

          this.chatService.messages.next({
            body: message,
            brainName: this.selectedBot
          });

          this.messageBeingSent = false;
        }, Math.floor(Math.random() * (3000 - 1000 + 1) + 1000));
      }, 750);

      this.messageInput.nativeElement.value = "";
    }
  }

  scrollChat() {
    setTimeout(() => {
      this.messagesDiv.nativeElement.scrollTop = this.messagesDiv.nativeElement.scrollHeight;
    }, 5);
  }
}
