<script setup>
import TDetail from "../components/T-Detail.vue";
import TDetail2 from "../components/T-Detail2.vue";
import { Button } from "ant-design-vue";

import { ref, onMounted, onUnmounted, computed } from "vue";
let isRecordedTransaction = ref(true);

import {useStore} from 'vuex';
const store = useStore();

const SignMultipleWalletAddresses = computed({
  get:()=>store.state.SignMultipleWalletAddresses,
  set:(value)=>store.commit('setSignMultipleWalletAddresses',value),
})

const changeTransaction = () => {
  isRecordedTransaction.value = !isRecordedTransaction.value;
};
</script>

<template>
  <TDetail v-if="isRecordedTransaction">
    <!-- 我也不知道这两行是做什么的, 有什么用 -->
    <!-- <template #TDetail> </template> -->
  </TDetail>
  <TDetail2 v-if="!isRecordedTransaction">
    <!-- <template #TDetail> </template> -->
  </TDetail2>
  <div class="floor"><span>
  {{ SignMultipleWalletAddresses }}</span><Button class="button" @click="changeTransaction">切换交易</Button></div>
</template>
<style lang="scss">

.button{
  padding: 0 20px;
}

.floor {
  display: flex;
  justify-content: center;
  align-items: center;
  Button {
    background-color: #282938;
    color: #fff;
  }
}
</style>
