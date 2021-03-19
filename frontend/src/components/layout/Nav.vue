<template>
  <div>
    <v-app-bar class="rounded-b-xl" flat app>
      <v-btn class="ml-0" icon href="/" title="Home">
        <v-avatar>
          <v-img style="background-color: #333333" quality="50" alt="Avatar" src="/beardbin.svg" />
        </v-avatar>
      </v-btn>
      <v-toolbar-title class="d-none d-sm-flex ml-3 pl-0">
        BeardBin
      </v-toolbar-title>
      <v-spacer />
      <template v-if="!isMobile">
        <NavTextBox v-bind:disabled="buttonsDisabled" />
        <v-divider class="mx-4" inset vertical></v-divider>
        <v-tooltip bottom>
          <template v-slot:activator="{ on, attrs }">
            <v-icon
              :class="!textModel ? 'accent--text' : ''"
              medium
              v-bind="attrs"
              v-on="on"
            >
              mdi-format-align-center
            </v-icon>
          </template>
          <span>Text</span>
        </v-tooltip>
        <NavSwitch v-bind:disabled="buttonsDisabled" />
        <v-tooltip bottom>
          <template v-slot:activator="{ on, attrs }">
            <v-icon
              :class="textModel ? 'accent--text' : ''"
              medium
              v-bind="attrs"
              v-on="on"
            >
              mdi-code-braces
            </v-icon>
          </template>
          <span>Code</span>
        </v-tooltip>
        <v-divider class="mx-4" inset vertical></v-divider>
        <NavButtons
          v-bind:disabled="buttonsDisabled"
          v-bind:Buttons="buttons"
          v-on="$listeners"
        />
      </template>
      <v-btn
        class="mr-0"
        rounded
        outlined
        circle
        icon
        v-if="isMobile"
        @click="drawer = true"
      >
        <v-tooltip bottom>
          <template v-slot:activator="{ on, attrs }">
            <v-icon medium v-bind="attrs" v-on="on"> mdi-menu </v-icon>
          </template>
          <span>Menu</span>
        </v-tooltip>
      </v-btn>
    </v-app-bar>
    <template v-if="isMobile">
      <v-navigation-drawer v-model="drawer" absolute temporary>
        <v-list nav>
          <v-list-item-group>
            <v-list-item inactive>
              <NavTextBox v-bind:disabled="buttonsDisabled" />
            </v-list-item>
            <v-divider class="my-4"></v-divider>
            <v-list-item inactive>
              <v-tooltip left>
                <template v-slot:activator="{ on, attrs }">
                  <v-icon
                    :class="!textModel ? 'accent--text' : ''"
                    medium
                    v-bind="attrs"
                    v-on="on"
                  >
                    mdi-format-align-center
                  </v-icon>
                </template>
                <span>Text</span>
              </v-tooltip>
              <NavSwitch class="mt-0 pt-0" v-bind:disabled="buttonsDisabled" />
              <v-tooltip right>
                <template v-slot:activator="{ on, attrs }">
                  <v-icon
                    :class="textModel ? 'accent--text' : ''"
                    medium
                    v-bind="attrs"
                    v-on="on"
                  >
                    mdi-code-braces
                  </v-icon>
                </template>
                <span>Code</span>
              </v-tooltip>
            </v-list-item>
            <v-divider class="my-4"></v-divider>
            <v-list-item inactive>
              <NavButtons
                v-bind:disabled="buttonsDisabled"
                v-bind:Buttons="buttons"
                v-on="$listeners"
              />
            </v-list-item>
          </v-list-item-group>
        </v-list>
      </v-navigation-drawer>
    </template>
  </div>
</template>

<script>
import NavTextBox from "@/components/layout/NavTextBox";
import NavSwitch from "@/components/layout/NavSwitch";
import NavButtons from "@/components/layout/NavButtons";

export default {
  name: "Nav",
  components: {
    NavTextBox,
    NavSwitch,
    NavButtons,
  },
  computed: {
    isMobile() {
      return this.$vuetify.breakpoint.smAndDown;
    },
    buttonsDisabled() {
      return !this.$store.getters.hasUserContent;
    },
    textModel() {
      return this.$store.state.code;
    },
  },
  data: () => ({
    drawer: false,
    group: null,
    buttons: [
      [
        {
          icon: "cloud-upload",
          aria: "Create",
        },
        {
          icon: "fire",
          aria: "Create & Burn",
          justIcon: true,
        },
      ],
      [
        {
          icon: "file-plus",
          aria: "New File",
          reset: true,
        },
        {
          icon: "trash-can",
          aria: "Delete File",
          justIcon: true,
        },
        {
          icon: "qrcode",
          aria: "QR code",
          justIcon: true,
        },
      ],
    ],
  }),
};
</script>

<style scoped>
.v-list-item {
  justify-content: center !important;
}
</style>