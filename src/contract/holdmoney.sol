// SPDX-License-Identifier: MIT
pragma solidity  ^0.8.0;
import "./MultiSigWallet.sol";
contract holdMoney
{
    address public owner;
    address[] public  PowerFulMan;
    uint256 public Budget;//预算
    uint256 public number=1;
    uint public viewAccess=1;/*数据查看权限等级 分为1-3级 1级：可以查看所有交易信息 2级：可以查看部分交易信息 3级:只能查看加密后的交易信息*/

    MultiSigWallet public mu;
    mapping(address => bool) public isOwner;
    /*
    一个事件，当创建新的MultiSigWallet合约时会触发。它包括新创建合约和合约所有者的地址。*/
constructor(uint256 budget) public
    {
        Budget=budget;
        PowerFulMan.push(msg.sender);
        owner=msg.sender;
        isOwner[msg.sender]=true;
    }/*构造函数接受一个初始预算作为参数，并将其设置为Budget。
它将PoweFulMan数组初始化为合约部署者（msg.sender）作为第一个所有者，并将owner设置为合约部署者。*/
    
   modifier checkRight
   {
       require(owner == msg.sender,"you are not the owner");
       _;
   }
   function addBudget(uint256 count)public checkRight
   {
       require(address(mu)==address(0),"the contract is exsit");
       Budget+=count;
   }//允许所有者在多签钱包部署前增加预算。
   function cutBudget(uint256 count) public checkRight
   {
       require(address(mu)==address(0),"the contract is exsit");
       Budget-=count;
   }//允许所有者在多签钱包部署前减少预算
     function pushPoweFulMan(address p) public checkRight
    {
        require(address(mu)==address(0),"the contract is exsit");
        require(!isOwner[p],"the powerfulman has exist");
        isOwner[p]=true;
        PowerFulMan.push(p);
        number=PowerFulMan.length;
    }//所有者将新的所有者添加到PoweFulMan数组。
    function popPoweFulMan(uint who) public checkRight
    {
        require(who>1,"can not do it");
         who--;
        require(address(mu)==address(0),"the contract is exsit");
    require(who<=PowerFulMan.length&&who>0,"wrong index");
    require(isOwner[PowerFulMan[who]],"the powerfulman has exist");
    isOwner[PowerFulMan[who]]=false;
    address tmp= PowerFulMan[PowerFulMan.length-1];
    PowerFulMan[PowerFulMan.length-1]=PowerFulMan[who];
    PowerFulMan[who]=PowerFulMan[PowerFulMan.length-1];
    PowerFulMan.pop();
    number--;
    }
    //所有者从PowerFulMan数组中删除所有者的地址。
    function changepowerfulman(uint who,address change) public checkRight{
         require(address(mu)==address(0),"the contract is exsit");
         require(who<=PowerFulMan.length&&who>0,"wrong index");
         require(who>1,"can not do it");
        who--;
        require(isOwner[PowerFulMan[who]],"the powerfulman has exist");
        isOwner[change]=true;
        isOwner[PowerFulMan[who]]=false;
        PowerFulMan[who]=change;
    }
        function createContract(uint i,uint level) public checkRight
        {
            require(viewAccess>=1&&viewAccess<=3,"the level is not exsit");
            require(i<PowerFulMan.length&&i>0,"wrong number");
            address[] memory addresser=PowerFulMan;
            mu = new MultiSigWallet(addresser,i,Budget,level);    
        }//所有者创建新的MultiSigWallet合约 输入同意交易需要的人数和数据查看权限等级.
}