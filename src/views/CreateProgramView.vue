<script setup>
import { Input, Space, Button, InputGroup } from "ant-design-vue";

import { ref, onMounted, computed } from "vue";

import { message } from "ant-design-vue";

import { useStore } from "vuex";
// 获取store对象
const store = useStore();

// import store from '@/store/index'

const AddOwnerAddress = ref("");

const OwnerIndex = ref(0);

const ReduceOwnerAddress = ref(0);
const ChangeOwnerAddressIndex = ref(0);
const ChangeOwnerAddress = ref("");

const approvalsRequired = ref(0);
const DataViewPermissionLevel = ref(0);

const OwnerAddressList = ref([]);
// const HoldMoneyAbi = store.state.web3.HoldMoneyAbi;

// const setInitialBudget = async (budget) => {
//   const accounts = await web3.eth.getAccounts();
//   await multisigWallet.methods.setInitialBudget(budget).send({ from: accounts[0] });
// };

onMounted(() => {
  // store.dispatch('initWeb3'); // 测试初始化, 测试成功; 但是这个函数不应该放在这里;
});

// 添加所有者地址
const addOwnerAddress = async () => {
  let hide = message.loading("正在添加所有者", 0);
  setTimeout(() => {
    hide();
    message.success("添加所有者成功");
    OwnerAddressList.value[OwnerIndex.value] = AddOwnerAddress.value;
    OwnerIndex.value++;
    AddOwnerAddress.value = "";
  }, 5000);
  await store.dispatch("addApprover", AddOwnerAddress.value); // 一定记得.value;;
  // hide();
  // message.success("添加所有者成功");
  // OwnerAddressList.value.push(AddOwnerAddress.value);
  // AddOwnerAddress.value = "";
};

const reduceOwnerAddress = async () => {
  let hide = message.loading("正在减少所有者", 10);
  setTimeout(() => {
    hide();
    message.success("减少所有者成功");
    OwnerAddressList.value[ReduceOwnerAddress.value] = "";
  }, 10000);
  await store.dispatch("removeApprover", ReduceOwnerAddress.value);
};

const changeOwnerAddress = async () => {
  let hide = message.loading("正在更改所有者", 6);
  setTimeout(() => {
    hide();
    message.success("更改所有者成功");
    OwnerAddressList.value[ChangeOwnerAddressIndex.value] =
      ChangeOwnerAddress.value;
  }, 6000);
  await store.dispatch("changeApprover", {
    index: ChangeOwnerAddressIndex.value,
    address: ChangeOwnerAddress.value,
  });
};

// 初始预算
const setBudget = async () => {
  const hide = message.loading("合约正在部署中", 20); // 0 表示一直存在, 直到手动关闭;
  await store.dispatch("initWeb3"); // 调用函数, 创建合约;
  hide();
  message.success("合约部署成功", 5);

  store.commit("setBudget", InitialBudget.value);
  console.log(store.state.budget);
  // console.log(InitialBudget.value);
};
const InitialBudget = computed({
  // 进行了一个绑定;
  get: () => store.state.budget,
  set: (value) => store.commit("setBudget", value),
});

// 添加预算
const addBudget = async (value) => {
  const hide = message.loading("正在添加预算", 2);
  setTimeout(() => {
    hide();
    message.success("添加预算成功", 2);
    store.commit("addBudget", value);
  }, 2000);
  // await store.dispatch("addBudget", value);
};
var addBudgetInput = ref(0);
// const addBudgetInput = computed({
//   get: () => store.state.budget,
//   set: (value) => store.commit("addBudget", value),
// });

// 减少预算
const cutBudget = async (value) => {
  const hide = message.loading("正在减少预算", 20);
  // await store.dispatch("cutBudget", value);
  setTimeout(() => {
    hide();
    message.success("添加预算成功", 2);
    store.commit("cutBudget", value);
  }, 2000);
};

var cutBudgetInput = ref(0);
// const cutBudgetInput = computed({
//   get: () => store.state.budget,
//   set: (value) => store.commit("cutBudget", value),
// });

const CreateMultiSigWallet = async () => {
  const hide = message.loading("正在创建钱包", 3);
  await store.dispatch("createWallet", {
    approvalsRequired: approvalsRequired.value,
    DataViewPermissionLevel: DataViewPermissionLevel.value,
  });
  hide();
  message.success("创建钱包成功", 2);
};
</script>

