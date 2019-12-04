const AlternativeVote = artifacts.require("../contracts/AlternativeVote.sol");

module.exports = function(deployer) {
  deployer.deploy(AlternativeVote);
};
