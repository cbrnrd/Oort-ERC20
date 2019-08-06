pragma solidity ^0.4.23;

contract OortToken {
    string  public name = "Oort Token";
    string  public symbol = "OORT";
    string  public standard = "Oort Token v1.0";
    uint256 public totalSupply;

    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );

    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    mapping(address => mapping(string => string)) store;

    uint MAX_STR_LENGTH = 3000;

    constructor(uint256 _initialSupply) public {
        balanceOf[msg.sender] = _initialSupply;
        totalSupply = _initialSupply;
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "You cannot send more than you have!");

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        emit Transfer(msg.sender, _to, _value);

        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);

        return true;
    }

    // Reading from the Oort cloud is free
    function get(address _acct, string _key) public view returns (string data) {
        return store[_acct][_key];
    }

    // Each time you set a key, you pay 1 token regardless of length
    function set(address _acct, string _key, string _value) public {
        require(bytes(_value).length <= MAX_STR_LENGTH, "Requested delta exceeds maximium data length (3000)!");
        require(balanceOf[_acct] >= 1, "You don't have enough balance to store a Tau!");
        store[msg.sender][_key] = _value;
        balanceOf[_acct] -= 1;
    }
    // END OORT CLOUD FUNCTIONS \\

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= balanceOf[_from], "Requested send value is greater then amount owned by sender");
        require(_value <= allowance[_from][msg.sender], "Allowance clash!");

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;

        allowance[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);

        return true;
    }

}