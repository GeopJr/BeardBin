<template>
  <v-switch
    class="pl-4"
    :disabled="disabled"
    v-model="switchModel"
    hide-details
    inset
  ></v-switch>
</template>

<script>
export default {
  name: "NavSwitch",
  props: {
    disabled: Boolean,
  },
  computed: {
    switchModel: {
      get() {
        return this.$store.state.code;
      },
      set(value) {
        this.$store.commit("updateState", { state: "code", value: value });
      },
    },
  },
};
</script>
