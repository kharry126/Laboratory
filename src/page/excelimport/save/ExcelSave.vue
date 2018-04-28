<template>
  <div class="excel_save">
    <div class="tables">
      <p>工作表</p>
      <el-menu default-active="0" @select="onSelect">
        <el-menu-item  v-for="(table, index) in tabs" :key="index" :index="index + ''">
          <template slot="title">
            <i class="el-icon-document"></i>
            <span :tid="table.id">{{ table.name }}</span>
          </template>
        </el-menu-item>
      </el-menu>
    </div>
    <div class="content">
      <sx-excel-save-content :activeTab="activeTab">
      </sx-excel-save-content>
    </div>
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
import {Menu, MenuItem} from 'element-ui'
import SxExcelSaveContent from './ExcelSaveContent'
Vue.use(Menu)
Vue.use(MenuItem)
export default {
  name: 'SxExcelSave',
  props: ['store'],
  components: {
    SxExcelSaveContent
  },
  data () {
    return {
      tabs: [],
      activeTab: {}
    }
  },
  created () {
    this.tabs = this.store.tabs;
    if (this.tabs) {
      this.activeTab = this.tabs[0];
    }
  },
  methods: {
    onSelect (index) {
      this.activeTab = this.tabs[index];
    }
  }
}
</script>

<style type="text/css">

.excel_save {
  height: 400px;
  position: relative;
}

.excel_save .tables {
  width: 220px;
  border-right: 1px solid rgb(209, 209, 209);
  height: 100%;
}

.excel_save .tables > p {
  padding: 20px 0 9px 20px;
}

.excel_save .tables .el-menu {
  border-right: none;
  padding-bottom: 20px;
}

.excel_save .tables .el-menu-item {
  padding-right: 24px;
  padding-left: 24px!important;
  height: 32px;
  line-height: 28px;
  color: rgba(10,18,32,.64);
  font-size: 12px;
  font-weight: 400px;
}

.excel_save .tables .el-menu-item:hover {
  background-color: rgba(0, 0, 0, 0);
}

.excel_save .tables .el-menu-item.is-active {
  color: rgba(10,18,32,.87);
  background-color: rgba(0,0,0,.06);
}

.excel_save .tables .el-menu-item i {
  color: rgb(9, 156, 89);
  font-size: 16px;
  width: 16px;
  height: 16px;
  margin-right: 0px;
}

.excel_save .content {
  width: calc(100% - 225px);
  position: absolute;
  top: 0px;
  left: 225px;
  height: 100%;
}
</style>
