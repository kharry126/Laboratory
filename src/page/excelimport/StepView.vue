<template>
  <div>
    <el-steps :active="active" :space="180" finish-status="success"  align-center>
      <el-step title="上传文件"></el-step>
      <el-step title="预览数据"></el-step>
      <el-step title="数据表设置"></el-step>
    </el-steps>

    <el-button style="display:none;margin-top: 12px;position: absolute" @click="next">下一步</el-button>
  </div>
</template>
<script>
import Vue from 'vue'
import {Steps, Step, Button} from 'element-ui'
Vue.use(Steps)
Vue.use(Step)
Vue.use(Button)
export default {
  name: 'SxStepView',
  data () {
    return {
      active: 0
    }
  },
  methods: {
    next () {
      if (this.active++ > 2) {
        this.active = 0;
      }
    }
  }
}
</script>
<style>
.el-step__line {
  display: none!important
}
.el-step__main {
  position: absolute;
  top: 0px;
  left: calc(50% + 20px);
}

.el-step__main > .el-step__title {
  font-weight: normal;
  line-height: 24px;
}

.el-step__icon.is-text {
  background-color: #5182E4;
  border-color: #5182E4;
  color: white;
  opacity: 0.3;
}

.is-process .el-step__icon.is-text {
  opacity: 1;
}

.is-success .el-step__icon.is-text {
  opacity: 1;
  background-color: #67c23a;
  border-color: #67c23a;
}

.el-step__icon-inner {
  font-size: 12px;
  font-weight: 400;
}

.el-step__title {
  font-size: 12px;
  font-weight: 400;
}

.el-steps.el-steps--horizontal {
  width: 540px;
  margin: auto;
  padding: 12px 0px;
}
</style>
