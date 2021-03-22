<template>
  <v-app>
    <Nav @click-button="buttonClicked" />
    <v-main>
      <QRDialog v-model="dialogQR" />
      <InfoDialog v-model="infoDialog" />
      <PassDialog
        @trash="showDeleteDialog"
        @continue="validateRabbit"
        v-model="dialog"
      />
      <DeleteDialog @continue="requestDelete" v-model="dialogDeletion" />
      <TextArea :readonly="shouldDisable" />
    </v-main>
    <Footer />
  </v-app>
</template>

<script>
import Nav from "@/components/layout/Nav";
import TextArea from "@/components/layout/TextArea";
import Footer from "@/components/layout/Footer";
import PassDialog from "@/components/PassDialog";
import DeleteDialog from "@/components/DeleteDialog";
import InfoDialog from "@/components/InfoDialog";
import QRDialog from "@/components/QRDialog";

import AES from "crypto-js/aes";
import RABBIT from "crypto-js/rabbit";
import PBKDF2 from "crypto-js/pbkdf2";
import CryptoJS from "crypto-js/core";
import ENC_UTF8 from "crypto-js/enc-utf8";
import ENC_BASE64 from "crypto-js/enc-base64";
import PASSWORD from "secure-random-password";

import QR from "qrcode";

export default {
  name: "BeardBin",

  components: {
    TextArea,
    Nav,
    Footer,
    PassDialog,
    DeleteDialog,
    InfoDialog,
    QRDialog,
  },
  async mounted() {
    this.$store.commit("updateState", {
      state: "routeID",
      value: this.$route.params.id,
    });
    this.$store.commit("updateState", {
      state: "routeKey",
      value: this.$route.params.key,
    });
    if (this.$store.state.routeID && !this.$store.state.routeKey) {
      return this.showInfoDialog(
        `You are missing your decryption key that was provided when this bin got created`,
        "",
        true
      );
    } else if (!this.$store.state.routeID && !this.$store.state.routeKey) {
      return;
    }
    const response = await this.requestRetrieve();
    if (!response) return;
    this.tmpResponse = response;

    if (this.$store.state.routeKey.toLowerCase() === "delete") {
      this.showDeleteDialog();
      return;
    }

    if (response.custom_password) {
      this.dialog = true;
    } else {
      this.decryptContent(response);
    }
  },
  methods: {
    // Generate an SVG QRCODE and save it in Vuex
    // Then show the QRDIALOG
    async generateQRcode() {
      if (this.$store.state.qrcode.length > 0) return (this.dialogQR = true);
      const svgCode = await QR.toString(
        this.createPasteUrl(
          { uuid: this.$store.state.routeID },
          this.$store.state.routeKey
        ),
        { errorCorrectionLevel: "H", type: "svg" }
      );

      const url = URL.createObjectURL(
        new Blob([svgCode], { type: "image/svg+xml" })
      );
      this.$store.commit("updateState", {
        state: "qrcode",
        value: url,
      });
      this.dialogQR = true;
    },
    // Check if RABBIT encrypted bin can be decrypted and notify user
    // if successful proceed with decrypting
    validateRabbit() {
      let decryptedContent = RABBIT.decrypt(
        this.tmpResponse.content,
        this.$store.state.userDecryptPass
      );
      try {
        decryptedContent = decryptedContent.toString(ENC_UTF8);
      } catch {
        this.$store.commit("updateState", {
          state: "incorrectPass",
          value: true,
        });
        return;
      }
      this.$store.commit("updateState", {
        state: "incorrectPass",
        value: false,
      });
      this.dialog = false;
      this.tmpResponse["content"] = decryptedContent;
      this.decryptContent(this.tmpResponse);
    },
    // Constructs the info dialog
    showInfoDialog(text, url, error, extra = []) {
      this.$store.commit("updateState", {
        state: "infoDialogObj",
        value: {
          text: text,
          extra: extra,
          type: error ? 1 : 0,
          url: url,
        },
      });
      this.infoDialog = true;
    },
    // POST options
    createRequestOptions(object) {
      return {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(object),
      };
    },
    // Simple function to generate final url
    createPasteUrl(object, key) {
      return `${window.location.origin}/#/${object.uuid}/${key}`;
    },
    // Do POST
    async requestRetrieve() {
      if (!this.$store.state.routeID || !this.$store.state.routeKey) return;
      const requestOptions = this.createRequestOptions({
        uuid: this.$store.state.routeID,
      });

      const response = await fetch("/retrieve", requestOptions);

      const data = await response.json();
      if (response.status !== 200) {
        this.showInfoDialog(`There was an error with your request:`, "", true, [
          `${data.error}`,
        ]);
        return false;
      }

      return data;
    },
    async requestCreate(payload) {
      const key = payload.key;
      delete payload.key;
      const body = payload;
      const requestOptions = this.createRequestOptions(body);

      const response = await fetch("/create", requestOptions);

      const data = await response.json();
      if (response.status !== 200) {
        return this.showInfoDialog(
          `There was an error with your request:`,
          "",
          true,
          [`${data.error}`]
        );
      }

      const url = this.createPasteUrl(data, key);
      this.showInfoDialog(
        `Please save your delete ID somewhere safe, else you won't be able to manually delete this bin:`,
        url,
        false,
        [`${data.delete_id}`]
      );
      return data;
    },
    async requestDelete() {
      if (
        !this.$store.state.routeID ||
        !this.$store.state.routeKey ||
        this.$store.state.deleteId.length === 0
      )
        return;

      const requestOptions = this.createRequestOptions({
        uuid: this.$store.state.routeID,
        delete_id: this.$store.state.deleteId,
      });

      const response = await fetch("/delete", requestOptions);

      const data = await response.json();
      if (response.status !== 200) {
        return this.showInfoDialog(
          `There was an error with your request:`,
          "",
          true,
          [`${data.error}`]
        );
      }

      this.showInfoDialog(`The bin has been deleted`, "", false);
      return data;
    },
    // Shows the delete dialog
    showDeleteDialog() {
      this.dialogDeletion = true;
    },
    // Handles navbar button clicks
    buttonClicked(button) {
      if (this.$store.state.userContent.length === 0) return;
      this.shouldDisable = true;
      if (this.$store.state.decrypted) {
        if (button === 1) {
          this.dialogDeletion = true;
        } else if (button === 2) {
          this.generateQRcode();
        }
      } else {
        const body = this.encryptSend(button === 1);
        this.requestCreate(body);
      }
    },
    // (Un)Cleans BASE64 as to be url safe
    urlSafeBase64(base64, unsafe = false) {
      return unsafe
        ? base64.replace(/_/g, "/").replace(/-/g, "+")
        : base64.replace(/\//g, "_").replace(/\+/g, "-");
    },
    // Creates random PBKDF2 key thats used in AES encryption
    createAESKey() {
      const salt = CryptoJS.lib.WordArray.random(128 / 8);
      return PBKDF2(PASSWORD.randomString({ length: 30 }), salt, {
        keySize: 512 / 32,
        iterations: 1000,
      });
    },
    // Encrypt content
    encryptSend(viewOnce) {
      if (this.$store.state.userContent.length === 0) return;
      const iv = CryptoJS.lib.WordArray.random(16);
      const pbkdf2 = this.createAESKey();
      const encrypted = AES.encrypt(this.$store.state.userContent, pbkdf2, {
        iv: iv,
      });
      let encryptedContent = encrypted;
      let customPass = false;
      if (this.$store.state.userPassword.length > 0) {
        encryptedContent = RABBIT.encrypt(
          encryptedContent.toString(),
          this.$store.state.userPassword
        );
        customPass = true;
      }

      this.$store.commit("updateState", {
        state: "buttonsDisabled",
        value: true,
      });

      return {
        content: encryptedContent.toString(),
        custom_password: customPass,
        view_once: viewOnce,
        code: this.$store.state.code,
        iv: ENC_BASE64.stringify(iv),
        key: this.urlSafeBase64(ENC_BASE64.stringify(pbkdf2)),
      };
    },
    // Decrypt content
    decryptContent(object) {
      if (!this.$store.state.routeID || !this.$store.state.routeKey) return;

      const key = this.urlSafeBase64(this.$store.state.routeKey, true);

      let decryptedContent = object.content;
      decryptedContent = AES.decrypt(decryptedContent, ENC_BASE64.parse(key), {
        iv: ENC_BASE64.parse(object.iv),
      });

      try {
        decryptedContent = decryptedContent.toString(ENC_UTF8);
      } catch {
        this.showInfoDialog(`There was an error while decrypting:`, "", true, [
          `Wrong key`,
        ]);
        return;
      }

      if (decryptedContent === "") {
        this.showInfoDialog(`There was an error while decrypting:`, "", true, [
          `Wrong key`,
        ]);
        return;
      }

      this.shouldDisable = true;
      this.$store.commit("updateState", {
        state: "decrypted",
        value: true,
      });
      this.$store.commit("updateState", {
        state: "buttonsDisabled",
        value: true,
      });
      this.$store.commit("updateState", {
        state: "code",
        value: object.code,
      });
      this.$store.commit("updateState", {
        state: "userContent",
        value: decryptedContent,
      });
    },
  },
  data: () => ({
    shouldDisable: false,
    dialog: false,
    dialogDeletion: false,
    infoDialog: false,
    tmpResponse: {},
    dialogQR: false,
  }),
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
</style>
