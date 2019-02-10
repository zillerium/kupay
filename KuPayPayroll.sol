pragma solidity ^0.5.3;

contract KuPayPayroll {

    // add audit trail in a full system, with dates, and txn details
    struct WorkerRecord {
        uint workerLiveCredit;
        bool workerExists;
        uint RedeemedCredits;
    }

    // lat and long recs are simplified for the demo, we need an actual proof of location
    struct ShopRecord {
        uint shopLiveCredit;
        bool shopExists;
        uint lat;
        uint longloc;
    }


    // maps scan of iris (hashed) to the worker record
    mapping (bytes32 => WorkerRecord) public WorkerRecords;

    mapping (address => ShopRecord) public ShopRecords;
    // store owwner takes credits for later fiat processing
    // system DOES  NOT make crypto payments, it is a tokenized model
    // with the worker exchanging tokens for goods or fiat money at a shop
    // worker record is updated as having had the credit
    // if the shop commits fraud here there is an audit trail
    function redeemCredits (
          bytes32 _workerIrisIdentifierHash,
          address shopAddress
        ) public {
        require(WorkerRecords[_workerIrisIdentifierHash].workerExists, "Worker does not exists");
        require(ShopRecords[shopAddress].shopExists, "Shop does not exists");
        ShopRecords[shopAddress].shopLiveCredit += WorkerRecords[_workerIrisIdentifierHash].workerLiveCredit;
        WorkerRecords[_workerIrisIdentifierHash].RedeemedCredits += WorkerRecords[_workerIrisIdentifierHash].workerLiveCredit;
        WorkerRecords[_workerIrisIdentifierHash].workerLiveCredit = 0;



    }

    function addShop (
        address shopAddress,
        uint lat,
        uint longloc
    ) public  {
        require(!ShopRecords[shopAddress].shopExists, "Shop already exists");
        ShopRecords[shopAddress].shopLiveCredit = 0;
        ShopRecords[shopAddress].shopExists = true;
        ShopRecords[shopAddress].lat = lat;
        ShopRecords[shopAddress].longloc = longloc;
    }

    // gps data is  not stored
    // gps check is simplified to just a numeric check on lat and longloc
    // need promixty checker in real system
    function checkWorkerPresence (
        bytes32 _workerIrisIdentifierHash,
        address shopAddress,
        uint lat,
        uint longloc
        ) public view returns (bool) {
            require(WorkerRecords[_workerIrisIdentifierHash].workerExists, "Worker does not exists");
            require(ShopRecords[shopAddress].shopExists, "Shop does not exist");
            if (ShopRecords[shopAddress].lat == lat)
                if (ShopRecords[shopAddress].longloc == longloc) {
                    return true;
                } else {
                    return false;
                }
            else
                return false;

        }

    function checkLiveCredits (
         bytes32 _workerIrisIdentifierHash
        ) public view returns (uint) {
            require(WorkerRecords[_workerIrisIdentifierHash].workerExists, "Worker does not exist");
            return WorkerRecords[_workerIrisIdentifierHash].workerLiveCredit;
    }

    //  hash of iris scan, this is made up from phone id and actual iris scan
    // iris scan has 1 in 1 to 10 to power 78 of being false. Also it does not
    // change with age or facial expressions. Hence the hash is reliable
    function addLiveCredits(
        bytes32 _workerIrisIdentifierHash,
        uint liveCredit
    ) public  {
            require(WorkerRecords[_workerIrisIdentifierHash].workerExists, "Worker does not exists");
            WorkerRecords[_workerIrisIdentifierHash].workerLiveCredit = liveCredit;
    }

    function addWorkerRecord(
        bytes32 _workerIrisIdentifierHash
    ) public  {
        // added an UN centre in the camp - later directly by workers via a phone
        // sets live credits to zero
        require(!WorkerRecords[_workerIrisIdentifierHash].workerExists, "Worker already exists");
        WorkerRecords[_workerIrisIdentifierHash].workerLiveCredit = 0;
        WorkerRecords[_workerIrisIdentifierHash].RedeemedCredits = 0;
        WorkerRecords[_workerIrisIdentifierHash].workerExists = true;
    }




}
