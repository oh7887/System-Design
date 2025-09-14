<script setup>
import{ Input, Button, InputGroup } from 'ant-design-vue'
import{defineProps} from 'vue'

const Items = defineProps({
  Text: String,
  placeholder1: String,
  Button1: String,
});


// 这里是为了第二个第二个交易页面专门写的组件; 

</script>

<template>
  <div class="out-box">
    <div class="box">
      <div>{{ Text }}</div>
      <InputGroup size="large" class="group">
        <Input :placeholder="Items.placeholder1" />
      </InputGroup>
      <Button class="button" type="primary">{{ Button1 }}</Button>
    </div>
  </div>
</template>
<style lang="scss">
.button{
  padding: 0 20px;
}
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
  .group {
    // 好家伙, 外层flex盒子嵌套内层flex盒子, 意外的实现了两个输入框并行的效果;
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

}
</style>