import { finished } from "stream";

const ANDROID='android';
const IOS = 'ios';

class MobileStore {
  constructor(option) {
    this.active = IOS;    // 默认ios, 备选值 android|ios
    this.isOem = false;
    this.init();
  }

  init () {
    this.list = {
      
    }
  }

  switchOem () {
    this.isOem = !this.isOem;
  }
}

const option = {
  process: ['upload', 'changeinfo', 'changeimg', 'uploadkey', 'finish']
}

export default MobileStore;
