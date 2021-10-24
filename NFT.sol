

pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "tokenInt.sol";

contract SampleToket is tokenInt {
    struct token {
        string name;
        uint power;
        uint speed;
        uint health;
    }
    token[] tokensArr;
    uint128 public _createFee;
    mapping (uint => uint) tokenToOwner;
    mapping (uint => uint) tokenToPrice;

    modifier checkOwn (uint tokenIdent) {
        require(msg.pubkey() == tokenToOwner[tokenIdent], 101);
        tvm.accept();
        _;
    }
    function setCreateFee(uint128 _fee) public {
        require(msg.pubkey() == tvm.pubkey(), 101);
        tvm.accept();
        _createFee = _fee;
    }
    function createToken(string name, uint power, uint speed, uint health) public override returns (uint tokenId) {
        // Проверки на создание уникального имени
        for (uint256 index = 0; index < tokensArr.length; index++) {
            require(tokensArr[index].name != name, 103);
        }

        //проверка на вызов метода самим контрактом
        // или при перечислении награды за создание с отправкой сдачи
        if (msg.pubkey() == tvm.pubkey() || msg.value >= _createFee)  {
            if (msg.pubkey() != tvm.pubkey() && msg.value > _createFee) {
                msg.sender.transfer(msg.value - _createFee);
            }
            tvm.accept();
            tokensArr.push(token(name, power, speed, health));
            // Записываем владельцем токена адрес сообщения вызывающего метод
            tokenId = tokensArr.length - 1;
            tokenToOwner[tokenId] = msg.pubkey();        
        }
        
    }
    function changePrice(uint tokenId, uint price) public checkOwn(tokenId) override {
        tokenToPrice[tokenId] = price;
    }
    function changeOwner(uint tokenId, uint pubKeyOfNewOwner) public checkOwn(tokenId) override {
        tokenToOwner[tokenId] = pubKeyOfNewOwner;
    }
    function getTokenPrice(uint tokenId) public view returns (uint){
        return tokenToPrice[tokenId];
    }
    function getTokenOwner(uint tokenId) public view returns (uint){
        return tokenToOwner[tokenId];
    }
    function getTokenInfo(uint tokenId) public view returns (string name, uint power, uint speed, uint health) {
        name = tokensArr[tokenId].name;
        power = tokensArr[tokenId].power;
        speed = tokensArr[tokenId].speed;
        health = tokensArr[tokenId].health;
    }
     function changePower(uint tokenId, uint power) public {
        require(msg.pubkey() == tokenToOwner[tokenId], 101);
        tvm.accept();
        tokensArr[tokenId].power = power;
    }
}
