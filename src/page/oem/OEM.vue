<template>
  <div>
    <el-upload
      >
    </el-upload>
  </div>
</template>
<script>
import SxIosOem from './IOSOEM'
import Vue from 'vue'
import ElementUI from 'element-ui';
Vue.use(ElementUI)
export default {
  name: 'SxOEM',
  components: {SxIosOem},
  data () {
    return {
      active: 'IOS'
    }
  },
  mounted () {
    // this.active = this.$route.params.active || this.$route.query.active;
  }
}
</script>