<template>
  <div class="template">
    <div class="title">
      表格示例
    </div>
    <div class="tip">
      <p>1.请上传有标准行列的一维数据表格。（有合并单元格的数据请处理过后再上传，否则可能出现表头识别有误）</p>
      <p>2.日期字段需包含年月日（如2016/1/1），或年月日时分秒。（如2016/1/1 00:00:00）</p>
    </div>
    <div class="tabelhead">
      <table cellspacing="1">
        <tr>
          <th v-for="(head, index) in tableHeads" class="headTh">
            第{{index + 1}}列
          </th>
        </tr>
      </table>
    </div>
    <div class="tableData">
      <el-table stripe border :data="data" :resizable="false">
        <el-table-column v-for="(head, index) in tableHeads" :key="index" :prop="head.key" :label="head.label">
        </el-table-column>
      </el-table>
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
import {Table, TableColumn} from 'element-ui'
Vue.use(Table)
Vue.use(TableColumn)
export default {
  name: 'SxExcelTemplate',
  data () {
  	return {
  	  heads: [1, 2, 3, 4, 5, 6, 7, 8, 9],
  	  tableHeads: [{
  	  	key: 'order',
  	  	label: '序号'
  	  }, {
        key: 'user',
        label: '拜访人'
      }, {
        key: 'number',
        label: '员工编号'
      }, {
        key: 'department',
        label: '部门'
      }, {
        key: 'work',
        label: '职位'
      }, {
        key: 'date',
        label: '拜访日期'
      }, {
        key: 'time',
        label: '拜访时间'
      }, {
        key: 'type',
        label: '客户类型'
      }, {
        key: 'state',
        label: '进展'
      }],
  	  data: [{
        order: 1,
        user: '乔歆然',
        number: '600001',
        department: '销售一部',
        work: '销售总监',
        date: '2016/8/8',
        time: '11:23',
        type: '互联网',
        state: '初次拜访'
  	  }, {
        order: 2,
        user: '丘慧美',
        number: '600002',
        department: '销售一部',
        work: '销售总监',
        date: '2016/8/8',
        time: '14:43',
        type: '电商',
        state: '初次拜访'
      }, {
        order: 3,
        user: '束怜烟',
        number: '600003',
        department: '销售一部',
        work: '销售总监',
        date: '2016/8/8',
        time: '11:23',
        type: '商贸',
        state: '初次拜访'
      }]
  	}
  }
}
</script>

<style>
.template {
  margin-top: 30px;
}
.template .title {
  color: rgba(10, 18, 32, 0.64);
  font-size: 14px;
  font-weight: 700;
}
.template .tip {
  color: rgba(10,18,32,.46);
  font-size: 12px;
  margin: 0px;
  padding: 0px;
  line-height: 8px;
}
.template .tabelhead,
.template .tabelhead table {
  width: 100%;
}

.template .tableData {
  margin-top: 10px;
}

.template .tableData .el-table__header th {
  border-right: 1px solid rgb(223,228,231);
  padding: 0px;
}

.template .el-table__body .el-table__row td {
  padding: 0px;
}
.template .el-table__body .el-table__row td .cell {
  padding: 8px 20px;
  line-height: 16px;
  height: 32px;
  font-size: 12px;
  font-weight: 400;
}

.template .tableData .el-table__header th .cell {
  background-color: #ECEFF1;
  color: rgba(10,18,32,.64);
  padding: 8px 20px;
  line-height: 16px;
  height: 32px;
  font-size: 12px;
  font-weight: 400;
}

.template .headTh { 
  width: calc(100% / 9);
  background-color: rgba(81, 130, 228, 0.6);
  font-size: 12px;
  font-weight: 400px;
  padding: 8px;
  color: white;
}
</style>
