
<script setup>
import NavBar from "@/components/NavBar.vue";
import { RouterView } from "vue-router";

import Menu from "@/components/Menu.vue";
</script>

<template>
  <header><NavBar></NavBar></header>
  <div class="layout">
    <div class="side-menu">
      <Menu />
    </div>
    <main class="main-content">
      <RouterView />
    </main>
  </div>
</template>

<style lang="scss">
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}
.layout {
  display: flex;
  gap: 5vw;
  @media (max-width:920px) {
    gap:0vw;
  }
  .main-content {
  }
}
</style>

