const MyTokenFactoryContract = artifacts.require("MyTokenFactory");

module.exports = function (deployer) {
    deployer.deploy (MyTokenFactoryContract);
}