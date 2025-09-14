<script setup>
import Web3 from "web3";

import { ref, onMounted, defineProps } from "vue";

// 连接小狐狸钱包的一段操作
const web3instance = ref(null);

function initializeWeb3() {
  if (typeof window.ethereum !== "undefined") {
    web3instance.value = new Web3(window.ethereum);
    try {
      window.ethereum.request({ method: "eth_requestAccounts" }).then(() => {
        console.log(window.ethereum);
        console.log("以太坊浏览器插件已经连接");
      });
    } catch (e) {
      console.error("用户拒绝了连接请求");
    }
  }
}
defineExpose({ web3instance, initializeWeb3 });
</script>

<template>
  <div>deploy的标签</div>
</template>
<style lang="scss"></style>
