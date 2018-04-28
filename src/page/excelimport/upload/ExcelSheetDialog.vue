<template>
  <div class="excel_sheet">
    <el-dialog
      title="新增数据"
      :visible.sync="visible"
      width="30%">
      <p>请你选择需要添加的工作表</p>
      <el-checkbox v-model="checkAll">全选</el-checkbox>
      <div class="select_sheet">
        <el-checkbox-group v-model="checkedCities" @change="handleCheckedCitiesChange">
          <el-checkbox v-for="city in cities" :label="city" :key="city">{{city}}</el-checkbox>
        </el-checkbox-group>
      </div>
      <span slot="footer" class="dialog-footer">
        <el-button @click="visible = false">取 消</el-button>
        <el-button type="primary" @click="visible = false">确 定</el-button>
      </span>
    </el-dialog>
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
import {Dialog} from 'element-ui'
export default {
  name: 'SxExcelSheetDialog',
  props: ['store', 'tabs'],
  data () {
    return {
      visible: true,
      checkAll: false
    }
  },
  methods: {
    show () {
      this.visible = true;
    },
    close () {
      this.visible = false;
    }
  }
}
</script>

<style type="text/css">
.excel_sheet .el-dialog {
  background: #F0F2F3;
}

.excel_sheet .el-dialog__header {
  line-height: 32px;
  text-align: left;
  padding: 10px 0 8px 24px;
}

.excel_sheet .el-dialog__body {
  padding: 8px 32px;
}

.excel_sheet .el-dialog__body p {
  padding: 0px;
  margin: 0px;
  font-size: 12px;
}

.excel_sheet .el-dialog__body .el-checkbox__label {
  font-size: 12px;
}

.excel_sheet .select_sheet {
  background: white;
  max-height: 220px;
  overflow: auto;
}

.el-dialog__title {
  font-size: 14px;
  font-weight: 700;
}
</style>

