<script setup>

import { Input, Space, Button } from "ant-design-vue";
import {computed} from 'vue'
import{useRouter} from 'vue-router'
import {useStore} from 'vuex'
const router = useRouter();
const store = useStore();

const SignMultipleWalletAddresses = computed({
  get: ()=>store.state.SignMultipleWalletAddresses,
  set: (value)=>store.commit('setSignMultipleWalletAddresses',value),
})

const SetAddress = () => {
  router.push({name:'transactionDetail'})
}
</script>

<template>
  <div class="out1">
    <div class="in1">
      <div>创建交易</div>
      
      <Space direction="vertical">
        <Input v-model:value="SignMultipleWalletAddresses" placeholder="输入多签钱包地址" />
      </Space>
      <Button type="primary" @click="SetAddress">设置地址</Button>
    </div>
  </div>
</template>
<style lang="scss">
.out1 {
  width: 70vw;
  height: 70vh;
  // background-color: #000;

  display: flex;
  justify-content: center;

  .in1 {
    width: 100%;
    // 就看这四行; 有前三行, 没有最后一行, 就会自动对齐, 被拉到最大宽度;
    // 如果加了, 就不会;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    gap: 20px;

    Button {
      background-color: #282938;
    }
  }
}
</style>
