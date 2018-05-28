import { SplashScreen } from '@ionic-native/splash-screen';
import { Component } from '@angular/core';
import { InAppBrowser } from '@ionic-native/in-app-browser';

@Component({
  templateUrl: 'app.html'
})
export class MyApp {
  constructor(
    private iab: InAppBrowser,
    private splashScreen: SplashScreen,
  ) {}

  ngOnInit() {
    // TODO: Insert crm web page url
    const browser = this.iab.create('http://daum.net', '_blank', 'location=no');
    browser.on('loadstop').subscribe(event => {
      this.splashScreen.hide();
      browser.show();
    });
  }
}
