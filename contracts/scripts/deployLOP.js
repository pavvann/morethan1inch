const { ethers } = require("hardhat");


const deploy = async () => {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);

    const lop = await ethers.getContractFactory("LimitOrderProtocol");
    console.log("Deploying LimitOrderProtocol...");

    // WMON Address: 0x760AfE86e5de5fa0Ee542fc7B7B713e1c5425701
    // WETH Address: 0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9

    const deployLOP = await lop.deploy("0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9");
    deployLOP.waitForDeployment();

    const lopDeployedAddress = await deployLOP.getAddress();
    console.log(lopDeployedAddress);

}

deploy()