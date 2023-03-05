const { ethers, upgrades } = require("hardhat");

async function main() {
  const BlockfilesAccess = await ethers.getContractFactory("BlockfilesAccess");
  const c = await upgrades.deployProxy(BlockfilesAccess);
  await c.deployed();
  console.log("BlockfilesAccess deployed to:", c.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
