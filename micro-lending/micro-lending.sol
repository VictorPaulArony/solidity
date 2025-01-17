// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//contract for lending and borrowing
contract MicroLending {
    //defining the loa struct
    struct Loan {
        address payable lender; //owner of the loan
        address borrower;
        uint loanAmount;
        uint interestRate;
        uint loanTerm; //duration for loan payment
        uint dueDate;
        uint amountRepaid;
        uint penaltyRate;
        bool active;
        bool repaid;
    }

    //mapping the  address
    mapping(address => uint) public lenderBalance;
    mapping(address => uint) public borrowerBalance;
    mapping(address => Loan[]) public borrowerLoans; // loan for each borrower
    mapping(address => Loan[]) public lenderLoans; //Loans for each lender

    //define the events for the contract
    event LoanRequested(
        address borrower,
        uint amount,
        uint interestRate,
        uint term
    );
    event Repayment(address borrower, uint amount, uint loanIndex);
    event LoanApproved(
        address lender,
        address borrower,
        uint amount,
        uint dueDte
    );
    event LoanCLosed(address borrower, uint loanIndex);
    event Penatly(address borrower, uint amount, uint loanIndex);

    //modifers definition for the contract access
    modifier OnlyLender(address lender) {
        require(
            msg.sender == lender,
            "Only the lender can make these modification. "
        );
        _;
    }

    modifier OnlyBorrower(address borrower) {
        require(
            msg.sender == borrower,
            "Only the borrower can perform this action. "
        );
        _;
    }

    //contract functions definations

    //function to enable regiser of lender and deposite to their accounts
    function registerLender() external payable {
        require(msg.value > 0, "User must deposit to become a lender. ");
        lenderBalance[msg.sender] += msg.value;
    }

    //function to register borrower and enable them to ask for loan
    function requestLoan(uint _amount) external {
        uint256 _interestRate = 2;
        uint256 _term = 2;
        uint256 _penaltyRate = 2;

        require(
            _amount > 0, 
            "Loan amount must be great  than zero"
        );

        //updating the state of the cotract of the loan
        Loan memory newLoan = Loan({
            loanAmount: _amount,
            interestRate: _interestRate,
            loanTerm: _term,
            dueDate: block.timestamp + (_term * 1 days),
            amountRepaid: 0,
            penaltyRate: _penaltyRate,
            borrower: msg.sender,
            lender: payable(address(0)),//initially, no lender assiged to this untill approvall
            active: false,
            repaid: false
        });

        //add newLoan to the loan array/list
        borrowerLoans[msg.sender].push(newLoan);

        //logging the function event
        emit LoanRequested(msg.sender, _amount, _interestRate, _term);
    }

    //function to check the loan legibility and approve the loan
    function approveLoan(
        address borrower,
        uint loanIndex
    ) external payable OnlyLender(msg.sender) {
        require(
            loanIndex < borrowerLoans[borrower].length,
            "Invalid loan index"
        );

        //get the loan to be approved from the loan map
        Loan storage loan = borrowerLoans[borrower][loanIndex];
        require(
            loan.active == false, 
            "Loan is already active."
        );
        require(
            msg.value == loan.loanAmount,
            "Lender must deposit the exact loan amount."
        );

        //updating the state of the contract
        loan.lender = payable(address(0));
        loan.active = true;
        lenderBalance[msg.sender] -= msg.value;
        borrowerBalance[borrower] += msg.value;

        //logging the fuction
        emit LoanApproved(msg.sender, borrower, msg.value, loan.dueDate);
    }

    //function to anable the loaned to make repayment of the loan
    function repayment(
        uint loanIndex
    ) external payable OnlyBorrower(msg.sender) {
        require(
            loanIndex < borrowerLoans[msg.sender].length,
            "Invalid loan index."
        );

        Loan storage loan = borrowerLoans[msg.sender][loanIndex];
        require(loan.active == true, "Loan is not active.");
        require(msg.value > 0, "Repayment amount must be greater than zero.");

        //update the repayment
        loan.amountRepaid += msg.value;
        borrowerBalance[msg.sender] -= msg.value;
        lenderBalance[loan.lender] += msg.value;

        //check if there is penalty application to the borrower
        if (block.timestamp > loan.dueDate) {
            //calculate the penalty for the borrower
            uint penalty = (msg.value * loan.penaltyRate) / 10000;
            //update the borrower and lender balance
            lenderBalance[loan.lender] += penalty;
            borrowerBalance[msg.sender] -= penalty;
            emit Penatly(msg.sender, penalty, loanIndex);
        }

        //check if the loan if already paid by the user
        if (
            loan.amountRepaid >=
            loan.loanAmount + (loan.loanAmount * loan.interestRate) / 100
        ) {
            loan.active = false;
            loan.repaid = true;
            emit LoanCLosed(msg.sender, loanIndex);
        }

        emit Repayment(msg.sender, msg.value, loanIndex);
    }

    //function to get the loan details
    //  function getLoanDetails(address borrower, uint256 loanIndex) external view returns (Loan memory) {
    //     require(
    //         loanIndex < borrowerLoans[borrower].length,
    //         "Invalid loan index."
    //         );
    //     return borrowerLoans[borrower][loanIndex];
    // }
    
    //function to get the borrower's loan balance
    function getLoanBlanace(uint _loanIndex) external view OnlyBorrower(msg.sender) returns (uint){
        require(_loanIndex < borrowerLoans[msg.sender].length, "Invalid loan Index");

        //get the loan of the borrower by the index

        Loan memory loan = borrowerLoans[msg.sender][_loanIndex];
        uint totalLoan = loan.loanAmount + (loan.loanAmount* loan.interestRate) / 100;
        uint amountOwed = totalLoan - loan.amountRepaid;

        //calculate the loan penalty if overdue by date
        if (block.timestamp > loan.dueDate && !loan.repaid){
            uint penalty = (amountOwed * loan.penaltyRate)/ 10000;
            amountOwed += penalty;
        }

        return amountOwed;
    }

    //function to get the lenders balances
    function getLenderBalance() external view returns (uint256) {
        return lenderBalance[msg.sender];
    }

    //function to get the borrower's balances
    function getBorrowerBalance() external view returns (uint256) {
        return borrowerBalance[msg.sender];
    }

    //function to get the loan detais info
    function getLoanInfo(
        uint loanIndex
    )
        external
        view
        returns (
            address lender,
            address borrower,
            uint loanAmount,
            uint interestRate,
            uint loanTerm,
            uint dueDate,
            uint amountRepaid,
            uint penaltyRate,
            bool active
        )
    {
        require(
            loanIndex < borrowerLoans[msg.sender].length,
            "Invalid loan index"
        );
        Loan storage loan = borrowerLoans[msg.sender][loanIndex];
        return (
            loan.lender,
            loan.borrower,
            loan.loanAmount,
            loan.interestRate,
            loan.loanTerm,
            loan.dueDate,
            loan.amountRepaid,
            loan.penaltyRate,
            loan.active
        );
    }

    //end
}
