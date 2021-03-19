import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    userContent: "",
    shouldDisable: false,
    userPassword: "",
    code: false,
    incorrectPass: false,
    userDecryptPass: "",
    showDecryptionDialog: false,
    deleteId: "",
    buttonsDisabled: false,
    infoDialogObj: { text: "", extra: [], type: 0, url: "" },
    decrypted: false,
    routeKey: undefined,
    routeID: undefined,
    qrcode: ""
  },
  getters: {
    hasUserContent: state => {
      return state.userContent.length > 0 && !state.buttonsDisabled
    }
  },
  mutations: {
    updateState(state, content) {
      state[content.state] = content.value
    },
    clear(state) {
      state.userContent = ""
      state.shouldDisable = false
      state.userPassword = ""
      state.code = false
      state.incorrectPass = false
      state.userDecryptPass = ""
      state.showDecryptionDialog = false
      state.deleteId = ""
      state.buttonsDisabled = false
      state.infoDialogObj = { text: "", extra: [], type: 0, url: "" }
      state.decrypted = false
      state.routeKey = undefined
      state.routeID = undefined
      state.qrcode = ""
    }
  },
  actions: {
  },
  modules: {
  }
})
