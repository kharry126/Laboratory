<template>
  <div class="excel_sheet">
    <el-dialog
      title="新增数据"
      :visible.sync="visible"
      @open="openWindow"
      :close-on-click-modal="false"
      width="520px">
      <p>请你选择需要添加的工作表</p>
      <el-checkbox v-model="checkAll" class="selectAll" @change="allchange" :indeterminate="isIndeterminate">全选</el-checkbox>
      <div class="select_sheet">
        <el-checkbox-group v-model="checkeds" @change="itemchange">
          <el-checkbox v-for="sheet in sheets" :label="sheet.id" :key="sheet.id" :disabled="sheet.empty">
            {{sheet.name}}
            <span class="empty_tip" v-if="sheet.empty">
              (工作表为空)
            </span>
          </el-checkbox>
        </el-checkbox-group>
      </div>
      <span slot="footer" class="dialog-footer">
        <el-button type="text" @click="ok">确 定</el-button>
        <el-button @click="visible = false" type="text">取 消</el-button>
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
import {Dialog, Checkbox, CheckboxGroup, Button} from 'element-ui'
export default {
  name: 'SxExcelSheetDialog',
  props: ['store', 'tabs'],
  data () {
    return {
      visible: false,
      checkAll: false,
      sheets: [],
      checkeds: [],
      isIndeterminate: false
    }
  },
  // 测试代码
  created () {
    this.init();
  },
  methods: {
    init () {
      this.sheets = this.store.getSheets();
      let allows = this.sheets.filter((item) => {
        return item.empty !== true;
      })
      this.checkCount = allows.length;
    },
    show () {
      this.visible = true;
    },
    close () {
      this.visible = false;
    },
    ok () {
      if (this.checkeds.length <= 0) {
        this.$message('无可上传的工作表');
      } else {
        let tabs = this.sheets.filter((item) => {
          return this.checkeds.indexOf(item.id) >= 0;
        })
        this.store.tabs = tabs;
        this.visible = false;
        this.store.next();
      }
    },
    openWindow () {
      this.init();
    },
    allchange (val) {
      this.isIndeterminate = false;
      this.checkeds = [];
      if (val) {
        this.sheets.forEach((item) => {
          if (item.empty) {
            return;
          }
          this.checkeds.push(item.id);
        })
      }
    },
    itemchange (val) {
      this.checkAll = false;
      this.isIndeterminate = false;
      if (this.checkeds.length === this.checkCount) {
        this.checkAll = true;
      } else if (this.checkeds.length > 0) {
        this.isIndeterminate = true;
      }
    }
  }
}
</script>

<style type="text/css">
.el-message.el-message--info {
  padding: 10px;
  border-radius: 0px;
  text-align: center;
}
.excel_sheet .el-dialog {
  background: #F0F2F3;
  user-select: none;
}

.excel_sheet .el-dialog__header {
  line-height: 32px;
  text-align: left;
  padding: 10px 0 8px 24px;
}

.excel_sheet .el-dialog__body {
  padding: 8px 32px;
}

.excel_sheet .el-dialog__body .selectAll {
  margin-bottom: 10px;
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
  max-height: 210px;
  overflow: auto;
  padding: 6px 0px;
  margin-bottom: 15px;
}

.excel_sheet .select_sheet .empty_tip {
  color: #E45151;
}

.excel_sheet .select_sheet .el-checkbox {
  display: block;
  height: 32px;
  line-height: 32px;
  padding: 0px 15px;
  color: rgba(10,18,32,.64)
}

.excel_sheet .select_sheet .el-checkbox .el-checkbox__input.is-indeterminate .el-checkbox__inner::before {
  top: 3px;
}

.excel_sheet .select_sheet .el-checkbox:hover .el-checkbox__inner {
  border-color: #409EFF;
}

.excel_sheet .select_sheet .el-checkbox:hover .el-checkbox__inner.is-disabled{
  border-color: #409EFF;
  color: rgba(10,18,32,.87)
}

.excel_sheet .select_sheet .el-checkbox.is-disabled:hover .el-checkbox__inner {
  border-color: #dcdfe6;
}

.excel_sheet .el-checkbox__inner {
  height: 12px;
  width: 12px;
  border-radius: 0px;
}

.excel_sheet .el-checkbox__inner::after {
  left: 3px;
  top: 0px
}

.excel_sheet .select_sheet .el-checkbox+.el-checkbox {
  margin-left: 0px;
}

.excel_sheet .el-dialog__footer {
  padding: 10px;
  height:52px;
  line-height: 20px;
  display: table;
  width: 100%;
}

.excel_sheet .el-dialog__footer .el-button--text {
  width: 60px;
  height: 32px;
  padding-top: 8px;
  padding-bottom: 8px;
}

.excel_sheet .el-dialog__footer .el-button--text span {
  font-weight: 700;
  font-size: 14px;
}

.el-dialog__title {
  font-size: 14px;
  font-weight: 700;
}
</style>

