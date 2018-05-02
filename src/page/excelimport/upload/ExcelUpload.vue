<template>
  <div class="excel_upload">
    <div class="uploadBorder">
      <div>
        <el-upload
          class="upload-demo"
          drag
          action="/api/uploadfile/fileupload"
          :on-success="successUpload"
          multiple>
          <i class="el-icon-upload"></i>
          <div class="el-upload__text">
            <p class="link"><em>点击上传文件</em> 或者拖拽上传</p>
            <p>
              {{uploadType}}
            </p>
             <p>
              {{fileLimit}}
            </p>
          </div>
          <div class="el-upload__tip" slot="tip">
          </div>
        </el-upload>
      </div>
    </div>
    <sx-excel-template>
    </sx-excel-template>
    <sx-excel-sheet-dialog ref="dialog" :sheets="sheets" :store="store"></sx-excel-sheet-dialog>
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
import SxExcelSheetDialog from './ExcelSheetDialog'
export default {
  name: 'SxExcelUpload',
  components: {
    SxExcelTemplate,
    SxExcelSheetDialog
  },
  props: ['store'],
  data () {
  	return {
  	  uploadType: '支持Excel和CSV文件（单个Excel最大100M，CSV最大200M）',
      fileLimit: '最多5个文件批量上传，默认识别第一个sheet文件',
      sheets: []
  	}
  },
  methods: {
    successUpload (response, file, fileList) {
      this.store.setFileName(response, file);
      this.sheets = this.store.getSheets();
      this.store.next();
      if (sheets.length > 1) {
        this.$refs.dialog.show();
      } else {
        this.store.next();
      }
    }
  }
}
</script>

<style>
.excel_upload {
  padding: 20px
}

.excel_upload .el-upload {
  display: block;
}

.excel_upload .el-upload .el-upload-dragger {
  border: none;
  margin: auto;
  display: table;
  width: 99%;
  height: 160px;
  margin-top: 5px;
}

.uploadBorder {
  border: 2px dashed rgb(82, 135, 226);
  height: 170px;
  min-height: 170px;
  width: 960px;
  display: table-cell;
  vertical-align: middle;
  margin-bottom: 10px;
}

.excel_upload .el-upload .el-icon-upload {
  display: none;
}

.excel_upload .el-upload .el-upload__text {
  font-size: 12px;
  height: 100%;
  display: table-cell;
  vertical-align: middle;
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

.uploadBorder .link em {
  color: rgb(81, 130, 228);
  text-decoration-color: rgb(81, 130, 228);
  cursor: pointer;
  text-decoration:underline
}

</style>
