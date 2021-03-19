<template>
  <v-dialog v-model="show" persistent max-width="490">
    <v-card>
      <v-toolbar color="background">Insert Password</v-toolbar>
      <v-text-field
        class="pa-12 pb-2"
        placeholder="Decryption Password"
        solo
        outlined
        :disabled="disabled"
        rounded
        :error="incorrect"
        :error-messages="incorrect ? 'Incorrect Password' : ''"
        :type="passType"
        prepend-inner-icon="mdi-lock"
        v-model="inputModel"
        v-on:blur="changePassType(false)"
        v-on:focus="changePassType(true)"
      ></v-text-field>
      <v-card-actions>
        <v-btn color="red darken-1" text @click.stop="showDeleteDialog()" icon>
          <v-icon medium>mdi-trash-can</v-icon>
        </v-btn>
        <v-spacer></v-spacer>
        <v-btn color="red darken-1" text onClick="window.location.href = `${window.location.origin}`;">
          GO BACK
        </v-btn>
        <v-btn
          color="accent"
          text
          @click.stop="updateClick()"
          :disabled="inputModel.length === 0"
        >
          CONTINUE
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
    incorrect() {
      return this.$store.state.incorrectPass;
    },
    inputModel: {
      get() {
        return this.$store.state.userDecryptPass;
      },
      set(value) {
        this.$store.commit("updateState", {
          state: "userDecryptPass",
          value: value,
        });
      },
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
  methods: {
    showDeleteDialog() {
      this.$emit("trash", true);
    },
    updateClick() {
      this.$emit("continue");
    },
    updateValue(value) {
      this.$emit("change", {
        text: value,
        type: 0,
      });
    },
    changePassType(text = true) {
      this.passType = text ? "text" : "password";
    },
  },
  data: () => ({
    disabled: false,
    passType: "password",
  }),
};
</script>
