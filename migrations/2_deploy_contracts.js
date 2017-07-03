var OpenNotary = artifacts.require("./OpenNotary.sol");

module.exports = function(deployer) {
  deployer.deploy(OpenNotary);
};
