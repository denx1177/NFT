pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

interface tokenInt {
    function createToken(string name, uint power, uint speed, uint health) external returns (uint tokenId);
    function changePrice(uint tokenId, uint price) external;
    function changeOwner(uint tokenId, uint pubKeyOfNewOwner) external;
}