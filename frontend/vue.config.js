module.exports = {
  transpileDependencies: [
    'vuetify'
  ],

  configureWebpack: {
    optimization: {
      minimize: true,
      splitChunks: {
        minSize: 10000,
        maxSize: 250000,
      }
    }
  },

  productionSourceMap: false
}
