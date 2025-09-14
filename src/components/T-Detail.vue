<script setup>


// 注意语法, 是slot代替子组件标签里面的东西; 
import TwoInput from './TwoInput.vue';
import oneInput from './oneInput.vue'
</script>

<template>\
    <h2>入账交易</h2>
    <div class="wrapper">
      <TwoInput Text="创建入账交易" placeholder1="输入入账金额" placeholder2="输入交易详情和备注" Button1="提交"/>
      <oneInput Text="签名入账交易" placeholder1="输入交易序号" Button1="确认"></oneInput>
      <oneInput Text="撤销签名" placeholder1="输入交易序号" Button1="撤销"></oneInput>
      <oneInput Text="完成交易" placeholder1="输入交易序号" Button1="确认"></oneInput>
      <oneInput Text="撤销已完成交易签名" placeholder1="输入交易序号" Button1="确认" />
      <TwoInput Text="撤销已完成交易" placeholder1="输入交易序号" placeholder2="输入交易详情和备注" Button1="确认"/>
    </div>
</template>
<style lang="scss">
.wrapper {
  width: 100%;
  height: 100%;
  padding: 20px 20px;
  display: flex;
  justify-content: center;
  align-items: center;
  flex-direction: column;

  gap:5vh;
}
</style>