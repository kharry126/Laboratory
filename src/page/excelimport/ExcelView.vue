<template>
  <div class="content">
    <sx-step-view></sx-step-view>
    <sx-excel-content></sx-excel-content>
  </div>
</template>

<script>
import SxStepView from './StepView'
import SxExcelContent from './ExcelContent'
export default {
  name: 'SxExcelView',
  components: {SxStepView, SxExcelContent},
  data () {
    return {
    }
  }
}
</script>

<style scoped>
.content {
  width: 960px;
  margin: auto;
}
</style>
