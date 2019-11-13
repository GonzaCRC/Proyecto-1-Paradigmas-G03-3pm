import { Component, OnInit } from "@angular/core";
import { environment } from "src/environments/environment";
import { map } from "rxjs/operators";
import { RivescriptFilesService } from "./rivescript-files.service";
import { HttpClient } from "@angular/common/http";
import { Router } from "@angular/router";

@Component({
  selector: "app-root",
  templateUrl: "./app.component.html",
  styleUrls: ["./app.component.scss"]
})
export class AppComponent implements OnInit {
  aboutIsShown: boolean = false;
  time: Date = new Date();
  userSignedIn: boolean = false;
  get username(): String {
    return localStorage.getItem("username");
  }

  constructor(private http: HttpClient, private router: Router) {}

  ngOnInit() {
    setInterval(() => {
      this.time = new Date();
    }, 1000);

    // Check if user is logged in
    !!localStorage.getItem("username")
      ? (this.userSignedIn = true)
      : (this.userSignedIn = false);
  }

  signUserIn(username, password) {
    this.http
      .post(environment.staticServerUrl + "/validateUser", {
        user: username.value,
        pass: password.value
      })
      .subscribe((res: any) => {
        if (res.success == "True") {
          localStorage.setItem("username", username.value);
          localStorage.setItem("role", res.role);

          res.role == "Chatter"
            ? this.router.navigate(["/chatter"])
            : this.router.navigate(["/admin"]);

          this.userSignedIn = true;
        } else {
          alert("Inicio de sesion fallido");
        }
      });
  }

  signUserOut() {
    localStorage.removeItem("username");
    localStorage.removeItem("role");

    this.userSignedIn = false;
  }
}
