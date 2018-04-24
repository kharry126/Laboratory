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

<style scoped>
.excel-view {
  background-color: #E8EBED;
  height: 100%;
}

body {
  margin: 0px;
  height: 100%;
}
</style>
