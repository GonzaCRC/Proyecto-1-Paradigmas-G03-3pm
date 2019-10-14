import { Component, OnInit } from "@angular/core";
import { HttpClient } from "@angular/common/http";
import { environment } from "src/environments/environment.prod";
import { RivescriptFilesService } from "../rivescript-files.service";

@Component({
  selector: "app-admin",
  templateUrl: "./admin.component.html",
  styleUrls: ["./admin.component.scss"]
})
export class AdminComponent implements OnInit {
  selectedFile: File;
  successMessage: String;
  errorMessage: String;
  brainUploaded: boolean = false;
  brainsNames: String[];
  selectedBrain: String;

  constructor(
    private http: HttpClient,
    private rivescriptFilesService: RivescriptFilesService
  ) {}

  ngOnInit() {
    this.rivescriptFilesService
      .getRivescriptFilesNames()
      .subscribe((res: String[]) => {
        this.brainsNames = res;

        this.selectedBrain = this.brainsNames[0];
      });
  }

  onFileSelected(file: File, fileInput) {
    this.selectedFile = file;

    fileInput.value = "";
  }

  onFileUpload() {
    this.brainUploaded = true;

    const formData = new FormData();
    formData.append(
      "rivescript_file",
      this.selectedFile,
      this.selectedFile.name
    );

    this.http
      .post(environment.staticServerUrl + "/upload", formData, {
        responseType: "text"
      })
      .subscribe(
        res => {
          this.errorMessage = null;
          this.successMessage = res;

          this.rivescriptFilesService
            .getRivescriptFilesNames()
            .subscribe((res: String[]) => {
              this.brainsNames = res;

              this.selectedBrain = this.brainsNames[0];
            });
        },
        err => {
          this.successMessage = null;
          this.errorMessage = err.error.slice(
            err.error.indexOf("<p>") + 4,
            err.error.indexOf("</p>")
          );
        }
      );
  }
}
