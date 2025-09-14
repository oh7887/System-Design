<script setup>
import Web3 from "web3";
import DateTimeContractJson from "../contract/bin/DateTimeContract.json";
import MultiSigWalletJson from "../contract/bin/MultiSigWallet.json";
import holdmoneyJson from "../contract/bin/holdMoney.json";
import { Contract } from "web3-eth-contract";
import { onMounted, onUpdated, ref, defineExpose } from "vue";

const infuraAddress =
  "https://goerli.infura.io/v3/d7a32cb6f4584c29ad8b1b6b7e1c58c9";
// import Web3instance from "./init.js";
// import { web3instance, initializeWeb3 } from './init.js';

// const { web3instance } = Web3instance();

const web3instance = ref(null);
const initializeWeb3 = async () => {
  if (typeof window.ethereum !== "undefined") {
    web3instance.value = new Web3(window.ethereum);
    try {
      window.ethereum.request({ method: "eth_requestAccounts" }).then(() => {
        console.log(window.ethereum);
        console.log("以太坊浏览器插件已经连接");
      });
    } catch (e) {
      console.error("用户拒绝了连接请求");
    }
  }
};
// 部署合约, 返回promise会被解析成一个新的合约实例;
const DeployContract = async (contractName, artifacts, args, from, gas) => {
  console.log(`${contractName} is deploying...`);

  const accounts =
    web3instance.value && (await web3instance.value.eth.getAccounts()); //检索, 获取账号

  const contract =
    web3instance.value &&
    new web3instance.value.eth.Contract(DateTimeContractJson.abi);

  const contractDeploy = contract.deploy({
    data: DateTimeContractJson.bytecode, // 字节码'0x12345...',
    arguments: args, // 传递的数据,如 arguments: [123, 'My String']
  });

  const newConstractSend = await contractDeploy
    .send({
      from: from || accounts[0], //发送交易的以太坊地址
      gas: gas || 500000, // 交易的gas限制
      gasPrice: "30000000000", // 气价
    })
    .on("receipt", (receipt) => {
      // 监听收据
      console.log("部署合约的收据是", receipt);
    })
    .on("confirmation", (confirmationNumber, receipt) => {
      // 监听确认数
      console.log("部署合约的确认数是", confirmationNumber);
      console.log("部署合约的收据是", receipt);
    })
    .then((newContractInstance) => {
      console.log("部署合约的实例是", newContractInstance);
      return newContractInstance;
    })
    .catch((err) => {
      console.error("部署合约出错了", err);
    });
  return newConstractSend;
};
defineExpose({ DeployContract });

onMounted(async () => {
  await initializeWeb3();
  // DeployContract("DateTimeContract", DateTimeContractJson, []);
  // DeployContract("MultiSigWallet", MultiSigWalletJson, []);
  DeployContract("holdmoney", holdmoneyJson, []);
});
</script>

<template>
  <div>加一个标签</div>
  <!-- <web3instance :web3instance="web3"/> -->
  <!-- 正常的模板绑定 -->
  <!-- <div @click="DeployContract">测试一下部署</div> -->
</template>
<style lang="scss"></style>
