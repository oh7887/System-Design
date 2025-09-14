// Code generated - DO NOT EDIT.
// This file is a generated binding and any manual changes will be lost.

package DateTimeContract

import (
	"math/big"
	"strings"

	"github.com/KasperLiu/gobcos/accounts/abi"
	"github.com/KasperLiu/gobcos/accounts/abi/bind"
	"github.com/KasperLiu/gobcos/common"
	"github.com/KasperLiu/gobcos/core/types"
	"github.com/KasperLiu/gobcos/event"
)

// Reference imports to suppress errors if they are not otherwise used.
var (
	_ = big.NewInt
	_ = strings.NewReader
	_ = common.NotFound
	_ = abi.U256
	_ = bind.Bind
	_ = common.Big1
	_ = types.BloomLookup
	_ = event.NewSubscription
)

// DateTimeContractABI is the input ABI used to generate the binding from.
const DateTimeContractABI = "[{\"inputs\":[],\"name\":\"getCurrentDateTime\",\"outputs\":[{\"internalType\":\"string\",\"name\":\"\",\"type\":\"string\"}],\"stateMutability\":\"view\",\"type\":\"function\"}]"

// DateTimeContractBin is the compiled bytecode used for deploying new contracts.
var DateTimeContractBin = "0x608060405234801561001057600080fd5b5061073e806100206000396000f3fe608060405234801561001057600080fd5b506004361061002b5760003560e01c8063db09bded14610030575b600080fd5b6100386100b3565b6040518080602001828103825283818151815260200191508051906020019080838360005b8381101561007857808201518184015260208101905061005d565b50505050905090810190601f1680156100a55780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b606060004290506000806000806000806100cc876103fe565b809650819750829850839950849a50859b5050505050505060606100ef87610500565b6100fb60048803610500565b61010760138801610500565b61011087610500565b61011987610500565b61012287610500565b6040516020018087805190602001908083835b602083106101585780518252602082019150602081019050602083039250610135565b6001836020036101000a038019825116818451168082178552505050505050905001807f2d0000000000000000000000000000000000000000000000000000000000000081525060010186805190602001908083835b602083106101d157805182526020820191506020810190506020830392506101ae565b6001836020036101000a038019825116818451168082178552505050505050905001807f2d0000000000000000000000000000000000000000000000000000000000000081525060010185805190602001908083835b6020831061024a5780518252602082019150602081019050602083039250610227565b6001836020036101000a038019825116818451168082178552505050505050905001807f200000000000000000000000000000000000000000000000000000000000000081525060010184805190602001908083835b602083106102c357805182526020820191506020810190506020830392506102a0565b6001836020036101000a038019825116818451168082178552505050505050905001807f3a0000000000000000000000000000000000000000000000000000000000000081525060010183805190602001908083835b6020831061033c5780518252602082019150602081019050602083039250610319565b6001836020036101000a038019825116818451168082178552505050505050905001807f3a0000000000000000000000000000000000000000000000000000000000000081525060010182805190602001908083835b602083106103b55780518252602082019150602081019050602083039250610392565b6001836020036101000a03801982511681845116808217855250505050505090500196505050505050506040516020818303038152906040529050809850505050505050505090565b60008060008060008060006170808801905060006107b26301e1853e838161042257fe5b04019050600060046107b283038161043657fe5b049050600061016e820262015180858161044c57fe5b040390506000603c858161045c57fe5b0690506000603c610e10878161046e57fe5b068161047657fe5b0490506000610e1062015180888161048a57fe5b068161049257fe5b049050600080600191505b600c82116104d65760006104b18984610644565b90508087116104c357869150506104d6565b808703965050818060010192505061049d565b8760018301600483018587899e509e509e509e509e509e5050505050505050505091939550919395565b60606000821415610548576040518060400160405280600181526020017f3000000000000000000000000000000000000000000000000000000000000000815250905061063f565b600082905060005b60008214610572578080600101915050600a828161056a57fe5b049150610550565b60608167ffffffffffffffff8111801561058b57600080fd5b506040519080825280601f01601f1916602001820160405280156105be5781602001600182028036833780820191505090505b50905060008290508593505b6000841461063757600a84816105dc57fe5b0660300160f81b828260019003925082815181106105f657fe5b60200101907effffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916908160001a905350600a848161062f57fe5b0493506105ca565b819450505050505b919050565b6000600282141561066f57610658836106c5565b1561066657601d90506106bf565b601c90506106bf565b6007821161069d5760006002838161068357fe5b061461069057601f610693565b601e5b60ff1690506106bf565b6000600283816106a957fe5b06146106b657601e6106b9565b601f5b60ff1690505b92915050565b600080600483816106d257fe5b0614801561070157506000606483816106e757fe5b061415806107005750600061019083816106fd57fe5b06145b5b905091905056fea2646970667358221220da380dd87ae3e4f898c45d29809d8346f67ff6bc5c92cce69f46eb48f536407364736f6c634300060a0033"

// DeployDateTimeContract deploys a new Ethereum contract, binding an instance of DateTimeContract to it.
func DeployDateTimeContract(auth *bind.TransactOpts, backend bind.ContractBackend) (common.Address, *types.RawTransaction, *DateTimeContract, error) {
	parsed, err := abi.JSON(strings.NewReader(DateTimeContractABI))
	if err != nil {
		return common.Address{}, nil, nil, err
	}

	address, tx, contract, err := bind.DeployContract(auth, parsed, common.FromHex(DateTimeContractBin), backend)
	if err != nil {
		return common.Address{}, nil, nil, err
	}
	return address, tx, &DateTimeContract{DateTimeContractCaller: DateTimeContractCaller{contract: contract}, DateTimeContractTransactor: DateTimeContractTransactor{contract: contract}, DateTimeContractFilterer: DateTimeContractFilterer{contract: contract}}, nil
}

