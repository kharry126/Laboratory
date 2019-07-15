<template>
  <div>
    <sx-ipa-upload @finish="finsih" v-if="index === 0"></sx-ipa-upload>
    <sx-logo-view v-if="index === 1"></sx-logo-view>
    <sx-loading-view v-if="index === 2"></sx-loading-view>
    <sx-download-page v-if="index === 3"></sx-download-page>
    <el-button @click="next">next</el-button>
  </div>
</template>
<script>
import Vue from 'vue'
import ElementUI from 'element-ui';
import SxMobileUpload from './MobileUpload.vue'
import SxIpaUpload from './view/IpaUpload.vue'
import SxLogoView from './view/LogoView.vue'
import SxLoadingView from './view/LoadingView.vue'
import SxDownloadPage from './view/DownloadPage.vue'

Vue.use(ElementUI)
export default {
  name: 'SxMobileOem',
  components: {SxMobileUpload, SxIpaUpload, SxLogoView, SxLoadingView, SxDownloadPage},
  props: ['store'],
  data () {
    return {
      index: 0,
    }
  },
  mounted () {
    // this.active = this.$route.params.active || this.$route.query.active;
  },
  methods: {
    finsih () {
      alert('finish');
      this.index ++;
    },
    next () {
      this.index ++;
    }
  }
}
</script>