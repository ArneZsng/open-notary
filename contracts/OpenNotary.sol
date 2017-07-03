pragma solidity ^0.4.2;

// This is a simple contract for an open notary that anyone can interact with.
// It allows you to store documents (hashes) in the contract and lookup existing documents.

contract OpenNotary {
  struct Witness {
    address witnessAddress;
    uint blockTimestamp;
    uint blockNumber;
  }

  struct Document {
    string documentHash;
    bool isWitnessed;
    uint fileSize;
    Witness[] witnesses;
  }

  mapping (string => Document) documents;

  event WitnessDocument(address indexed witness, string documentHash);

  function witnessDocument(string documentHash, uint fileSize) {
    Document document = documents[documentHash];
    document.documentHash = documentHash;
    document.fileSize = fileSize;
    document.isWitnessed = true;
    document.witnesses.push(Witness(msg.sender, block.timestamp, block.number));

    WitnessDocument(msg.sender, documentHash);
  }

  function documentWitnessed(string documentHash) public returns(bool) {
    return documents[documentHash].isWitnessed;
  }

  function getDocumentFileSize(string documentHash) public returns(uint) {
    return documents[documentHash].fileSize;
  }

  function getWitnessCount(string documentHash) public returns(uint){
    return documents[documentHash].witnesses.length;
  }

  function getWitness(string documentHash, uint index) public returns(address, uint, uint) {
    Witness witness = documents[documentHash].witnesses[index];
    return (witness.witnessAddress, witness.blockTimestamp, witness.blockNumber);
  }

}
