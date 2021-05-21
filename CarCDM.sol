pragma solidity >=0.4.22 <0.7.0;

contract CustomerDealer {
    address addressDealerManufacturer;
    mapping (address => CustomerRecords) public customerRecords;
    uint256 public CustomerCount = 0;
    
      function setAddress(address _addressDealerManufacturer) external {
        addressDealerManufacturer = _addressDealerManufacturer;
    }
    
    struct CustomerRecords{
        uint Cid;
        address CustomerAddress;
        string name;
        uint advance;
        uint CPhoneNumber;
        uint BillAmount;
        string CEmailId;
        string Car;
        string Company;
        uint AadharNumber;
    }
    
    struct DealerRecords{
        address DealerAddress;
        string name;
        string Dlocation;
        uint DPhoneNumber;
        string DEmailId;
        uint GSTnumber;
    }
    
    DealerRecords Dealer;
    function addDealerRecords(
        address _DealerAddress,
        string memory _name,
        string memory _Dlocation,
        uint _DPhoneNumber,
        string memory _DEmailId,
        uint _GSTnumber
        )public{
        Dealer = DealerRecords(_DealerAddress,_name,_Dlocation,_DPhoneNumber,_DEmailId,_GSTnumber);
    }
 
     function addCustomerRecord (
        uint _Cid,
        string memory _Car,
        string memory _Company,
        uint _AadharNumber,
        address _CustomerAddress,
        string memory _name,
        string memory _CEmailId,
        uint _advance,
        uint _CPhoneNumber,
        uint _BillAmount
       )
        public
    {
        customerRecords[_CustomerAddress].Cid = _Cid;
        customerRecords[_CustomerAddress].CustomerAddress = _CustomerAddress;
        customerRecords[_CustomerAddress].name = _name;
        customerRecords[_CustomerAddress].advance = _advance;
        customerRecords[_CustomerAddress].CPhoneNumber = _CPhoneNumber;
        customerRecords[_CustomerAddress].CEmailId = _CEmailId;
        customerRecords[_CustomerAddress].Car = _Car;
        customerRecords[_CustomerAddress].Company = _Company;
        customerRecords[_CustomerAddress].AadharNumber = _AadharNumber;
        customerRecords[_CustomerAddress].BillAmount = _BillAmount;

        CustomerCount += 1;
    }
    // function to send the details of the car wanted by the customer to the manufacturer
     function sendCarDetails( address _CustomerAddress)
      public
      view
      returns (
        uint256 _Cid,
        string memory _Company,
        string memory _Car,
        string memory _DEmailId,
        uint _DPhoneNumber
        )
      {
         _Car = customerRecords[_CustomerAddress].Car;
         _Company = customerRecords[_CustomerAddress].Company;
         _DPhoneNumber = Dealer.DPhoneNumber;
         _Cid = customerRecords[_CustomerAddress].Cid;
         _DEmailId = Dealer.DEmailId;
         return(_Cid,_Company,_Car,_DEmailId,_DPhoneNumber);
       }
 
    function Getpayment(address _customerAddress) public payable returns(string memory message){
if(msg.value==customerRecords[_customerAddress].BillAmount-customerRecords[_customerAddress].advance || msg.value==customerRecords[_customerAddress].advance){
            return "payment done";
        }
        else{
            revert("Payment Failed, incorrect amount");
        }
    }
     function balanceOf() external view returns(uint){
        return address(this).balance;
    }
    function sendPayemnt(address payable recipient, uint256 amount) external {
        recipient.transfer(amount);
    }
}

contract DealerManufacturer{
    address addressCustomerDealer;
    
      function setAddress(address _addressCustomerDealer) external {
        addressCustomerDealer = _addressCustomerDealer;
    }
    struct ManufacturerRecords{
        uint Mid;
        address ManufacturerAddress;
        string name;
        uint MPhoneNumber;
        string MEmailId;
        uint GSTnumber;
    }
     ManufacturerRecords Manufacturer;
    function addDealerRecords(
        uint _Mid,
        address _ManufacturerAddress,
        string memory _name,
        uint _MPhoneNumber,
        string memory _MEmailId,
        uint _GSTnumber
        )public{
        Manufacturer = ManufacturerRecords(_Mid,_ManufacturerAddress,_name,_MPhoneNumber,_MEmailId,_GSTnumber);
    }
     function getCarDetails(address _customerAddress) external view returns (
        uint256 _Cid,
        string memory _Company,
        string memory _Car,
        string memory _DEmailId,
        uint _DPhoneNumber)
         {
             CustomerDealer customerdealer = CustomerDealer(addressCustomerDealer);
             return customerdealer.sendCarDetails(_customerAddress);
        }
}
