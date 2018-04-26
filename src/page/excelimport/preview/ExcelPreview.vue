<template>
  <div class="excelpreview">
    <div class="tips">
      <p class="tip">当前选中的表头为第 
        <span class="tiptxt">{{ headindex + 1 }}</span> 行，如不符合预期，可点击将你需要的数据行指定为表头和设置表头类型.</p>
      <p class="tip">表头前的数据，将不会保留</p>
    </div>
    <sx-excel-table></sx-excel-table>
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
import SxExcelTable from './ExcelTable'
import SxExcelFooter from '@/page/excelimport/common/ExcelFooter'
export default {
  name: 'SxExcelPreview',
  props: ['store'],
  components: {
    SxExcelTable,
    SxExcelFooter
  },
  data () {
    return {
      headindex: 0
    }
  }
}
</script>
<style type="text/css">
.excelpreview .tips {
  padding: 20px 20px 10px 20px;
}
.excelpreview .tip {
  line-height: 32px;
}

.excelpreview .tip .tiptxt {
  color: #5182E4
}

.excelpreview  .el-table__body-wrapper .el-table__row td {
  padding: 8px 16px;
}

.excelpreview .el-table__body-wrapper .cell {
  font-size: 12px;
  height: 16px;
  line-height: 16px;
  padding: 0px
}
</style>

