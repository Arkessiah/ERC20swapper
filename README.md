
Deploy the contract to a public Ethereum testnet (e.g. Sepolia):

    Address Deploy Contract: 0x33e9fc5c97bd3c53674b4a525ae31a8961114756

Feel free to implement the contract by integrating to whatever DEX you feel comfortable - the exchange implementation is not required.

    I have done a light integration with an IDex interface to avoid complexities in testing, but it could be integrated with UniswapV3, for example with a little work.


Safety and trust minimization. Are user's assets kept safe during the exchange transaction?:

    I use OpenZeppelin's nonReentrant pattern to avoid re-entries, and the checking of minimum expected amounts for operations to try to avoid users' tokens being taken out, I also use Open Zeppelin-derived control of the use of functions only by an Owner.

Is the exchange rate fair and correct?:

    I can't control it without implementing anti-slippage mechanisms, control of the minimum tokens that the user must receive by connecting to an oracle.

Does the contract have an owner?:

    Yes, it is the address that deploys the contract, I have not implemented it but it could include a function to change the Onwer.

Performance. How much gas will the swapEtherToToken execution and the deployment take?:

    The swapEtherToToken function of the ERC20Swapper contract has a potentially infinite gas requirement derived from the legacy DEX swapEtherToToken function.

    Some strategies to improve this would be: 
    - Revising the DEX contract: avoiding loops, minimising write operations to storage and optimising the use of arrays and mappings.
    - Controlled gas limiting of transactions.
    - Attempt to decompose this function into smaller, more limited functions with lower gas consumption.
    - Optimise the DEX contract if we have control.


    Gas Deployment: 0.0014671 SepoliaETH

Upgradeability. How can the contract be updated if e.g. the DEX it uses has a critical vulnerability and/or the liquidity gets drained?:

    I have implemented the possibility to change the address of the Dex if necessary ('setDex'), as well as the possibility to pause and reactivate the functionality of the contract in order to repel an attack or update the operation. 

    I have not included a proxy type contract update system so as not to add complexity to the development.

Usability and interoperability. Is the contract usable for EOAs? Are other contracts able to interoperate with it?:

    The contract is usable by EOAs, as the functions are designed to be called directly by external accounts.
    Other contracts can also interact with ERC20Swapper as long as they respect the IERC20Swapper interface. Interoperability is somewhat limited by the use of the nonReentrant pattern, which is a necessary security measure but may restrict certain types of contract compositions.


Readability and code quality. Are the code and design understandable and error-tolerant? Is the contract easily testable?:

    In my opinion the code is generally clear and follows good Solidity practices, with descriptive function and variable names and the use of events to issue important contract updates.

    In terms of quality I make use of OpenZeppelin inheritances for ReentrancyGuard, Pausable, and Ownable by leveraging audited and tested libraries. 

By Antonio Maroto
--------------------------------------------------Initial requirements-------------------------------------------------------------

ERC-20 swapping contract

The task is to create a simple Solidity contract for exchanging Ether to an arbitrary ERC-20.

Requirements

Implement the following interface as a Solidity Contract

interface ERC20Swapper {
    /// @dev swaps the `msg.value` Ether to at least `minAmount` of tokens in `address`, or reverts
    /// @param token The address of ERC-20 token to swap
    /// @param minAmount The minimum amount of tokens transferred to msg.sender
    /// @return The actual amount of transferred tokens
    function swapEtherToToken(address token, uint minAmount) public payable returns (uint);
}
Deploy the contract to a public Ethereum testnet (e.g. Sepolia)

Send the address of deployed contract and the source code to us

Non-requirements

Feel free to implement the contract by integrating to whatever DEX you feel comfortable - the exchange implementation is not required.
Evaluation

Following properties of the contract implementation will be evaluated in this exercise:

Safety and trust minimization. Are user's assets kept safe during the exchange transaction? Is the exchange rate fair and correct? Does the contract have an owner?
Performance. How much gas will the swapEtherToToken execution and the deployment take?
Upgradeability. How can the contract be updated if e.g. the DEX it uses has a critical vulnerability and/or the liquidity gets drained?
Usability and interoperability. Is the contract usable for EOAs? Are other contracts able to interoperate with it?
Readability and code quality. Are the code and design understandable and error-tolerant? Is the contract easily testable?
