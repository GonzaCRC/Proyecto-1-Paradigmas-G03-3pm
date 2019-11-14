import { Injectable } from "@angular/core";
import {
  ActivatedRouteSnapshot,
  RouterStateSnapshot,
  UrlTree,
  CanActivate
} from "@angular/router";
import { Observable } from "rxjs";

@Injectable({
  providedIn: "root"
})
export class ChatterGuard implements CanActivate {
  constructor() {}

  canActivate(): Observable<boolean> | Promise<boolean> | boolean {
    return localStorage.getItem("role") == "Chatter";
  }
}
