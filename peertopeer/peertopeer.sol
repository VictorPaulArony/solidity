//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

//contract for a peer to peer lending system
contract PeertoPeer{

    //struct for the loan
    struct Loan{
        address borrower;
        address lender;
        uint amount;
        uint interestRate;
        uint loanDuration;
        uint startTime;
        bool isFunded;
        bool isRepaid;
    }

    //mapping of the loan to a loan id for tracking the loan
    mapping (uint => Loan) public loans;
    address public owner;
    uint public loanIdCounter;

    //events for the loggings
    event LoanFunding(uint loanId, address lender );
    event LoanRequested(uint loanId, address borrower, uint amount,uint interestRate, uint loanDuration );
    event LoanRepaid(uint loanId, address borrower);

    constructor(){
        owner = msg.sender;
    }

    //function to create the loan requested
    function createLoan(uint amount, uint interestRate, uint loanDuration) external {
        //conditons for the function 
        require(
            amount > 0,
            "The amount should not be less than 0:"
        );
         require(
            interestRate > 0,
            "The interest rate should not be less than 0:"
        );
         require(
            loanDuration > 0,
            "The loan duration should not be less than 0:"
        );

        // changing/ updating the function status
        loanIdCounter++;
        loans[loanIdCounter] = Loan({
            borrower: msg.sender,
            lender: address(0),
            amount: amount,
            interestRate: interestRate,
            loanDuration:loanDuration,
            startTime: 0,
            isFunded: false,
            isRepaid:false
        });

        //the loggint of the event
        emit LoanRequested(loanIdCounter, msg.sender, amount, interestRate, loanDuration);

    }

    //function for the loan funding
    function fundLoan(uint loanId) external payable {
        Loan storage loan = loans[loanId];
        require(
            loan.amount > 0,
            "The amount entered is less than 0"
        );

        require(
            !loan.isFunded,
            "The loan is already funded to the borrower"
        );
        require(
            msg.value == loan.amount,
            "The amount entered is incorrect"
        );
        
        //check effects- update the loan status
        loan.lender = msg.sender;
        loan.isFunded = true;
        loan.startTime = block.timestamp;

        emit LoanFunding(loanId, msg.sender);

    }

    //function to calculate the total loan to be paid
    function calculateRepayment(uint loanId) public view returns(uint){
        Loan storage loan = loans[loanId];

        //checking for the errors and reverting 
        require(
            //check if the state of the loan is still true for calculation
            loan.isFunded,
            "Loan was not founded to the borrower"
        ); 

        //updating the state of the function 
        uint principal = loan.amount;
        //the interest is calculated annual 
        uint interest = (principal * loan.interestRate * loan.loanDuration)/(100* 365);
        uint totalLoanRepaid = principal + interest;

        //return the total amount to be repaid 
        return totalLoanRepaid;

    }

    //function to let the borrower to reoay the loan
    function loanRepaid(uint loanId) external  payable {
        Loan storage loan = loans[loanId];

        //states the conditions 
        require(
            msg.sender == loan.borrower,
            "Only the borrower can repaly the loan"
        );
        require(
            loan.isFunded,
            "The laon was not funded to the borrower"
        );
        require(
            !loan.isRepaid,
            "The loan amount has alreaady bean paid"
        );

        //updating of the contract state
        uint totalAmountRepaid = calculateRepayment(loanId);

        payable(loan.lender).transfer(totalAmountRepaid);

        loan.isRepaid = true;
        
        //logging the event of loan repayment
        emit LoanRepaid(loanId, msg.sender);
    }

    //function to view the loan details
    function viewLoanDetails(uint loanId) external  view returns ( address borrower, address lender, uint amount,uint interestRate, uint loanDuration, uint startTime,bool isFunded, bool isRepaid){
        Loan storage loan = loans[loanId];
        return (
        loan.borrower,
        loan.lender,
        loan.amount,
        loan.interestRate,
        loan.loanDuration,
        loan.startTime,
        loan.isFunded,
        loan.isRepaid        
        );
    }

    

}