<template>
  <div class="excel_table">
    <el-tabs v-model="activeName" type="card">
      <el-tab-pane :label="tab.name" :name="tab.id" v-for="tab in tabs" :key='tab.id' class="pane">
        <el-table border stripe :data="tableDatas[tab.id]" height="260">
          <el-table-column v-for="head in tableHeads[tab.id]" :key="head.id" :prop="head.name" :label="head.name">
          </el-table-column>
        </el-table>
      </el-tab-pane>
    </el-tabs>
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
import Vue from 'vue'
import {Tabs, TabPane, Table, TableColumn} from 'element-ui'
Vue.use(Tabs)
Vue.use(TabPane)
Vue.use(Table)
Vue.use(TableColumn)
export default {
  name: 'SxExcelTable',
  props: ['store', 'tabs', 'tableHeads', 'tableDatas'],
  data () {
    return {
      activeName: null
    }
  },
  created () {
    this.activeName = this.tabs[0].id;
  }
}
</script>
<style type="text/css">
.excel_table .pane{
  padding: 0px 20px 20px 20px;
}

.excel_table .el-table__header-wrapper {
  display: none;
}

.excel_table .el-tabs__nav-scroll {
  padding: 0px 20px;
}

.excel_table .el-tabs__item {
  font-size: 12px;
  font-weight: 800;
  height: 32px;
  line-height: 32px;
}

.excel_table .el-tabs__header {
  border-color: #5182E4;
}

</style>

