<template>
  <v-dialog v-model="show" persistent max-width="600">
    <v-card>
      <v-toolbar :color="info.type === 0 ? 'green' : 'red'">
        {{ info.type === 0 ? "Success" : "Error" }}
      </v-toolbar>
      <v-card-text class="pa-12"
        ><span v-if="info.url.length > 0">Bin URL: </span>
        <a
          :href="info.url"
          :onClick="
            'window.location.href = `' + info.url + '`;location.reload()'
          "
          style="text-decoration: underline"
          v-if="info.url.length > 0"
          >{{ info.url }}</a
        >
        <br v-if="info.url.length > 0" />
        {{ info.text }}
        <span
          v-if="info.extra.length > 0"
          class="c-deletion-key accent--text"
          >{{ info.extra[0] }}</span
        ></v-card-text
      >
      <v-card-actions>
        <v-spacer></v-spacer>
        <v-btn color="accent" text @click.stop="show = false">
          I Understand
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
export default {
  name: "PassDialog",
  props: {
    value: Boolean,
  },
  computed: {
    info() {
      return this.$store.state.infoDialogObj;
    },
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

<style>
html {
  overflow: auto !important;
}
.v-input__prepend-inner,
.c-btn-i {
  padding-right: 10px !important;
}
.c-deletion-key {
  font-weight: bold;
}
</style>u
