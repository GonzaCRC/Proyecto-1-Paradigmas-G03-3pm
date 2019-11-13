import { NgModule } from "@angular/core";
import { Routes, RouterModule } from "@angular/router";
import { ChatterComponent } from "./chatter/chatter.component";
import { AdminComponent } from "./admin/admin.component";
import { ChatterGuard } from './chatter.guard';
import { AdminGuard } from './admin.guard';

const routes: Routes = [
  {
    path: "",
    children: [
      { path: "", redirectTo: "chatter", pathMatch: "full" },
      { path: "admin", component: AdminComponent,
      canActivate: [AdminGuard] },
      { path: "chatter", component: ChatterComponent,
      canActivate: [ChatterGuard] }
    ]
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes, { useHash: true })],
  exports: [RouterModule]
})
export class AppRoutingModule {}
