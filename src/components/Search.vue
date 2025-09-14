<script setup>
import { ref, defineProps } from "vue";
import { Input, Button, InputGroup } from "ant-design-vue";

const Items = defineProps({
  title: String,
  Text1: String,
  Text2: String,
  Button1: String,
  Button2: String,
});
</script>

<template>
  <h3>{{ title }}</h3>
  <div class="out-box">
    <div class="box">
      <div>{{ Text1 }}</div>
      <InputGroup size="large" class="group">
        <Input placeholder="输入交易序号" />
        <Input placeholder="输入查询地址" />
      </InputGroup>

      <Button type="primary">{{ Button1 }}</Button>
    </div>
    <div class="box">
      <div>{{ Text2 }}</div>
      <InputGroup size="large">
        <Input placeholder="输入交易序号" />
      </InputGroup>
      <Button type="primary">{{ Button2 }}</Button>
    </div>
  </div>
</template>
<style lang="scss">
.out-box {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;

  gap: 30px;
  Button {
    background-color: #282938;
  }
}
.box {
  width: 50vw;
  display: flex;
  flex-direction: row;
  align-items: center;
  .group { // 好家伙, 外层flex盒子嵌套内层flex盒子, 意外的实现了两个输入框并行的效果;
    display: flex;
    flex-direction: row;
    align-items: center;
    justify-content: center;
    gap: 10px;
  }

  div {
    flex-shrink: 0; // 防止缩小, 使得文本不换行
  }
  // justify-content: center;
  gap: 10px;

  // 不生效
  // InputGroup {
  //   flex-shrink: 0;
  //   max-width: 2vw;
  //   Input {
  //     max-width: 2vw;
  //     flex-shrink: 0;
  //   }
  // }
}
</style>
