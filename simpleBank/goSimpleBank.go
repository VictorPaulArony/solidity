package main

import (
	"errors"
	"fmt"
)

// simple bank struct for owner and bnk balance
type SimpleBank struct {
	Owner   string
	Balance map[string]uint
}

func main() {
	// Create a new SimpleBank instance
	owner := "0xOwnerAddress"
	bank := CreateSimpleBank(owner)

	// Simulate deposits, withdrawals, and transfers
	account1 := "0xAccount1"
	account2 := "0xAccount2"

	// Deposit Ether
	bank.Deposit(account1, 100)
	bank.Deposit(account2, 50)

	// Check balances
	fmt.Println("Balance of", account1, ":", bank.GetBalance(account1))
	fmt.Println("Balance of", account2, ":", bank.GetBalance(account2))

	// Transfer Ether
	bank.Transfer(account1, account2, 30)

	// Check balances after transfer
	fmt.Println("Balance of", account1, ":", bank.GetBalance(account1))
	fmt.Println("Balance of", account2, ":", bank.GetBalance(account2))

	// Withdraw Ether
	bank.Withdraw(account1, 50)

	// Check balances after withdrawal
	fmt.Println("Balance of", account1, ":", bank.GetBalance(account1))
}

// function to create the new instance of SimplBank
func CreateSimpleBank(owner string) *SimpleBank {
	return &SimpleBank{
		Owner:   owner,
		Balance: make(map[string]uint),
	}
}

// function (method) to allow the owner of the bank transfer funds to others
func (bank *SimpleBank) Transfer(sender, receiver string, amount uint) error {
	if sender == receiver {
		return errors.New("You can not transfer into own account:")
	}
	if bank.Balance[sender] < amount {
		return errors.New("Insufficient amount in your account to transfer:")
	}
	bank.Balance[sender] -= amount
	bank.Balance[receiver] += amount
	fmt.Printf("Transfer: %s transferred %d Ether to %s\n", sender, amount, receiver)
	return nil
}

// function to allow the user to withdraw funds fron the account
func (bank *SimpleBank) Withdraw(owner string, amount uint) error {
	if bank.Owner != owner {
		return errors.New("Only the owner can withdraw funds from their account")
	}

	if bank.Balance[owner] < amount {
		return errors.New("Insufficient funds to withdraw ")
	}
	bank.Balance[owner] -= amount
	fmt.Printf("Withdraw: %s withdrew %d Ether\n", owner, amount)
	return nil
}

// function that allow oner to deposit funds to their accounts
func (bank *SimpleBank) Deposit(owner string, amount uint) error {
	if bank.Owner != owner {
		return errors.New("Only the owner can deposit to their account")
	}

	if amount <= 0 {
		return errors.New("The aount to deposite should not be less than 0")
	}
	bank.Balance[owner] += amount
	fmt.Printf("Deposit: %s deposited %d Ether\n", owner, amount)
	return nil
}

// function to get the balance of the user
func (bank *SimpleBank) GetBalance(owner string) uint {
	return bank.Balance[owner]
}

// function to checkOwner to ensure only owner access the account
func (bank *SimpleBank) CheckOwner(owner string) error {
	if bank.Owner != owner {
		return errors.New("only the owner can modify")
	}
	return nil
}
