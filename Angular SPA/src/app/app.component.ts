import { Component, OnInit } from "@angular/core";
import { environment } from "src/environments/environment";
import { map } from "rxjs/operators";
import { RivescriptFilesService } from "./rivescript-files.service";

@Component({
  selector: "app-root",
  templateUrl: "./app.component.html",
  styleUrls: ["./app.component.scss"]
})
export class AppComponent implements OnInit {
  aboutIsShown: boolean = false;
  time: Date = new Date();

  constructor() {}

  ngOnInit() {
    setInterval(() => {
      this.time = new Date();
    }, 1000);
  }
}
