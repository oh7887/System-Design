pragma solidity ^0.8.0;
import "./DateTimeContract.sol";
contract MultiSigWallet {
    address[] public owners;
    uint public requiredSignatures;
    mapping(address => bool) public isOwner;
    mapping(uint => bool) public usedtransationsIndex;
    mapping(uint => bool) public usedearnIndex;
    uint public transactionCount;
    uint256 public  budget;//预算数量
    uint public  earnmoneyCount;//进账交易的数量
    DateTimeContract public time;//得到时间戳
    uint public level;
    event SubmitTransaction(address indexed sender, uint indexed txId, address indexed destination, uint value, string data);
    event ConfirmTransaction(address indexed sender, uint indexed txId);
    event RevokeConfirmation(address indexed sender, uint indexed txId);
    event ExecuteTransaction(address indexed sender, uint indexed txId, address indexed destination, uint value, string data);
    event submitEarnmoney(address indexed sender,uint value,string data,uint index);
    event ConfirmEarnmoney(address indexed sender,uint indexed  index,uint indexed value);
    event RevokeEarnmoney(address indexed sender,uint indexed index,uint indexed value);
    event addbudget(address indexed sender,uint indexed value);
    
struct Transaction {
        address destination;//转账地址
        address sender;//提出交易的人
        uint value;//交易数目
        string data;//记录交易数据和细节备注
        bool executed;//交易状态
        uint numConfirmations;//交易已得到的签名人数
        string submitTransactiontime;//交易确认时间
        string executeTransactiontime;//交易通过时间
        uint revokeAlreadyTransactioncount;//确认撤销交易的人数
        bytes32  signature;//交易数据加密

    }
struct Earnmoney{
        uint value;//交易数目
        string data;//记录交易数据和细节备注
        bool executed;//交易状态
        uint numConfirmations;//交易已得到的签名人数
        address sender;//交易发起人
        string submitearnMoneytime;//提出入账交易时间
        string earnMoneytime;//完成入账交易时间
        uint revokeAlreadyEarnmoneycount;//确认撤销交易的人数
        bytes32  signature;//交易数据加密
    }
 mapping(uint => Transaction) public transactions;
    mapping(uint => mapping(address => bool)) public confirmations;
    mapping(uint => Earnmoney) public EarnMoney;
    mapping(uint => mapping(address => bool)) public confirmationsearnmoney;

    mapping(uint => mapping(address => bool)) public revokealreadyTransaction;
    mapping(uint => mapping(address => bool)) public revokealreadyEarnmoney;
    constructor(address[] memory _owners, uint _requiredSignatures,uint256 counts,uint L) {
        
        budget = counts;
        require(_owners.length >_requiredSignatures, "Owners required");
        require(_requiredSignatures > 0 && _requiredSignatures < _owners.length, "Invalid number of required signatures");
        for (uint i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            require(owner != address(0), "Invalid owner address");
            require(!isOwner[owner], "Duplicate owner");
            isOwner[owner] = true;
            owners.push(owner);//将owner装入数组
            time =new DateTimeContract();
        }
        requiredSignatures = _requiredSignatures;//需要签名数
        level=L;
    }/*在部署合约时，需要传入一个包含所有者地址的数组 _owners 和所需的签名数量 _requiredSignatures。合约只有这些地址的所有者可以执行交易签名。*/

    function submitTransaction(address _destination, uint256 _value, string memory _data) public {
          require(_value<=budget,"budget is not enough");
        require(isOwner[msg.sender], "Not an owner");
        require(_destination != address(0), "Invalid destination address");
        require(bytes(_data).length > 0, "Data required");
        uint txId = transactionCount;
        usedtransationsIndex[transactionCount]=true;
        transactionCount++;
          transactions[txId] = Transaction({
            destination: _destination,
            value: _value,
            data: _data,
            executed: false,
            numConfirmations: 0,
            sender: msg.sender,
            submitTransactiontime:time.getCurrentDateTime(),
            executeTransactiontime:"not",
            revokeAlreadyTransactioncount:0,
            signature:bytes32(0)
        });//初始化交易
        confirmations[txId][msg.sender] = true;

        emit SubmitTransaction(msg.sender, txId, _destination, _value, _data);
       
    }/*合约的owner可以调用此函数来创建新的交易请求
    包括目的地地址 _destination、转账金额 _value、交易数据 _data 
    一旦交易被提交，会触发 SubmitTransaction 事件，在签名足够后可确认该交易*/

    function confirmTransaction(uint _txId) public {
        _txId--;
     require(usedtransationsIndex[_txId],"wrong idex");//确认交易序号存在
        require(isOwner[msg.sender], "Not an owner");//具有签名资格的人确认交易
        require(transactions[_txId].destination != address(0), "Invalid transaction ID");//发送的地址不为0
        require(!confirmations[_txId][msg.sender], "Already confirmed");//禁止同一地址反复对同一个交易进行签名
        confirmations[_txId][msg.sender] = true;
        transactions[_txId].numConfirmations += 1;//签名数加一
        emit ConfirmTransaction(msg.sender, _txId);
        
    }/*合约的所有者可以调用此函数来确认之前提交的交易请求，
    一旦确认，就认为完成签名*/
    function revokeConfirmation(uint _txId) public {
        _txId--;
     require(usedtransationsIndex[_txId],"wrong idex");
        require(isOwner[msg.sender], "Not an owner");
        require(confirmations[_txId][msg.sender], "Has not confirmed");//你得先同意交易 才能撤销交易
        confirmations[_txId][msg.sender] = false;
        transactions[_txId].numConfirmations -= 1;//签名数减一
        emit RevokeConfirmation(msg.sender, _txId);
    }
    
    function executeTransaction(uint _txId) public   {
      _txId--;
     require(usedtransationsIndex[_txId],"wrong idex");
    require(isOwner[msg.sender], "Not an owner");
    require(transactions[_txId].destination != address(0), "Invalid transaction ID");//拒绝0地址
    require(transactions[_txId].numConfirmations >= requiredSignatures, "Not enough confirmations");//签名数大于要求
    require(!transactions[_txId].executed, "Already executed");//交易没有被执行过
    transactions[_txId].executed = true;//交易执行状态更改
     
   budget-=transactions[_txId].value;
   transactions[_txId].signature= keccak256(
            abi.encodePacked(
                transactions[_txId].destination,
                transactions[_txId].sender,
                transactions[_txId].value,
                transactions[_txId].data,
                transactions[_txId].numConfirmations,
                transactions[_txId].submitTransactiontime,
                transactions[_txId].executeTransactiontime
            )
        );
       emit ExecuteTransaction(msg.sender, _txId, transactions[_txId].destination, transactions[_txId].value, transactions[_txId].data);
}/*这个函数由合约自动调用，当交易达到所需签名数量时，就可以输入序号使交易执行，并触发 ExecuteTransaction 事件。*/
function getOwners() public view returns (address[] memory) {
    return owners;
}//调用此函数来查看合约的所有者地址。

function isConfirmedtransation(uint _txId, address _owner) public view returns (bool) {
    _txId--;
    return confirmations[_txId][_owner];
}//调用此函数来检查指定的出账交易是否已被指定的所有者签名

function getTransaction(uint _txId) public view returns (address destination, uint value, string memory data, bool executed, uint numConfirmations,address send,string memory submitTransactiontime,string memory executeTransactiontime,bytes32 signature,uint revokeAlreadyTransactioncount) {
   _txId--;
        require(usedtransationsIndex[_txId],"wrong index");
   signature= transactions[_txId].signature;

        Transaction storage transaction = transactions[_txId];
        if(isOwner[msg.sender]||level==1)
    {
        destination = transaction.destination;
    value = transaction.value;
    data = transaction.data;
    }
    if(isOwner[msg.sender]||level<3){
    executed = transaction.executed;
    numConfirmations = transaction.numConfirmations;
    send=transaction.sender;
    submitTransactiontime=transaction.submitTransactiontime;
    executeTransactiontime=transaction.executeTransactiontime;
    revokeAlreadyTransactioncount=transaction.revokeAlreadyTransactioncount;
    }
//只有合约的owner可以查看全部信息 或者查看权限为1
}//调用此函数来查看指定交易的目的地地址、价值、数据、执行状态和确认次数等数据。
function submitearnMoney(uint count,string memory _data)public {
  
     require(isOwner[msg.sender], "Not an owner");
    require(bytes(_data).length > 0, "Data required");
    uint index =  earnmoneyCount;
    usedearnIndex[earnmoneyCount]=true;
     earnmoneyCount++;
     require (count!=0,"the number of count is wrong");
     require(!EarnMoney[index].executed,"Already executed"); //交易没有执行过
     EarnMoney[index].sender=msg.sender;
        EarnMoney[index] = Earnmoney({                                           
            value: count,
            data: _data,
            executed: false,
            numConfirmations: 0,
            sender: msg.sender,
            submitearnMoneytime:time.getCurrentDateTime(),
            earnMoneytime:"not",
            revokeAlreadyEarnmoneycount:0,
            signature:bytes32(0)
        });//初始化交易
        confirmationsearnmoney[index][msg.sender] = true;//禁止提出交易的人自己同意
        emit submitEarnmoney(msg.sender,count,_data,index);
}//输入入账金额count 和交易data 提出入账交易
function confirmearnMoney(uint index) public
{
    require(index>0,"wrong index");
     index--;
     require(usedearnIndex[index],"wrong index");//确认交易存在
     require(isOwner[msg.sender], "Not an owner");//具有签名资格的人确认交易
        require(!confirmationsearnmoney[index][msg.sender], "Already confirmed");//禁止同一地址反复对同一个交易进行签名
        require(!EarnMoney[index].executed,"Already executed"); //交易没有执行过
        confirmationsearnmoney[index][msg.sender] = true;
        EarnMoney[index].numConfirmations += 1;//签名数加一
     emit ConfirmEarnmoney(msg.sender,index, EarnMoney[index].value);
}//输入入账交易序号 所有者签名 

 function revokeearnMoney(uint index) public {
     index--;
     require(usedearnIndex[index],"wrong idex");
        require(isOwner[msg.sender], "Not an owner");
        require(confirmationsearnmoney[index][msg.sender], "Has not confirmed");//你得先同意交易 才能撤销交易
        require(!EarnMoney[index].executed,"Already executed"); //交易没有执行过
         confirmationsearnmoney[index][msg.sender] = false;
        EarnMoney[index].numConfirmations -= 1;//签名数减一
       emit  RevokeEarnmoney(msg.sender,index, EarnMoney[index].value);
    }//输入入账交易序号 以签名的所有者撤销签名
   
function earnMoney(uint index) public 
{
     index--;
     require(usedearnIndex[index],"wrong idex");
     require(isOwner[msg.sender], "Not an owner");
    require(EarnMoney[index].numConfirmations>=requiredSignatures,"Not enough confirmations");//签名数达到需求
    require(!EarnMoney[index].executed,"Already executed"); //交易没有执行过
    EarnMoney[index].executed=true;//更改进账交易状态
    EarnMoney[index].earnMoneytime=time.getCurrentDateTime();
    budget+= EarnMoney[index].value;
     EarnMoney[index].signature= keccak256(
            abi.encodePacked(
               EarnMoney[index].value,
                EarnMoney[index].data,
               EarnMoney[index].executed,
                EarnMoney[index].numConfirmations,
                EarnMoney[index].sender,
                EarnMoney[index].submitearnMoneytime,
                EarnMoney[index].earnMoneytime
            )
        );//加密数据
  emit   addbudget(msg.sender,EarnMoney[index].value);
}//完成入账交易 并加密交易数据

function isConfirmedtransationEarn(uint _txId, address _owner) public view returns (bool) {
    _txId--;
    return confirmationsearnmoney[_txId][_owner];
}//调用此函数来检查指定的交易是否已被指定的所有者签名

function getearnmoney(uint index) public view returns (uint value,string memory data, bool execute, uint numConfirmations,address sender,string memory submitearnMoneytime,string memory earnMoneytime,bytes32 signature,uint revokeAlreadyEarnmoneycount){
         
        index--;
        require(usedearnIndex[index],"wrong index");
    signature = EarnMoney[index].signature;
    if(isOwner[msg.sender]||level<3){
     execute = EarnMoney[index].executed;
      submitearnMoneytime=EarnMoney[index].submitearnMoneytime;
    earnMoneytime=EarnMoney[index].earnMoneytime;
    numConfirmations =EarnMoney[index].numConfirmations;
    revokeAlreadyEarnmoneycount=EarnMoney[index].revokeAlreadyEarnmoneycount;
    }
   if(isOwner[msg.sender]||level==1){
    value=EarnMoney[index].value;
    data=EarnMoney[index].data;
    sender=EarnMoney[index].sender;
   }

}//查看进账交易详情

function revokeAlreadyTransaction(uint _txId) public {
     _txId--;
        require(usedtransationsIndex[_txId],"wrong index");
        require(isOwner[msg.sender], "Not an owner");
        require(transactions[_txId].executed, "not executed");//交易被执行过
        require(!revokealreadyTransaction[_txId][msg.sender], "Already confirmed");//同一个人不能多次签字撤销
         
        revokealreadyTransaction[_txId][msg.sender] = true;
        transactions[_txId].revokeAlreadyTransactioncount+=1;
}//本函数用于撤销以成交的出账交易 输入交易序号 可以不需要在确认时同意就可以撤销

function cancellationTransaction(uint _txId,string memory data) public {
     _txId--;
        require(usedtransationsIndex[_txId],"wrong index");
  require(isOwner[msg.sender], "Not an owner");
    require(transactions[_txId].destination != address(0), "Invalid transaction ID");//拒绝0地址
   require( transactions[_txId].revokeAlreadyTransactioncount>=requiredSignatures,"Not enough confirmations" );
    require(transactions[_txId].executed, "not executed");//交易已经被执行过
   
    transactions[_txId].executed = false;//交易执行状态更改
     budget +=transactions[_txId].value;
   transactions[_txId].data=data;
   transactions[_txId].submitTransactiontime="cancel";
    transactions[_txId].executeTransactiontime="cancel";
     transactions[_txId].numConfirmations =0;
       transactions[_txId].signature= keccak256(
            abi.encodePacked(
                transactions[_txId].destination,
                transactions[_txId].sender,
                transactions[_txId].value,
                transactions[_txId].data,
                transactions[_txId].numConfirmations,
                transactions[_txId].submitTransactiontime,
                transactions[_txId].executeTransactiontime
            )
        );//重新加密交易
}//当撤销交易的签名数量达到要求 撤销出账交易

function revokeAlreadyEarnmoney(uint index) public {
     index--;
     require(usedearnIndex[index],"wrong index");
    require(isOwner[msg.sender], "Not an owner");
    require(EarnMoney[index].executed,"Already executed"); //交易执行过
     require(!revokealreadyEarnmoney[index][msg.sender], "Already confirmed");//同一个人不能多次签字撤销
    revokealreadyEarnmoney[index][msg.sender] = true;
     EarnMoney[index].revokeAlreadyEarnmoneycount += 1;//签名数加一
}//签名撤销入账交易

function cancellationEarnmoney(uint index,string memory data) public {
    index--;
    require(isOwner[msg.sender], "Not an owner");
    require(EarnMoney[index].revokeAlreadyEarnmoneycount>=requiredSignatures,"Not enough confirmations");//签名数达到要求
    require(EarnMoney[index].executed,"Already executed"); //交易执行过
     
    require(usedearnIndex[index],"wrong index");
    budget-=EarnMoney[index].value;
    EarnMoney[index].executed=false;//更改进账交易状态
    EarnMoney[index].data=data;
    EarnMoney[index].submitearnMoneytime="cancel";
    EarnMoney[index].earnMoneytime="cancel";
    EarnMoney[index].numConfirmations=0;
        EarnMoney[index].signature= keccak256(
            abi.encodePacked(
               EarnMoney[index].value,
                EarnMoney[index].data,
               EarnMoney[index].executed,
                EarnMoney[index].numConfirmations,
                EarnMoney[index].sender,
                EarnMoney[index].submitearnMoneytime,
                EarnMoney[index].earnMoneytime
            )
        );
}//撤销交易
function popowner(uint256 who) public 
    {
        require(msg.sender==owners[0],"do not have right");
        uint index;
        index=who-1;
        isOwner[owners[index]]=false;
        require(index>0,"can not delete it");
        require(who<=owners.length&&who>0,"number of the 'who' is too big");
        if(who==owners.length)
        {
            owners.pop();
        }
        else if(who<owners.length)
        {
            for(uint i=index;i<owners.length-1;i++)
            {
                owners[i]=owners[i+1];
            }
            owners.pop();
        }  
    }//删除owner 只有最高管理员 即owners[0]的地址才能删除

    function pushownere(address add) public 
    {
         require(msg.sender==owners[0],"do not have right");
         isOwner[add]=true;
         owners.push(add);
    }//增加owner 只有最高管理员 即owners[0]的地址才能增加

    function changerequiredSignatures(uint newrequire) public 
    {
        require(newrequire>0&&newrequire<owners.length,"wrong requirement");
         require(msg.sender==owners[0],"do not have right");
         requiredSignatures=newrequire;
    }//更改需要的签名数
    function chageContractowner(address newowner) public {
         require(msg.sender==owners[0],"do not have right");
         isOwner[owners[0]]=false;
         owners[0]=newowner;
        isOwner[owners[0]]=true;
    }//更改最高管理者 只有最高管理员 即owners[0]的地址才能增加
    function changeViewRight(uint newlevel) public returns(uint NumberOfowner)
    {
          require(msg.sender==owners[0],"can not do this");
          level=newlevel;
    }//更改数据显示权限 
    function changepowerfulman(uint who,address change) public {
        require(msg.sender==owners[0],"can not do this");
         require(who<=owners.length&&who>1,"wrong index");
        who--;
        require(isOwner[change],"the powerfulman has existed");
        isOwner[owners[who]]=false;
        isOwner[change]=true;
        owners[who]=change;
    }//更改owner 输入要更改的序号以及新地址

}