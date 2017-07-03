pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/OpenNotary.sol";

contract TestOpenNotary {
  uint blockTimestamp;
  uint blockNumber;

  event LogWitness(
    address sender,
    uint blockTimeStamp,
    uint blockNumber
  );

  function beforeAll() {
    OpenNotary open_notary = OpenNotary(DeployedAddresses.OpenNotary());

    open_notary.witnessDocument("abcd", 1234000);
    blockTimestamp = block.timestamp;
    blockNumber = block.number;
  }

  function testWitnessedDocumentStoring() {
    OpenNotary open_notary = OpenNotary(DeployedAddresses.OpenNotary());

    Assert.isTrue(open_notary.documentWitnessed("abcd"), "Document should have been witnessed already");
  }

  function testNonWitnessedDocumentStoring() {
    OpenNotary open_notary = OpenNotary(DeployedAddresses.OpenNotary());

    Assert.isFalse(open_notary.documentWitnessed("abce"), "Document should not have been witnessed already");
  }

  function testGetDocumentFileSize() {
    OpenNotary open_notary = OpenNotary(DeployedAddresses.OpenNotary());

    uint expected = 1234000;

    Assert.equal(open_notary.getDocumentFileSize("abcd"), expected, "Document should have a file size of 1234000");
  }

  function testGetWitnessCountOfWitnessedDocument() {
    OpenNotary open_notary = OpenNotary(DeployedAddresses.OpenNotary());

    uint expected = 1;

    Assert.equal(open_notary.getWitnessCount("abcd"), expected, "Document should have been witnessed once");
  }

  function testGetWitnessCountOfNonWitnessedDocument() {
    OpenNotary open_notary = OpenNotary(DeployedAddresses.OpenNotary());

    uint expected = 0;

    Assert.equal(open_notary.getWitnessCount("abce"), expected, "Document should not have been witnessed yet");
  }

  function testGetWitness() {
    OpenNotary open_notary = OpenNotary(DeployedAddresses.OpenNotary());

    var (s, t, n) = open_notary.getWitness("abcd", 0);

    LogWitness(this, blockTimestamp, blockNumber);
    LogWitness(s, t, n);

    Assert.equal(
      s, this, 'Witness address should match the original witness'
    );
    Assert.equal(
      t, blockTimestamp, 'Witnessed timestamp should match the original timestamp'
    );
    Assert.equal(
      n, blockNumber, 'Witnessed block number should match the original block number'
    );
  }

}
