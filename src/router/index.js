import Vue from 'vue'
import Router from 'vue-router'
import HelloWorld from '@/components/HelloWorld'
import Excel from '@/page/excelimport/Excel.vue'
import Mobile from '@/page/mobile/Mobile.vue'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'HelloWorld',
      component: HelloWorld
    }, {
      path: '/excel',
      name: 'Excel',
      component: Excel
    }, {
      path: '/mobile',
      name: 'Mobile',
      component: Mobile
    }
  ]
})
