<template>
  <div class="content">
    <el-collapse v-model="store.active" accordion>
      <el-collapse-item title="苹果应用" name="ios">
        <sx-mobile-action :store="store"></sx-mobile-action>
      </el-collapse-item>
      <el-collapse-item title="安卓应用" name="android">
        <sx-mobile-action :store="store"></sx-mobile-action>
      </el-collapse-item>
    </el-collapse>
    <div>
      {{ JSON.stringify(store)}}
    </div>
  </div>
</template>
<script>
import Vue from 'vue'
import ElementUI from 'element-ui';
import MobileStore from './MobileStore.js'
import SxMobileAction from './MobileAction.vue'
Vue.use(ElementUI)
export default {
  name: 'SxMobileView',
  components: {SxMobileAction},
  data () {
    return {
      store: new MobileStore()
    }
  }
}
</script>
<style scoped>
  .content {
    padding: 20px 100px;
  }
</style>
