import { createStore } from "vuex";
import { ref } from "vue";
import Web3 from "web3";
import HoldMoneyJson from "@/contract/bin/holdMoney.json";
import MultiSigWallet from "@/contract/bin/MultiSigWallet.json";

import { message } from "ant-design-vue";
const { messageApi } = message.useMessage();

const HoldMoneyAbi = HoldMoneyJson.abi;
// 存储abi, 只要abi是同一个就行, 用于判断是否已经部署过合约;
localStorage.setItem("HoldMoneyAbi", HoldMoneyAbi);

const HoldMoneyAddress = ref(undefined);

export default createStore({
  state: {
    web3: null,
    contract: null,
    contractStatus: "尚未部署",
    deployedContractAddress: undefined, // 已部署的合约地址
    approvers: [], // 批准者地址列表
    approvalsRequired: 0, // 所需批准数量
    budget: 1, // 初始预算
    SignMultipleWalletAddresses: "", // 多签钱包的地址

    transactionStatus: null, // 交易状态
  },
  mutations: {
    // 设置web3实例
    setWeb3(state, web3) {
      state.web3 = web3;
    },
    // 设置合约实例
    setContract(state, contract) {
      state.contract = contract;
    },
    setContractStatus(state, Status) {
      state.contractStatus = Status;
    },
    setBudget(state, amount) {
      state.budget = amount;
    },
    addBudget(state, amount) {
      state.budget += parseInt(amount);
    },
    cutBudget(state, amount) {
      state.budget -= parseInt(amount);
    },
    setApprovers(state, approvers) {
      state.approvers = approvers;
    },
    setApprovalsRequired(state, approvalsRequired) {
      state.approvalsRequired = approvalsRequired;
    },

    setSignMultipleWalletAddresses(state, x) {
      state.SignMultipleWalletAddresses = x;
    },
    setTransactionStatus(state, status) {
      state.transactionStatus = status;
    },
  },
  actions: {
    async initWeb3() {
      if (window.ethereum) {
        try {
          //请请求用户授权账户
          const accounts = await window.ethereum.request({
            method: "eth_requestAccounts",
          });

          console.log("account: " + accounts);
          //创建web3对象
          const web3 = new Web3(window.ethereum);
          // 设置web3实例
          this.commit("setWeb3", web3);

          // 存不了
          // 存到localStorage中
          // localStorage.setItem("web3", web3);

          // 设置provider
          web3.setProvider(window.ethereum);
          // 设置默认账户为第一个账户
          web3.eth.defaultAccount = accounts[0];
          // 创建合约实例, 做准备
          const contract = new web3.eth.Contract(HoldMoneyAbi);
          const ByteCode = HoldMoneyJson.bytecode;

          // 为估算gas部署新合约
          // const estimatedGas = await contract.deploy({
          //   data: ByteCode,
          //   arguments: [this.state.budget],
          // }).estimateGas({
          //   from: web3.eth.defaultAccount,
          // });

          // 再部署一次
          const deployedContract = await contract
            .deploy({
              data: ByteCode,
              arguments: [this.state.budget],
            })
            .send({
              from: web3.eth.defaultAccount,
              gas: 29999999,
            });
          // 存储合约实例
          this.commit("setContract", deployedContract);

          // console.log(deployedContract);
          this.deployedContractAddress = deployedContract.options.address;

          // 存储到localStorage
          localStorage.setItem("contractAddress", this.deployedContractAddress);

          console.log("合约已部署到地址: ", this.deployedContractAddress);

          return { web3, contract: deployedContract };
        } catch (error) {
          // 处理用户拒绝或其他错误
          console.error(error + "用户拒绝或有其他错误");
        }
      } else {
        messageApi.error("请安装metamask插件");
      }
    },
    // 添加初始预算;
    async addBudget({ state, commit }, amount) {
      const ContractAddress = localStorage.getItem("contractAddress");

      if (!state.web3) {
        const web3 = new Web3(window.ethereum);
        commit("setWeb3", web3);
        web3.setProvider(window.ethereum);
        web3.eth.defaultAccount = ContractAddress;
      }

      if (!state.contract) {
        const contract = new state.web3.eth.Contract(
          HoldMoneyAbi,
          ContractAddress
        );
        commit("setContract", contract);
      }

      try {
        // 调用合约方法设置增加初始预算
        console.log("addBudget: " + amount);
        await state.contract.methods
          .addBudget(amount)
          .send({ from: state.web3.eth.defaultAccount, gas: 29999999 });
        console.log("addBudget成功");
        commit("addBudget", amount);
      } catch (error) {
        console.error("设置初始预算出错：", error);
        throw error;
      }
    },
    // 减少初始预算;
    async cutBudget({ state, commit }, amount) {
      try {
        if (!state.web3 || !state.contract) {
          throw new Error("Web3或合约实例尚未初始化");
        }
        // 调用合约方法设置初始预算
        await state.contract.methods
          .cutBudget(amount)
          .send({ from: state.web3.eth.defaultAccount, gas: 29999999 });
        commit("cutBudget", amount);
      } catch (error) {
        console.error("设置初始预算出错：", error);
        throw error;
      }
    },
    // 添加签名者的接口
    async addApprover({ state, dispatch, commit }, approverAddress) {
      const ContractAddress = localStorage.getItem("contractAddress");

      if (!state.web3) {
        const web3 = new Web3(window.ethereum);
        commit("setWeb3", web3);
        web3.setProvider(window.ethereum);
        web3.eth.defaultAccount = ContractAddress;
      }

      if (!state.contract) {
        const contract = new state.web3.eth.Contract(
          HoldMoneyAbi,
          ContractAddress
        );
        commit("setContract", contract);
      }

      const { contract, web3 } = state;

      try {
        

        await contract.methods
          .pushPoweFulMan(approverAddress)
          .send({ from: web3.eth.defaultAccount, gas: 29999999 });


      } catch (error) {
        console.error("添加所有者出错", error);
      }
    },
    // 获取签名者列表
    // async fetchApprovers({ state, commit }) {
    //   try {
    //     if(!state.web3 || !state.contract) {
    //       throw new Error('web3或contract未初始化');
    //     }
    //     const { contract } = state;
    //     const approvers = await contract.methods.getApprovers().call();
    //     commit('setApprovers', approvers);
    //     return approvers;
    //   }catch (error) {
    //     console.error("获取所有者出错",error);
    //   }
    // },
    // 减少签名者的接口
    async removeApprover({ state, dispatch, commit }, approverAddress) {
      try {
        if (!state.web3 || !state.contract) {
          throw new Error("web3或contract未初始化");
        }
        const { contract, web3 } = state;
        await contract.methods
          .popPoweFulMan(approverAddress)
          .send({ from: web3.eth.defaultAccount, gas: 29999999 });
        // dispatch("fetchApprovers");
      } catch (error) {
        console.error("删除所有者出错", error);
      }
    },
    async changeOwnerAddress({ state, dispatch, commit }, newOwnerAddress, oldOwnerAddress) {

    },
    // 创建钱包
    async createWallet(
      { state, commit },
      approvalsRequired,
      DataViewPermissionLevel
    ) {
      const ContractAddress = localStorage.getItem("contractAddress");
      if (!state.web3) {
        const web3 = new Web3(window.ethereum);
        commit("setWeb3", web3);
        web3.setProvider(window.ethereum);
        web3.eth.defaultAccount = ContractAddress;
      }

      if (!state.contract) {
        const contract = new state.web3.eth.Contract(
          HoldMoneyAbi,
          ContractAddress
        );
        commit("setContract", contract);
      }
      try {
        const accounts = await window.ethereum.request({
          method: "eth_requestAccounts",
        });
        // const { contract, web3 } = state;
        // const accounts = await this.web3.eth.getAccounts();
        const receipt = await this.contract.methods
          .createContract(approvalsRequired, DataViewPermissionLevel)
          .send({
            from: accounts[0], // 使用第一个账户作为发送方
            gas: 29999999,
          });
        console.log("新的MultiSigWallet合约已创建, 交易收据:", receipt);
      } catch (error) {
        console.error("创建钱包出错：", error);
        throw error;
      }
    },
    // 创建入账交易
    async submitTransaction({ commit }, { value, data }) {
      // 这两个数据分别是交易金额和交易详情, 备注;
      try {
        const result = await this.contract
          .submitTransaction(this.SignMultipleWalletAddresses, value, data)
          .send({ from: this.SignMultipleWalletAddresses });
        commit("setTransactionStatus", "创建成功");
      } catch (error) {
        commit("setTransactionStatus", "创建失败");
        commit("setTransactionError", error.message);
        console.error(error);
      }
    },
    //签名入账交易
    async confirmTransaction({ commit }, { txid }) {
      try {
        const result = await this.contract
          .confirmTransaction(txid)
          .send({ from: this.SignMultipleWalletAddresses });
        commit("setTransactionStatus", "签名入账交易成功");
      } catch (error) {
        commit("setTransactionStatus", "签名入账交易失败");
        commit("setTransactionError", error.message);
        console.error(error);
      }
    },
    //撤销签名
    async revokeConfirmation({ commit }, { txid }) {
      try {
        const result = await this.contract
          .revokeConfirmation(txid)
          .send({ from: this.SignMultipleWalletAddresses });
        commit("setTransactionStatus", "撤销签名成功");
      } catch (error) {
        commit("setTransactionStatus", "撤销签名失败");
        commit("setTransactionError", error.message);
        console.error(error);
      }
    },
    //完成交易;
    async executeTransaction({ commit }, { txid }) {
      try {
        const result = await this.contract
          .revokeConfirmation(txid)
          .send({ from: this.SignMultipleWalletAddresses });
        commit("setTransactionStatus", "完成交易成功");
      } catch (error) {
        commit("setTransactionStatus", "完成交易失败");
        commit("setTransactionError", error.message);
        console.error(error);
      }
    },
  },
});