<template>

  <h1>创建项目</h1>
  <span>通过区块链创建你的项目</span>
  <h4>你的预算: {{ store.state.budget }}</h4>
  <div class="OutWrapper">
    <div class="wrapper">
      <div>
        <span>初始预算</span>
        <div class="inputSite">
          <Input
            size="large"
            v-model:value="InitialBudget"
            placeholder="输入你的预算"
          />
          <Button @click="setBudget">设置预算</Button>
        </div>
      </div>
      <div>
        <span>增加预算</span>
        <div class="inputSite">
          <Input
            size="large"
            v-model:value="addBudgetInput"
            placeholder="输入你想增加的预算"
          />

          <Button @click="addBudget(addBudgetInput)">增加预算</Button>
        </div>
      </div>
      <div>
        <span>减少预算</span>
        <div class="inputSite">
          <Input
            size="large"
            v-model:value="cutBudgetInput"
            placeholder="输入你想减少的预算"
          />
          <Button @click="cutBudget(cutBudgetInput)">减少预算</Button>
        </div>
      </div>
      <div>
        <span>增加所有者地址</span>
        <div class="inputSite">
          <Input
            class="aInput"
            size="large"
            v-model:value="AddOwnerAddress"
            placeholder="输入你想增加的地址"
          />

          <Button @click="addOwnerAddress">增加地址</Button>
        </div>
      </div>
      <div>
        <span>减少所有者地址</span>
        <div class="inputSite">
          <Input
            class="aInput"
            size="large"
            v-model="ReduceOwnerAddress"
            placeholder="输入你想去除的地址的序号"
          />
          <Button @click="reduceOwnerAddress">减少所有者地址</Button>
        </div>
      </div>
      <div class="OwnerIndex">
        <span>改变所有者地址</span>
        <div class="InputGroup">
          <Input
            size="large"
            v-model:value="ChangeOwnerAddressIndex"
            placeholder="输入改变地址的序号"
          />
          <Input
            size="large"
            v-model:value="ChangeOwnerAddress"
            placeholder="输入你想更改的地址"
          />
          <Button @click="changeOwnerAddress">改变所有者地址</Button>
        </div>
      </div>
    </div>
    <div class="Bottom">
      <h2>钱包创建</h2>
      <div class="WalletInputGroup">
        <Input
          size="large"
          v-model="approvalsRequired"
          placeholder="输入签名数"
        />
        <Input
          size="large"
          v-model="DataViewPermissionLevel"
          placeholder="输入数据查看等级"
        />
      </div>
      <Button @click="CreateMultiSigWallet">创建多签钱包</Button>
    </div>
    <!-- <div>
      <div>已添加的地址:</div>
      <div class="List" v-for="(item, index) in OwnerAddressList" :key="index">
        <div>{{ item }}</div>
      </div>
    </div> -->
  </div>
</template>
<style lang="scss">

:where(.css-dev-only-do-not-override-185kyl0).ant-btn {
    font-size: 14px;
    height: 32px;
    padding: 4px 0;
    border-radius: 6px;
}

.OutWrapper {
  display: flex;
  // justify-content: center; // 翻转之后, 这个无效了; 所以用align-items: center;
  align-items: center;
  margin-top: 6vh;
  flex-direction: column;

  Button {
    width: 130px;
    align-items: center;
  }
  .wrapper {
    display: grid;
    grid-template-columns: repeat(2, 30vw);
    gap: 20px;

    div {
      display: flex;
      flex-direction: column;
      align-items: flex-start;
      justify-content: center;
      gap: 5px;

      span {
        width: auto;
        padding: 0 10px;
        display: flex; // 更精确的定位在最左边
        justify-content: center;
      }
    }

    .OwnerIndex {
      .InputGroup {
        width: 30vw;

        display: flex;
        flex-direction: row;
        align-items: center;
        justify-content: center;
        gap: 20px;
      }
    }

    .inputSite {
      display: flex;
      flex-direction: row;
      align-items: center;
      // justify-content: flex-end;
      gap: 10px;
      .button-wrapper {
        flex-grow: 100; /* 这会使输入框尽可能地占据更多的可用空间 */
        flex-shrink: 1; /* 允许输入框在需要的时候缩小 */
        min-width: 0; /* 防止因为内容过多导致的溢出问题 */
      }
      .ant-input {
        // 默认类名
        // flex-grow: 100; /* 这会使输入框尽可能地占据更多的可用空间 */
        // flex-shrink: 1; /* 允许输入框在需要的时候缩小 */
        // min-width: 0; /* 防止因为内容过多导致的溢出问题 */
        // width: 10vw;
      }
      .ant-btn {
        // flex-shrink: 0;
        // width: 4.5vw;
      }
    }
  }
  .WalletInputGroup {
    width: 30vw;

    display: flex;
    flex-direction: row;
    align-items: center;
    justify-content: center;
    gap: 20px;
  }
  Button {
    background-color: #282938;
    color: #fff;
  }
  .Bottom {
    margin-top: 10vh;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 3vh;

    Button {
      width: auto;
      padding: 0 10px;
    }
  }
}
</style>
