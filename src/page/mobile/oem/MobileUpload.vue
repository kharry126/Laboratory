<template>
  <div>
    <el-upload
      class="avatar-uploader"
      action="https://jsonplaceholder.typicode.com/posts/"
      :show-file-list="true"
      :on-success="success"
      :on-error="error"
      ref="upload"
      :on-change="beforeUpload">
      <i class="el-icon-plus avatar-uploader-icon"></i>
    </el-upload>
    <div v-if="fileName != null">文件名称: {{ fileName }}</div>
    <div v-if="fileSize != null">文件大小: {{ computedSize(fileSize) }}</div>
    <div v-if="fileType != null">文件类型: {{ fileType }}</div>
    <div v-if="fileName != null">
      <el-button size="small" type="success" @click="submitUpload">上传到服务器</el-button>
    </div>
  </div>
</template>
<script>
export default {
  name: 'SxMobileUpload',
  data () {
    return {
      fileName: null,
      fileSize: null,
      fileType: null,
    }
  },
  methods: {
    beforeUpload (file) {
      debugger
      if (file.status == 'ready') {
        this.fileName = file.name;
        this.fileSize = file.size;
      }
    }, 
    success () {
      debugger
    },
    error () {
      debugger
    },
    computedSize (size) {
      let level = 0;
      let result = size;
      while (result > 1024) {
        result = result / 1024;
        level++;
      }
      result = parseInt(result)
      let suffix = null;
      switch (level) {
        case 1:
          suffix = 'KB';
          break;
        case 2:
          suffix = 'MB';
          break;
        case 3:
          suffix = 'GB';
          break;
        default:
          suffix = 'B';
          break;
      }
      return result + ' ' + suffix;
    },
    submitUpload() {
      this.$refs.upload.submit();
    },
  }
}
</script>
<style lang="postcss">
.avatar-uploader .el-upload {
    border: 1px dashed #d9d9d9;
    border-radius: 6px;
    cursor: pointer;
    position: relative;
    overflow: hidden;
  }
  .avatar-uploader .el-upload:hover {
    border-color: #409EFF;
  }
  .avatar-uploader-icon {
    font-size: 28px;
    color: #8c939d;
    width: 178px;
    height: 178px;
    line-height: 178px;
    text-align: center;
  }
  .avatar {
    width: 178px;
    height: 178px;
    display: block;
  }
</style>


