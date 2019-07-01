var OortToken = artifacts.require("./OortToken.sol");
var OortTokenSale = artifacts.require("./OortTokenSale.sol");


module.exports = function(deployer) {
  deployer.deploy(OortToken, 1000000000).then(function() { // Start with 1B tokens
    // Token price is 0.001 ETH
    var tokenPrice = 1000000000000000;
    return deployer.deploy(OortTokenSale, OortToken.address, tokenPrice)
  })
};
