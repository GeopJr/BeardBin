import Vue from 'vue';
import Vuetify from 'vuetify/lib/framework';

Vue.use(Vuetify);

export default new Vuetify({
    breakpoint: {
        thresholds: {
            xl: 12000
        }
    },
    theme: {
        options: { customProperties: true },
        dark: true,
        themes: {
            dark: {
                primary: '#f0db78',
                accent: '#f0db78'
            }
        }
    }
});
