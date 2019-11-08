import { Injectable } from "@angular/core";
import { Subject, throwError } from "rxjs";
import { map, catchError } from "rxjs/operators";
import { WebsocketService } from "./websocket.service";
import { Message } from "src/models/Message";
import { environment } from "src/environments/environment";

@Injectable({
  providedIn: "root"
})
export class ChatService {
  public messages: Subject<Message>;

  constructor(wsService: WebsocketService) {
    this.messages = <Subject<Message>>(
      wsService.connect(environment.websocketServerURL).pipe(
        map(
          (response: MessageEvent): Message => {
            return {
              owner: "Bot",
              body: response.data
            };
          }
        )
      )
    );
  }
}
