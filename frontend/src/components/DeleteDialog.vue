<template>
  <v-dialog v-model="show" persistent max-width="490">
    <v-card>
      <v-toolbar color="background">Insert Deletion Key</v-toolbar>
      <v-text-field
        class="pa-12 pb-8"
        placeholder="Decryption Password"
        solo
        hide-details
        outlined
        rounded
        :type="passType"
        prepend-inner-icon="mdi-lock"
        v-model="inputModel"
        v-on:blur="changePassType(false)"
        v-on:focus="changePassType"
      ></v-text-field>
      <v-card-actions>
        <v-spacer></v-spacer>
        <v-btn color="red darken-1" text @click.stop="show = false">
          GO BACK
        </v-btn>
        <v-btn
          color="accent"
          text
          @click.stop="updateClick()"
          :disabled="inputModel.length === 0"
        >
          DELETE
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
export default {
  name: "DeleteDialog",
  props: {
    value: Boolean,
  },
  computed: {
    inputModel: {
      get() {
        return this.$store.state.deleteId;
      },
      set(value) {
        this.$store.commit("updateState", {
          state: "deleteId",
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
    updateClick() {
      this.show = false;
      this.$emit("continue");
    },
    changePassType(text = true) {
      this.passType = text ? "text" : "password";
    },
  },
  data: () => ({
    passType: "password",
  }),
};
</script>
