# **Time-Locked Savings Contract**
 is a smart contract that allows users to lock their funds for a specific duration, restricting withdrawals until the lock period has passed. This type of contract can encourage savings by giving users an incentive to store their funds away for a certain period, and it can also be used for investment purposes where withdrawals are only permitted after the agreed-upon duration.

Here’s a **market-ready Solidity contract** for a **Time-Locked Savings Account** that allows users to lock their funds for a fixed period. The contract ensures that users cannot withdraw their funds before the lock period expires.

### Key Features:
1. **Deposit Funds**: Users can deposit Ether into the contract.
2. **Lock Period**: Users can specify a lock period (in seconds) for their funds.
3. **Withdrawal Restriction**: Users cannot withdraw funds until the lock period has passed.
4. **Owner Control**: The contract owner can withdraw any unclaimed funds after a specified period, if needed.
5. **Transparency**: The user can view their deposit and lock status.

### Key Components of the Contract:

1. **Struct `Deposit`**:
   - The `Deposit` struct stores the amount the user has deposited and the timestamp (`lockUntil`) until which the funds are locked.
   
2. **`deposit(uint256 lockDurationInSeconds)`**:
   - This function allows users to deposit funds into the contract with a specified lock duration in seconds. The user's deposit will be locked until the specified time.
   - Users cannot make another deposit while an existing deposit is still active.

3. **`withdraw()`**:
   - Users can withdraw their funds once the lock period has passed.
   - The contract ensures that users cannot withdraw their funds before the lock duration expires by using the `canWithdraw` modifier.

4. **`ownerWithdraw(uint256 amount)`**:
   - The contract owner can withdraw any unclaimed funds from the contract. This is important in cases where users do not withdraw their funds before a specific deadline.
   - The owner can withdraw funds only if the contract has enough balance.

5. **`getDepositDetails()`**:
   - Users can check their current deposit details, including the deposited amount and the timestamp until which their funds are locked.

6. **`getContractBalance()`**:
   - The owner can view the contract's balance, which provides transparency on the total funds locked in the contract.

### Functions Breakdown:

1. **`deposit()`**: Users can deposit Ether and specify the lock duration. The deposit is associated with their address, and the funds are locked until the specified `lockUntil` timestamp.
   
2. **`withdraw()`**: After the lock period expires, users can withdraw their funds. The contract ensures that the funds cannot be withdrawn before the lock duration.

3. **`ownerWithdraw()`**: The contract owner can withdraw any funds in the contract after some time, providing a way to manage unclaimed or unused funds.

4. **`getDepositDetails()`**: Users can check the amount and lock time of their deposit, providing transparency to users.

### Use Case Example:

#### 1. A user deposits funds:

- A user decides to deposit 1 Ether with a lock duration of 30 days.
```solidity
contract.deposit(30 days);  // The user deposits funds and specifies a lock period of 30 days
```

#### 2. The user tries to withdraw before the lock period:
- The user tries to withdraw before the lock duration has passed.
```solidity
contract.withdraw();  // This will fail since the lock duration has not passed yet
```

#### 3. The user withdraws after the lock period:
- After 30 days, the user can withdraw their funds:
```solidity
contract.withdraw();  // This will succeed, and the user can withdraw the funds
```

#### 4. The contract owner withdraws unclaimed funds (if applicable):
- After a long period of inactivity, the owner can withdraw unclaimed funds from the contract.
```solidity
contract.ownerWithdraw(10 ether);  // The owner withdraws a specific amount of unclaimed funds
```

### Conclusion:

This **Time-Locked Savings Contract** provides an efficient way to encourage saving by locking users' funds for a set period. The contract prevents early withdrawals and ensures that funds remain secure until the specified lock time has passed. It is useful for creating a secure savings or investment platform where users cannot access their funds until a certain date or duration. This contract also includes owner controls for managing unclaimed funds, providing flexibility for real-world applications.