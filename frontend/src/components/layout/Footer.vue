<template>
  <v-footer class="rounded-t-xl c-footer" app absolute padless>
    <v-col class="text-center" cols="12">
      <strong class="accent--text">©</strong> {{ new Date().getFullYear() }} —
      <strong class="accent--text">GeopJr</strong> —
      <span v-if="!isMobile"
        >BeardBin is a Zero-Knowledge Encrypted Text/Code sharing project
        written in Crystal</span
      >
      <span id="loop" v-else
        >BeardBin <span>{{ words[tmp % words.length] }}</span></span
      >
    </v-col>
  </v-footer>
</template>

<script>
export default {
  name: "Footer",
  methods: {
    startInterval: function () {
      setInterval(() => {
        this.tmp++;
      }, 3000);
    },
  },
  mounted() {
    if (this.$vuetify.breakpoint.smAndDown) {
      this.startInterval();
    }
  },
  computed: {
    isMobile() {
      return this.$vuetify.breakpoint.smAndDown;
    },
  },
  data: () => ({
    words: ["has Zero-Knowledge", "is Encrypted", "is written in Crystal"],
    tmp: 0,
  }),
};
</script>

<style>
.c-footer {
  width: 100%;
  margin-top: 16px !important;
}

#loop > span {
  animation: change_underline 3.5s infinite alternate;
  text-decoration: underline;
  text-decoration-color: var(--v-accent-base);
  text-decoration-thickness: 2px;
}

@keyframes change_underline {
  0% {
    text-decoration-style: dashed;
  }
  100% {
    text-decoration-style: solid;
  }
}
</style>
