const { ethers } = require("hardhat");


const deployResolver = async () => {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying resolver with the account:", deployer.address);

    const factory = await ethers.getContractFactory("Resolver");
    console.log("Deploying Resolver...");

    const EscrowFactory = "0xaDD462E871B6E7C4c7d2fC6688981928d99d781f"
    const LOP = "0x7DE54E9C823f9e9F86EB5731f0F8FDA8fA359E56"


    const _deployResolver = await factory.deploy(EscrowFactory, LOP, deployer.address);
    _deployResolver.waitForDeployment();

    const deployedResolverAddress = await _deployResolver.getAddress();
    console.log(deployedResolverAddress);

}

deployResolver()