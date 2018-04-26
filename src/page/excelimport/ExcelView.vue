<template>
  <div class="content">
    <sx-step-view :store="store"></sx-step-view>
    <sx-excel-content :store="store"></sx-excel-content>
  </div>
</template>

<script>
import SxStepView from './StepView'
import SxExcelContent from './ExcelContent'
import SxExcelStore from './ExcelStore'
export default {
  name: 'SxExcelView',
  components: {SxStepView, SxExcelContent},
  data () {
    return {
      store: null
    }
  },
  created () {
    this.store = new SxExcelStore();
  }
}
</script>

<style scoped>
.content {
  width: 960px;
  margin: auto;
}
</style>
