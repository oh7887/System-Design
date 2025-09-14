<template>
  <div class="wrapper">
    <oneInput
      v-for="item in items"
      :key="item.id"
      :Text="item.Text"
      :placeholder1="item.placeholder1"
      :Button1="item.Button1"
    ></oneInput>
    <twoInput Text="改变所有者" placeholder1="输入需要改变的序号" placeholder2="输入所有者地址" Button1="改变所有者"></twoInput>
  </div>
</template>
<!--   Text: String,
  placeholder1: String,
  placeholder2: String,
  Button1: String, -->

<script setup>
import oneInput from "../components/oneInput.vue";
import twoInput from "../components/TwoInput.vue";
import { reactive } from "vue";
const items = reactive([
  {
    id: 1,
    Text: "增加合约所有者",
    placeholder1: "输入增加的地址",
    Button1: "确认",
  },
  {
    id: 2,
    Text: "减少合约所有者",
    placeholder1: "地址的序号",
    Button1: "确认",
  },
  {
    id: 3,
    Text: "交易所需签名数",
    placeholder1: "输入签名数",
    Button1: "确认",
  },
  {
    id: 4,
    Text: "改变最高所有者所有者",
    placeholder1: "输入新的最高所有者地址",
    Button1: "确认",
  },
  {
    id: 5,
    Text: "改变查看等级",
    placeholder1: "输入新的查看等级",
    Button1: "确认",
  },
]);
</script>

<style lang="scss" scoped>
.wrapper{
    height: 80vh;
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
    gap:5vh;
}
</style>
