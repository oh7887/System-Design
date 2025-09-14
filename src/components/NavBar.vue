<script setup>
import { ref } from "vue";
import { useRouter, RouterLink } from "vue-router";
const router = useRouter();

let NarData = ref([
  {
    content: "区块链",
    name: "",
    path: "/",
  },
  // {
  //   name: "首页",
  //   path: "/",
  // },
  {
    content: "创建项目",
    name:"CreateProgram",
    path: "/CreateProgram",
  },
  {
    content: "交易",
    name:"transaction",
    path: "/transaction",
  },
  {
    content:"查询",
    name: "SearchView",
    path: "/SearchView",
  },
  {
    content: "其他",
    name:"Others",
    path: "/Others",
  },
  // {
  //   name: "连接钱包",
  //   path: "/",
  // },
]);
</script>

<template>
  <div class="nav">
    <div class="" @click="router.push({ name: 'HomeView' })">
      {{ NarData[0].content }}
    </div>
    <div class="right-nav">
      <div v-for="item in NarData" :key="item.name">
        <div @click="router.push({path:item.name})">
          {{ item.content !== "区块链" ? item.content : "" }}
        </div>
      </div>
    </div>
  </div>
</template>

<style lang="scss">
.nav {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px 20px; // 先上下, 后左右;

  background-color: #1c1e53;
  // background-color: #3439bd;
  color: #fff;
  .right-nav {
    display: flex;
    // justify-content: space-between;
    // align-items: center;
    // width: 50%;
    RouterLink {
      color: #fff; /* 例如，改为蓝色 */
    }
  }
  .right-nav > div {
    margin-left: 40px;
  }
}
.nav:hover {
    cursor: pointer;
  }
</style>
