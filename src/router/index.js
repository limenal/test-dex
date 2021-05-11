import Vue from 'vue'
import VueRouter from 'vue-router'
import Exchanger from '../views/Exchanger.vue'
import Graph from '../views/Graph.vue'
Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'Exchanger',
    component: Exchanger
  },
  {
      path:'/graph',
      name: 'Graph',
      component: Graph
  }
  
]

const router = new VueRouter({
   mode: '',
  routes
})

export default router
