<template>
  <v-btn-toggle rounded>
    <v-tooltip
      v-for="(button, i) in Buttons[buttonType]"
      :key="button.aria"
      bottom
    >
      <template v-slot:activator="{ on, attrs }">
        <v-btn
          :disabled="disabled && buttonType !== 1"
          :aria-label="button.aria"
          v-bind="attrs"
          v-on="on"
          v-on:click="emitClickEvent(i)"
          :onClick="button.reset ? 'window.location.href = `${window.location.origin}`;' : ''"
        >
          <v-icon :class="button.justIcon ? '' : 'c-btn-i'" medium>
            mdi-{{ button.icon }}
          </v-icon>
          {{ button.justIcon ? "" : button.aria }}
        </v-btn>
      </template>
      <span>{{ button.aria }}</span>
    </v-tooltip>
  </v-btn-toggle>
</template>

<script>
export default {
  name: "NavButtons",
  props: {
    Buttons: Array,
    disabled: Boolean,
  },
  computed: {
    buttonType() {
      return this.$store.state.decrypted ? 1 : 0;
    },
  },
  methods: {
    emitClickEvent(button = 0) {
      this.$emit("click-button", button);
    },
  },
};
</script>

<style>
.v-btn-toggle > .v-btn.v-btn--active {
  opacity: 0.8 !important;
}
.v-btn--active::before {
  opacity: 0 !important;
}
.v-btn--active:hover::before {
  opacity: 0.08 !important;
}
</style>
