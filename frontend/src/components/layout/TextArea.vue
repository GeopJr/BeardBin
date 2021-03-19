<template>
  <v-container fluid fill-height>
    <v-row class="fill-height">
      <v-spacer />
      <v-col cols="12" xl="6" lg="6" md="6" sm="12" xs="12">
        <template v-if="$store.state.decrypted && $store.state.code">
          <div class="c-textarea-code">
            <highlight-code :auto="true" :code="inputModel">
            </highlight-code>
          </div>
        </template>
        <template v-else>
          <v-textarea
            class="c-textarea"
            solo
            label="Text Editor"
            no-resize
            height="100%"
            shaped
            hide-details
            v-on:input="updateValue"
            v-model="inputModel"
            :readonly="readonly"
          >
          </v-textarea>
        </template>
      </v-col>
      <v-spacer />
    </v-row>
  </v-container>
</template>

<script>
export default {
  name: "TextArea",
  props: {
    readonly: Boolean,
  },
  computed: {
    inputModel: {
      get() {
        return this.$store.state.userContent;
      },
      set(value) {
        this.$store.commit("updateState", {
          state: "userContent",
          value: value,
        });
      },
    },
  },
  methods: {
    updateValue() {
      this.$emit("change", this.inputModel);
    },
  },
};
// v-input c-textarea v-textarea v-textarea--no-resize v-input--hide-details theme--dark v-text-field v-text-field--single-line v-text-field--solo v-text-field--is-booted v-text-field--enclosed v-text-field--shaped
</script>

<style>
.c-textarea.v-input,
.c-textarea > .v-input__control {
  height: 100% !important;
}
.c-textarea-code,
.c-textarea-code > pre {
  height: 100%;
}
.c-textarea-code code,
.v-application code {
  background-color: #1e1e1e !important;
}
.c-textarea-code code {
  border-radius: 16px 16px 0 0;
  padding-top: 10px;
  padding: 10px;
  height: calc(100vh - 164px) !important;
}
.c-textarea-code span {
  white-space: break-spaces;
}
</style>
