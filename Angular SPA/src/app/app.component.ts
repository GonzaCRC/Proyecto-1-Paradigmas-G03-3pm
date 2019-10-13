import { Component, OnInit } from "@angular/core";

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
