const ANDROID='android';
const IOS = 'ios';

class MobileStore {
  constructor(option) {
    this.active = IOS;    // 默认ios, 备选值 android|ios
  }
}

export default MobileStore;
