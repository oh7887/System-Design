<template>
  <div style="width: 256px">
    <!-- <a-button
      type="primary"
      style="margin-bottom: 16px"
      @click="toggleCollapsed"
    >
      <MenuUnfoldOutlined v-if="state.collapsed" />
      <MenuFoldOutlined v-else />
    </a-button> -->
    <a-menu
      v-model:openKeys="state.openKeys"
      v-model:selectedKeys="state.selectedKeys"
      mode="inline"
      theme="dark"
      :inline-collapsed="state.collapsed"
      :items="items"
    ></a-menu>
  </div>
</template>
<script setup>
import { reactive, watch, h } from "vue";
import {
  PieChartOutlined,
  MailOutlined,
  DesktopOutlined,
  InboxOutlined,
  AppstoreOutlined,
} from "@ant-design/icons-vue";

const state = reactive({
  collapsed: false,
  selectedKeys: ["1"],
  openKeys: ["sub1"],
  preOpenKeys: ["sub1"],
});

watch(
  () => state.openKeys,
  (_val, oldVal) => {
    state.preOpenKeys = oldVal;
  }
);
const toggleCollapsed = () => {
  state.collapsed = !state.collapsed;
  state.openKeys = state.collapsed ? [] : state.preOpenKeys;
};

const items = reactive([
  {
    key: "1",
    icon: () => h(PieChartOutlined),
    label: "创建项目",
    title: "创建项目",
  },
  {
    key: "2",
    icon: () => h(DesktopOutlined),
    label: "交易",
    title: "交易",
  },
  {
    key: "3",
    icon: () => h(InboxOutlined),
    label: "查询",
    title: "查询",
  },
  {
    key: "4",
    icon: () => h(InboxOutlined),
    label: "其他",
    title: "其他",
  },
]);
</script>
<style>
:where(.css-dev-only-do-not-override-185kyl0).ant-menu-dark {
    color: rgba(255, 255, 255, 0.65);
    background: #1c1e53;
}
</style>