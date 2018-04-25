<template>
  <div class="stepContent">
    <sx-excel-upload></sx-excel-upload>
  </div>
</template>

<style scoped>
.stepContent {
  background: white;
  padding: 20px;
}
</style>

<script>
/**
 * 描述：数据源模块入口；路由：'/datasource'<br>
 * 提供：1. 测试连接
 *       2. 保存连接
 *       3. 取消返回<br>
 * Props(允许外部环境传递数据给组件)：<br>
 *   无
 * Slots(允许外部环境将额外的内容组合在组件中)：<br>
 *   无
 * Events(允许组件触发外部环境的副作用)：<br>
 *   无
 * @since 2018-02-17
 */
import SxExcelUpload from './ExcelUpload'
export default {
  name: 'SxExcelContent',
  components: {SxExcelUpload}
}
</script>
