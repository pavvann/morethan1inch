const {ethers}  = require("hardhat")


const deployMock = async () => {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);


    const mock = await ethers.getContractFactory("MockUSDC");
    console.log("deploying mock usdc...");

    const deployMock = await mock.deploy(deployer.address);
    await deployMock.waitForDeployment();

    const deployMockAddress = await deployMock.getAddress();
    console.log("Mock Deployed on Address: ", deployMockAddress);
}

deployMock();