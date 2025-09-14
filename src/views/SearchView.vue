<script setup>
import { Input, Space, Button } from "ant-design-vue";
import Search from "@/components/Search.vue";
</script>

<template>
  <div class="space">
    <Search
      :title="'查看入账交易'"
      :Text1="'查看交易签名'"
      :Text2="'查看交易信息'"
      :Button1="'确认'"
      :Button2="'确认'"
    />
    <Search
      :title="'查看出账交易'"
      :Text1="'查看交易签名'"
      :Text2="'签名出账交易'"
      :Button1="'确认'"
      :Button2="'确认'"
    />
    <div class="owners">
      <h2>查看所有者</h2>
      <Button class="button" type="primary">确认</Button>
    </div>
  </div>
</template>
<style lang="scss">
.button{
  padding: 0 20px;
}
.space {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 40px;
  .owners {
    width: 20vw;
    display: flex;
    flex-direction: column;

    gap: 2vh;
  }
  Button {
    background-color: #282938;
  }
}
</style>
