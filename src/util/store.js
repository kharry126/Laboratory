import Vue from 'vue';
import Vuex from 'vuex';

Vue.use(Vuex);

const ANDROID='android';
const IOS = 'ios';

export default new Vuex.Store({
  state: {
    active: null
  },
  mutations: {
    switchIOS () {
      active = IOS;
    },
    switchAndroid () {
      active = ANDROID;
    }
  }
})