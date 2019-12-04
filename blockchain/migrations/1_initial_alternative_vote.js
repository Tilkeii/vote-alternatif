const AlternativeVote = artifacts.require("AlternativeVote");

module.exports = function(deployer) {
  deployer.deploy(AlternativeVote);
};
