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
      <table>
        <tr>
          <th v-for="index in heads" class="headTh">
            第{{index}}列
          </th>
        </tr>
      </table>
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
  	  heads2: [{
  	  	key: 'order',
  	  	label: '序号'
  	  }],
  	  data: [{

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

.headTh { 
  width: calc(100% / 9);
  background-color: rgba(81, 130, 228, 0.6);
  font-size: 12px;
  font-weight: 400px;
  padding: 6px;
  color: white;
}
</style>
