<template>
  <div>
    <el-form label-width="80px">
      <el-form-item label="别名">
        
      </el-form-item>
      <el-form-item label="路径">

      </el-form-item>
      <el-form-item label="备注">

      </el-form-item>
    </el-form>
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
import {Form, FormItem} from 'element-ui'
Vue.use(Form)
Vue.use(FormItem)
export default {
  name: 'SxExcelSaveContent'
}
</script>
<style type="text/css">

</style>

