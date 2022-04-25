var MyContract = artifacts.require("./MyContract.sol");

module.exports = function(_deployer) {
  deployer.deploy(MyContract);
};
