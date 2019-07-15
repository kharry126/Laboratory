<template>
  <div>
    <div class="block" v-for="img in imageList" :key="img">
      <span class="demonstration">{{ img.size[0] }} * {{ img.size[1] }}</span>
        <img
        src="@/assets/logo.png"/>
    </div>
    <el-upload
      class="avatar-uploader"
      action="https://jsonplaceholder.typicode.com/posts/"
      :show-file-list="false"
      :on-success="success"
      :before-upload="beforeUpload">
      <img v-if="imageUrl" :src="imageUrl" class="avatar">
      <i v-else class="el-icon-plus avatar-uploader-icon"></i>
    </el-upload>
  </div>
</template>
<script>
import Vue from 'vue'
import ElementUI from 'element-ui';

Vue.use(ElementUI)
export default {
  name: 'SxLogoView',
  data () {
    return {
      imageUrl: '',
      imageList: [{
        size: [14, 14],
        src: '@/assets/logo.png'
      }, {
        size: [24, 24],
        src: '@/assets/logo.png'
      }, {
        size: [34, 34],
        src: '@/assets/logo.png'
      }, {
        size: [44, 44],
        src: '@/assets/logo.png'
      }, {
        size: [54, 54],
        src: '@/assets/logo.png'
      }, {
        size: [64, 64],
        src: '@/assets/logo.png'
      }, {
        size: [74, 74],
        src: '@/assets/logo.png'
      }, {
        size: [84, 84],
        src: '@/assets/logo.png'
      }, {
        size: [94, 94],
        src: '@/assets/logo.png'
      }, {
        size: [104, 104],
        src: '@/assets/logo.png'
      }, {
        size: [114, 114],
        src: '@/assets/logo.png'
      }]
    }
  },
  methods: {
    success () {
      this.$emit('finish');
    }, 
    beforeUpload () {
      this.$emit('finish');
    }
  }
}
</script>

