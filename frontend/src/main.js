import Vue from 'vue'
import App from './App.vue'
import vuetify from './plugins/vuetify';
import router from './router'
import store from './store'
import VueHighlightJS from 'vue-highlight.js';

import 'vue-highlight.js/lib/allLanguages'
import 'highlight.js/styles/default.css';

Vue.use(VueHighlightJS);

Vue.config.productionTip = false

new Vue({
  vuetify,
  router,
  store,
  render: h => h(App)
}).$mount('#app')
