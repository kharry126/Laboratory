<template>
 <el-card class="box-card">
    <div slot="header" class="clearfix">
      <span></span>
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
  </el-card>
</template>
<script>
export default {
  name: 'IpaUpload',
  data () {
    return {
      imageUrl: '',
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

