<template>
  <div class="stepContent">
    <sx-excel-upload :store="store" v-if="store.isShow('upload')"></sx-excel-upload>
    <sx-excel-preview :store="store" v-if="store.isShow('preview')"></sx-excel-preview>
    <sx-excel-save :store="store" v-if="store.isShow('savetable')"></sx-excel-save>
    <sx-excel-footer :store="store"></sx-excel-footer>
  </div>
</template>

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
import SxExcelUpload from './upload/ExcelUpload'
import SxExcelPreview from './preview/ExcelPreview'
import SxExcelSave from './save/ExcelSave'
import SxExcelFooter from './common/ExcelFooter'

export default {
  name: 'SxExcelContent',
  components: {SxExcelUpload, SxExcelPreview, SxExcelSave, SxExcelFooter},
  props: ['store']
}
</script>
<style scoped>
.stepContent {
  background: white;
}
</style>
