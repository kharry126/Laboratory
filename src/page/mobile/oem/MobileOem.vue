<template>
  <div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>卡片名称</span>
      </div>
      <sx-mobile-upload></sx-mobile-upload>
    </el-card>
    <div></div>
    <div></div>
    <div></div>
    <div></div>
    <div></div>
  </div>
</template>
<script>
import Vue from 'vue'
import ElementUI from 'element-ui';
import SxMobileUpload from './MobileUpload.vue'

Vue.use(ElementUI)
export default {
  name: 'SxMobileOem',
  components: {SxMobileUpload},
  props: ['store'],
  data () {
    return {
    }
  },
  mounted () {
    // this.active = this.$route.params.active || this.$route.query.active;
  }
}
</script>