// DateTimeContract is an auto generated Go binding around an Ethereum contract.
type DateTimeContract struct {
	DateTimeContractCaller     // Read-only binding to the contract
	DateTimeContractTransactor // Write-only binding to the contract
	DateTimeContractFilterer   // Log filterer for contract events
}

// DateTimeContractCaller is an auto generated read-only Go binding around an Ethereum contract.
type DateTimeContractCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// DateTimeContractTransactor is an auto generated write-only Go binding around an Ethereum contract.
type DateTimeContractTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// DateTimeContractFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type DateTimeContractFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// DateTimeContractSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type DateTimeContractSession struct {
	Contract     *DateTimeContract // Generic contract binding to set the session for
	CallOpts     bind.CallOpts     // Call options to use throughout this session
	TransactOpts bind.TransactOpts // Transaction auth options to use throughout this session
}

// DateTimeContractCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type DateTimeContractCallerSession struct {
	Contract *DateTimeContractCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts           // Call options to use throughout this session
}

// DateTimeContractTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type DateTimeContractTransactorSession struct {
	Contract     *DateTimeContractTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts           // Transaction auth options to use throughout this session
}

// DateTimeContractRaw is an auto generated low-level Go binding around an Ethereum contract.
type DateTimeContractRaw struct {
	Contract *DateTimeContract // Generic contract binding to access the raw methods on
}

// DateTimeContractCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type DateTimeContractCallerRaw struct {
	Contract *DateTimeContractCaller // Generic read-only contract binding to access the raw methods on
}

// DateTimeContractTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type DateTimeContractTransactorRaw struct {
	Contract *DateTimeContractTransactor // Generic write-only contract binding to access the raw methods on
}

// NewDateTimeContract creates a new instance of DateTimeContract, bound to a specific deployed contract.
func NewDateTimeContract(address common.Address, backend bind.ContractBackend) (*DateTimeContract, error) {
	contract, err := bindDateTimeContract(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &DateTimeContract{DateTimeContractCaller: DateTimeContractCaller{contract: contract}, DateTimeContractTransactor: DateTimeContractTransactor{contract: contract}, DateTimeContractFilterer: DateTimeContractFilterer{contract: contract}}, nil
}

// NewDateTimeContractCaller creates a new read-only instance of DateTimeContract, bound to a specific deployed contract.
func NewDateTimeContractCaller(address common.Address, caller bind.ContractCaller) (*DateTimeContractCaller, error) {
	contract, err := bindDateTimeContract(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &DateTimeContractCaller{contract: contract}, nil
}

// NewDateTimeContractTransactor creates a new write-only instance of DateTimeContract, bound to a specific deployed contract.
func NewDateTimeContractTransactor(address common.Address, transactor bind.ContractTransactor) (*DateTimeContractTransactor, error) {
	contract, err := bindDateTimeContract(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &DateTimeContractTransactor{contract: contract}, nil
}

// NewDateTimeContractFilterer creates a new log filterer instance of DateTimeContract, bound to a specific deployed contract.
func NewDateTimeContractFilterer(address common.Address, filterer bind.ContractFilterer) (*DateTimeContractFilterer, error) {
	contract, err := bindDateTimeContract(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &DateTimeContractFilterer{contract: contract}, nil
}

// bindDateTimeContract binds a generic wrapper to an already deployed contract.
func bindDateTimeContract(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := abi.JSON(strings.NewReader(DateTimeContractABI))
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_DateTimeContract *DateTimeContractRaw) Call(opts *bind.CallOpts, result interface{}, method string, params ...interface{}) error {
	return _DateTimeContract.Contract.DateTimeContractCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_DateTimeContract *DateTimeContractRaw) Transfer(opts *bind.TransactOpts) (*types.RawTransaction, error) {
	return _DateTimeContract.Contract.DateTimeContractTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_DateTimeContract *DateTimeContractRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.RawTransaction, error) {
	return _DateTimeContract.Contract.DateTimeContractTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_DateTimeContract *DateTimeContractCallerRaw) Call(opts *bind.CallOpts, result interface{}, method string, params ...interface{}) error {
	return _DateTimeContract.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_DateTimeContract *DateTimeContractTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.RawTransaction, error) {
	return _DateTimeContract.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_DateTimeContract *DateTimeContractTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.RawTransaction, error) {
	return _DateTimeContract.Contract.contract.Transact(opts, method, params...)
}

// GetCurrentDateTime is a paid mutator transaction binding the contract method 0xdb09bded.
//
// Solidity: function getCurrentDateTime() returns(string)
func (_DateTimeContract *DateTimeContractTransactor) GetCurrentDateTime(opts *bind.TransactOpts) (*types.RawTransaction, error) {
	return _DateTimeContract.contract.Transact(opts, "getCurrentDateTime")
}

// GetCurrentDateTime is a paid mutator transaction binding the contract method 0xdb09bded.
//
// Solidity: function getCurrentDateTime() returns(string)
func (_DateTimeContract *DateTimeContractSession) GetCurrentDateTime() (*types.RawTransaction, error) {
	return _DateTimeContract.Contract.GetCurrentDateTime(&_DateTimeContract.TransactOpts)
}

// GetCurrentDateTime is a paid mutator transaction binding the contract method 0xdb09bded.
//
// Solidity: function getCurrentDateTime() returns(string)
func (_DateTimeContract *DateTimeContractTransactorSession) GetCurrentDateTime() (*types.RawTransaction, error) {
	return _DateTimeContract.Contract.GetCurrentDateTime(&_DateTimeContract.TransactOpts)
}
