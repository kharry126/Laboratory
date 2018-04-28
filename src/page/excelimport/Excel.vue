<template>
  <div class="excel-view">
    <sx-excel-view :list="processList" :success="onSuccess">
    </sx-excel-view>
  </div>
</template>

<script>
import Vue from 'vue'
import  VueResource  from 'vue-resource'
import SxExcelView from './ExcelView'
Vue.use(VueResource)
export default {
  name: 'SxExcel',
  components: {SxExcelView},
  data () {
    return {
      processList: ['upload', 'preview', 'savetable']
    }
  },
  methods: {
    onSuccess (store) {
      alert(JSON.stringify(store.tabs));
    },
    click () {
      var _this = this;
        var reqData = {
          profile_id: '40651',
          token: 'aaaaaaaaaaaaaaaaa',
          type: 1, //评估类型（1：健康测评，2：疾病评估）
          page_no: 1,
          page_size: 50
        }
        _this.$http.get('/api/datasources/all',{}).
          then(function(res){
            var obj = res.body;
            console.log(obj);
            document.write(JSON.stringify(obj))
          })
    }
  }
}
</script>

<style>
.excel-view {
  background-color: #E8EBED;
  height: 100%;
}

body {
  font-size: 12px;
  height: 100%;
}
</style>
