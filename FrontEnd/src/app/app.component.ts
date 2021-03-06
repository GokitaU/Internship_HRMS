import { Component } from '@angular/core';
import { Router } from "@angular/router";
import { Location } from '@angular/common';
import { NetworkingService } from './common/services/networking.service';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})

export class AppComponent {


  constructor(private router: Router, private networking: NetworkingService, private location: Location) {
    const token = this.networking.getToken();
    if ((token === null || this.isTokenExpired(token["refreshTokenExpires"]))) {
      this.router.navigateByUrl('/Login');
    }
  }

  isTokenExpired(expires: any): boolean {
    let curent = new Date();
    let expired = new Date(expires);

    return (expired > curent) ? false : true;
  }
}
