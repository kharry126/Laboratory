<template>
  <div>
    <div class="block" v-for="img in imageList" :key="img">
      <span class="demonstration">{{ img.size[0] }} * {{ img.size[1] }}</span>
        <img
        :style="'width: ' + img.size[0] + 'px; height: ' + img.size[1] + 'px;' "
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
  name: 'SxLoadingView',
  data () {
    return {
      imageUrl: '',
      imageList: [{
        size: [600, 900],
        src: '@/assets/logo.png'
      }, {
        size: [1024, 768],
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

