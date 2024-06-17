const IntegerStorage = artifacts.require("IntegerStorage");

module.exports = function (deployer) {
    deployer.deploy(IntegerStorage)
}
