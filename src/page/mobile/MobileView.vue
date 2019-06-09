<template>
  <div class="content">
    <el-collapse v-model="store.active" accordion>
      <el-collapse-item title="苹果应用" name="ios">
        <sx-mobile-action :store="store"></sx-mobile-action>
        <el-collapse-transition>
          <sx-mobile-oem :store="store" v-if="store.isOem"></sx-mobile-oem>
        </el-collapse-transition>
      </el-collapse-item>
      <el-collapse-item title="安卓应用" name="android">
        <sx-mobile-action :store="store"></sx-mobile-action>
        <sx-mobile-oem :store="store" v-if="store.isOem"></sx-mobile-oem>
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
import SxMobileOem from './oem/MobileOem.vue'

Vue.use(ElementUI)
export default {
  name: 'SxMobileView',
  components: {SxMobileAction, SxMobileOem},
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
