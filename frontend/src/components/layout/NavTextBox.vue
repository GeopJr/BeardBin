<template>
  <v-text-field
    placeholder="Password (optional)"
    solo
    hide-details
    dense
    style="max-width: 450px"
    :disabled="disabled"
    rounded
    :type="passType"
    :prepend-inner-icon="
      inputModel.length > 0 ? 'mdi-lock' : 'mdi-lock-open-variant'
    "
    v-on:blur="changePassType(false)"
    v-on:focus="changePassType"
    v-model="inputModel"
  ></v-text-field>
</template>

<script>
export default {
  name: "NavTextBox",
  props: {
    disabled: Boolean,
  },
  computed: {
    inputModel: {
      get() {
        return this.$store.state.userPassword;
      },
      set(value) {
        this.$store.commit("updateState", {
          state: "userPassword",
          value: value,
        });
      },
    },
  },
  methods: {
    changePassType(text = true) {
      this.passType = text ? "text" : "password";
    },
  },
  data: () => ({
    passType: "password",
  }),
};
</script>
