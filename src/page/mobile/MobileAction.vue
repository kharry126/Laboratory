<template>
  <div>
    <el-button type="success" @click="download">官网下载</el-button>
    <el-button type="info" @click="oem">进行OEM</el-button>
    <el-button type="warning">警告按钮</el-button>
  </div>
</template>
<script>
export default {
  name: 'SxMobileAction',
  props: ['store'],
  methods: {
    download () {
      if (this.active === 'ios') {
        window.open('https://demo.smartbi.com.cn/Smartbi855_for_iOS_20181229.ipa');
      } else {
        window.open('http://demo.smartbi.com.cn/Smartbi855_for_Android_20181229.apk');
      }
    },
    oem () {
      this.store.switchOem();
    }
  }
}
</script>

