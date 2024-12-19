package main

import (
	"errors"
	"fmt"
)

// SimpleBank struct for owner and bank balance
type SimpleBank struct {
	Owner   string
	Balance map[string]uint
}

// CreateSimpleBank creates a new instance of SimpleBank
func CreateSimpleBank(owner string) *SimpleBank {
	return &SimpleBank{
		Owner:   owner,
		Balance: make(map[string]uint),
	}
}

// Transfer allows funds transfer from sender to receiver
func (bank *SimpleBank) Transfer(sender, receiver string, amount uint) error {
	if sender == receiver {
		return errors.New("You cannot transfer into your own account")
	}
	if bank.Balance[sender] < amount {
		return errors.New("Insufficient amount in your account to transfer")
	}
	bank.Balance[sender] -= amount
	bank.Balance[receiver] += amount
	fmt.Printf("Transfer: %s transferred %d Ether to %s\n", sender, amount, receiver)
	return nil
}

// Withdraw allows the owner to withdraw funds from their account
func (bank *SimpleBank) Withdraw(owner string, amount uint) error {
	if bank.Owner != owner {
		return errors.New("Only the owner can withdraw funds from their account")
	}
	if bank.Balance[owner] < amount {
		return errors.New("Insufficient funds to withdraw")
	}
	bank.Balance[owner] -= amount
	fmt.Printf("Withdraw: %s withdrew %d Ether\n", owner, amount)
	return nil
}

// Deposit allows any user to deposit funds to their account
func (bank *SimpleBank) Deposit(owner string, amount uint) error {
	if amount <= 0 {
		return errors.New("The amount to deposit should not be less than or equal to 0")
	}
	bank.Balance[owner] += amount
	fmt.Printf("Deposit: %s deposited %d Ether\n", owner, amount)
	return nil
}

// GetBalance returns the balance of the user's account
func (bank *SimpleBank) GetBalance(owner string) uint {
	return bank.Balance[owner]
}

// CheckOwner ensures only the owner can modify certain functionalities
func (bank *SimpleBank) CheckOwner(owner string) error {
	if bank.Owner != owner {
		return errors.New("Only the owner can modify")
	}
	return nil
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
