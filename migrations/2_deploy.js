const Token = artifacts.require("Token");
const ICO = artifacts.require("ICO");

module.exports =async function (deployer) {
  const totalSupply=1000000;

    await deployer.deploy(
      Token,
      "MYDOGE",
      "MDOG",
      totalSupply
    );
    const token=await Token.deployed()

    await deployer.deploy(
        ICO,
        token.address,
        592200,  //1week
        web3.utils.toWei('2','milli'),   //// price of 1 token in DAI (wei) (= 0.002 DAI. 0.002 * 10M = 20,000 DAI ~= 20,000 USD)
        totalSupply,
        200,
        500
    )

    const ico=await ICO.deployed();
    await token.updateAdmin(ico.address);
     await ico.start();

};
