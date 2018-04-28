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
  props: ['list', 'success'],
  data () {
    return {
      store: null
    }
  },
  created () {
    this.store = new SxExcelStore({
      processList: this.list,
      success: this.success
    });
  }
}
</script>

<style scoped>
.content {
  width: 960px;
  margin: auto;
}

dl, dt, dd, ul, ol, li, h1, h2, h3, h4, h5, h6, form, fieldset, input, textarea, p, th, td, img, em, hr {
  margin: 0px;
  padding: 0px;
  color: rgba(10,18,32,.64)
}
</style>
