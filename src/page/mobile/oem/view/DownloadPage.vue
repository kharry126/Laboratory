<template>
  <div>
    服务器地址:<el-input v-model="serverPath"></el-input>
    <el-button @click="update">更新页面</el-button>
  </div>
</template>
<script>
export default {
  name: 'SxDownloadPage',
  data () {
    return {
      serverPath: '',
    }
  },
  methods: {
    update () {
      alert(this.serverPath);
    }
  }
}
</script>

