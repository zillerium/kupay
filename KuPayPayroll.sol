pragma solidity ^0.5.3;

contract KuPayPayroll {

   struct StorePaymentRecord {
       address workerAddress;
       uint16 year;
       uint8 month;
       uint8 day;
       uint workerHoursPaid;
    }

    struct WorkerReceivedPaymentRecord {
        uint16 year;
        uint8 month;
        uint8 day;
        uint workerHoursPaid;
     }

// for demo just one currency is used
    struct StoreRecord {
        bytes32 shopGPSPositionHash;
        bytes32 shopIdentifier;
        uint shopMoneyOwed; //
        uint8 owedCurrency;
    }

   // use case is that the rate does not change -
   // v2 needs a mapping for rates and then to build data to allow different Payment
   // for different rates
    struct WorkerRecord {
        bytes32 workerIrisIdentifierHash;
        bytes32 workerGPSPositionHash;
        uint workerHourlyRate;
        uint workerHoursUnpaid;
        uint workerHoursPaid;
        bool workerExists;
    }

    struct WorkerCurrentRecord {
        uint workerHoursUnpaid;
    }

    address[] public freeAddresses;

    mapping (address => WorkerRecord) public WorkerRecords;
    mapping (address => StoreRecord) public StoreRecords;

    // map store address to array of payments for the store and then for each worker address
    mapping (address => mapping (address => StorePaymentRecord[])) public StorePaymentRecords;

    // worker address maps to monies received
    mapping (address => WorkerReceivedPaymentRecord[]) public WorkerReceivedPaymentRecords;

    function addWorkerRecord(
        bytes32 _workerIrisIdentifierHash,
        bytes32 _workerGPSPositionHash,
        uint _workerHourlyRate
    ) public returns (address) {
        require(freeAddresses.length>0, "no account are free");
        address _workerAddress = freeAddresses[0];
        delete freeAddresses[0];
        require(!WorkerRecords[_workerAddress].workerExists, "Worker already exists");
        WorkerRecords[_workerAddress].workerIrisIdentifierHash = _workerIrisIdentifierHash;
        WorkerRecords[_workerAddress].workerGPSPositionHash = _workerGPSPositionHash;
        WorkerRecords[_workerAddress].workerHourlyRate = _workerHourlyRate;
        WorkerRecords[_workerAddress].workerHoursUnpaid = 0;
        WorkerRecords[_workerAddress].workerHoursPaid = 0;
        WorkerRecords[_workerAddress].workerExists = true;
        return _workerAddress;
    }

    function addFreeAddress(address _freeAddress ) public {
        // demo - real app to disallow dups!
        freeAddresses.push(_freeAddress);
    }



}
