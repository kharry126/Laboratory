<template>
  <div class="excel_footer" v-show = "store.isShowFooter()">
    <div class="footer_buttons">
      <el-button type="primary" size="small" class="footer_button" v-if="!store.isFinish()" @click="next()">
        下一步
      </el-button>
      <el-button type="success" size="small" class="footer_button" v-if="store.isFinish()" @click="finish()">
        完&nbsp;&nbsp;&nbsp;&nbsp;成
      </el-button>
      <el-button type="text" size="small" class="footer_button" @click="prev()">
        上一步
      </el-button>
    </div>
  </div>
</template>

<script>
/**
 * Props(允许外部环境传递数据给组件)：<br>
 *   无
 * Slots(允许外部环境将额外的内容组合在组件中)：<br>
 *   无
 * Events(允许组件触发外部环境的副作用)：<br>
 *   无
 * @since 2018-02-17
 */
import Vue from 'vue'
import {Button} from 'element-ui'
import SxMobileOemFooter from '../common/MobileOemFooter.vue'


Vue.use(Button)
export default {
  name: 'SxMobileOemFooter',
  components: {SxMobileOemFooter},
  props: ['store'],
  methods: {
    next () {
      this.store.next();
    },

    prev () {
      this.store.prev();
    },

    finish () {
      this.store.finish();
    }
  }
}
</script>

<style type="text/css">
.excel_footer {
  position: absolute;
  left: 0px;
  bottom: 0px;
  height: 48px;
  background: #F0F2F3;
  width: 100%;
  box-shadow: 0 0 6px 0 rgba(0,0,0,.1), 0 -10px 12px 0 rgba(170,182,206,.2), inset 0 1px 0 0 rgba(255,255,255,.3);
}

.excel_footer .footer_buttons {
  width: 960px;
  height: 100%;
  margin: auto;
  height: 48px;
  line-height: 48px;
}

.excel_footer .footer_button {
  float: right;
  margin: 8px;
  padding: 9px 20px;
  max-width:78px;
}
</style>
