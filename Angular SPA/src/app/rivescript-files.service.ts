import { Injectable } from "@angular/core";
import { HttpClient } from "@angular/common/http";
import { environment } from "src/environments/environment";
import { map } from "rxjs/operators";

@Injectable({
  providedIn: "root"
})
export class RivescriptFilesService {
  rivescriptFilesNames: String[];

  constructor(private http: HttpClient) {}

  getRivescriptFilesNames() {
    return this.http.get(environment.staticServerUrl + "/getRiveFiles").pipe(
      map((res: any) => {
        let filteredArray: Array<String> = res.data.map(botName => {
          return botName.slice(15, botName.indexOf(".rive.out"));
        });

        return filteredArray.slice(1, filteredArray.length);
      })
    );
  }
}
