<template>
  <div class="excel-view">
    <sx-excel-view>
    </sx-excel-view>
  </div>
</template>

<script>
import SxExcelView from './ExcelView'
export default {
  name: 'SxExcel',
  components: {SxExcelView},
  data () {
    return {
    }
  }
}
</script>

<style>
.excel-view {
  background-color: #E8EBED;
  height: 100%;
}

html body, div, dl, dt, dd, ul, ol, li, h1, h2, h3, h4, h5, h6, form, fieldset, input, textarea, p, th, td, img, em, hr {
  margin: 0px;
  padding: 0px;
  color: rgba(10,18,32,.64)
}

body {
  font-size: 12px;
  height: 100%;
}
</style>
