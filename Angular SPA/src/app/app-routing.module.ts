import { NgModule } from "@angular/core";
import { Routes, RouterModule } from "@angular/router";
import { ChatterComponent } from "./chatter/chatter.component";
import { AdminComponent } from "./admin/admin.component";

const routes: Routes = [
  {
    path: "",
    children: [
      { path: "admin", component: AdminComponent },
      { path: "chatter", component: ChatterComponent }
    ]
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes, { useHash: true })],
  exports: [RouterModule]
})
export class AppRoutingModule {}
