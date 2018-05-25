import { Component } from '@angular/core';
import { InAppBrowser } from '@ionic-native/in-app-browser';

@Component({
  templateUrl: 'app.html'
})
export class MyApp {

  constructor(private iab: InAppBrowser) {}

  ngOnInit() {
    const browser = this.iab.create('http://192.168.0.102:8080', '_self', 'location=yes');
    browser.show()
  }
}
