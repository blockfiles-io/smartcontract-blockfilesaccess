var dotenv = require('dotenv')
var dotenvExpand = require('dotenv-expand')

var myEnv = dotenv.config()
dotenvExpand.expand(myEnv)
require("@nomiclabs/hardhat-etherscan");
require("@nomiclabs/hardhat-ethers");
require('@openzeppelin/hardhat-upgrades');
const { 
  SPH_PRIVATE_KEY, 
  SPH_API_URL,
  ETH_PRIVATE_KEY,
  ETH_GOERLI_API_URL,
  MAT_PRIVATE_KEY,
  MAT_MUMBAI_API_URL,
  MAT_API_URL,
  OPT_GOERLI_API_URL,
  OPT_PRIVATE_KEY,
  ARB_PRIVATE_KEY, 
  ARB_GOERLI_API_URL, 
  ARB_ETHERSCAN_API_KEY } = process.env;

module.exports = {
  solidity: "0.8.17",
  defaultNetwork: "arbGoerli",
  networks: {
    hardhat: {},
    arbGoerli: {
      url: ARB_GOERLI_API_URL,
      accounts: [`0x${ARB_PRIVATE_KEY}`],
    },
    sphinx: {
      url: SPH_API_URL,
      chainId: 8082,
      accounts:[`0x${SPH_PRIVATE_KEY}`]
    },
    goerli: {
      url: ETH_GOERLI_API_URL,
      accounts: [`0x${ETH_PRIVATE_KEY}`],
    },
    optGoerli: {
      url: OPT_GOERLI_API_URL,
      accounts: [`0x${OPT_PRIVATE_KEY}`],
    },
    mumbai: {
      url: MAT_MUMBAI_API_URL,
      accounts: [`0x${MAT_PRIVATE_KEY}`],
    },
    polygon: {
      url: MAT_API_URL,
      accounts: [`0x${MAT_PRIVATE_KEY}`],
    }
    
  },
  etherscan: {
    apiKey: {
      goerli: ARB_ETHERSCAN_API_KEY
    },
  }
};