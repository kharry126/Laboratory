<template>
  <div>
    <div class="uploadBorder">
      <div>
        <p class="link">
          <a href="#">点击上传该文件</a>
          <span>或者拖拽上传</span>
        </p>
        <p>
          {{uploadType}}
        </p>
        <p>
          {{fileLimit}}
        </p>
      </div>
    </div>
    <sx-excel-template>
    </sx-excel-template>
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
import SxExcelTemplate from './ExcelTemplate'
export default {
  name: 'SxExcelUpload',
  components: {SxExcelTemplate},
  data () {
  	return {
  	  uploadType: '支持Excel和CSV文件（单个Excel最大100M，CSV最大200M）',
      fileLimit: '最多5个文件批量上传，默认识别第一个sheet文件'
  	}
  }
}
</script>

<style>
.uploadBorder {
  border: 2px dashed rgb(82, 135, 226);
  height: 170px;
  min-height: 170px;
  width: 960px;
  display: table-cell;
  vertical-align: middle;
  margin-bottom: 10px;
}

.uploadBorder p {
  color: rgba(10,18,32,.46);
  font-size: 12px;
  margin: 0px;
  padding: 0px;
  text-align: center;
  line-height: 16px;
}

.uploadBorder .link {
  margin-bottom: 10px;
}

.uploadBorder .link a {
  color: rgb(81, 130, 228);
  text-decoration-color: rgb(81, 130, 228);
}

</style>
