<template>
  <v-dialog v-model="show" width="50vh">
    <img :src="$store.state.qrcode" style="max-width: 50vh" />
  </v-dialog>
</template>

<script>
export default {
  name: "QRDialog",
  props: {
    value: Boolean,
  },
  computed: {
    show: {
      get() {
        return this.value;
      },
      set(value) {
        this.$emit("input", value);
      },
    },
  },
};
</script>
