<template>
  <div class="exel_savecontent">
    <el-form label-width="80px" class="excel_form" :rules="rules">
      <el-form-item label="别名">
        <el-input v-model="activeTab.name" size="mini" name="name"></el-input>
      </el-form-item>
      <el-form-item label="路径">
        <label>数据源</label>
        <a>修改</a>
        <a>全部应用</a>
      </el-form-item>
      <el-form-item label="备注">
        <el-input  v-model="activeTab.remark" type="textarea" size="small" resize="false"></el-input>
      </el-form-item>
    </el-form>
  </div>
</template>

<script>
/**
 * 描述：数据源模块入口；路由：'/datasource'<br>
 * 提供： 1. 测试连接
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
import {Form, FormItem, Input} from 'element-ui'
import SxExcelFooter from '@/page/excelimport/common/ExcelFooter'
Vue.use(Form)
Vue.use(FormItem)
Vue.use(Input)
export default {
  name: 'SxExcelSaveContent',
  props: ['activeTab'],
  components: {
    SxExcelFooter
  },
  data () {
    return {
      rules :{
        name: [
          { required: true, message: '请选择活动资源', trigger: 'change' }
        ]
      }
    }
  },
  updated: {
    activeTab (tab) {
    }
  }
}
</script>
<style type="text/css">
.exel_savecontent .excel_form {
  width: 400px;
  margin:auto;
  margin-top: 45px;
}

.exel_savecontent .excel_form label,
.exel_savecontent .excel_form a {
  font-size: 12px;
}

.exel_savecontent .excel_form .el-form-item {
  margin-bottom: 8px;
}

.exel_savecontent .excel_form .el-form-item__label {
  padding-right: 16px;
}

.exel_savecontent .excel_form a {
  color: #5182E4;
  text-decoration-color: #5182E4;
  cursor: pointer;
  text-decoration:underline
}

.exel_savecontent .excel_form .el-input__inner {
  border-top-width: 0px;
  border-left-width: 0px;
  border-right-width: 0px;
  border-radius: 0px;
  height: 22px;
  line-height: 22px;
  padding-left: 5px;
}
</style>

