<template>
  <v-footer class="rounded-t-xl c-footer" app absolute padless>
    <v-col class="text-center" cols="12">
      <strong class="accent--text">©</strong> {{ new Date().getFullYear() }} —
      <strong class="accent--text">GeopJr</strong> — BeardBin is a
      Zero-Knowledge Encrypted Text/Code sharing project written in Crystal
    </v-col>
  </v-footer>
</template>

<script>
export default {
  name: "Footer",
};
</script>

<style>
.c-footer {
  width: 100%;
  margin-top: 16px !important;
}
</style>
