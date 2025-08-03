const {ethers}  = require("hardhat")


const deployerc20True = async () => {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);


    const factory = await ethers.getContractFactory("ERC20True");
    console.log("deploying erc20 true...");

    const deploy = await factory.deploy();
    await deploy.waitForDeployment();

    const deployMockAddress = await deploy.getAddress();
    console.log("Mock Deployed on Address: ", deployMockAddress);
}

deployerc20True();