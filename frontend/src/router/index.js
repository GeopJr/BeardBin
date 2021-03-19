import Vue from 'vue'
import VueRouter from 'vue-router'

Vue.use(VueRouter)

const routes = [
  { path: '/:id/' },
  { path: '/:id/:key' },
  { path: '/:id/delete' }
]

const router = new VueRouter({
  routes
})

export default router
