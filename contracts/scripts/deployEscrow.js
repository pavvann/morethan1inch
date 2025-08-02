const { ethers } = require("hardhat");

const deployEscrowFactory = async () => {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying with account: ", deployer.address);

    const factory = await ethers.getContractFactory("EscrowFactory");
    console.log("deploying escrow factory...");

    // WMON Address: 0x760AfE86e5de5fa0Ee542fc7B7B713e1c5425701
    // WETH Address: 0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9
    const LOPAddress =  "0x7DE54E9C823f9e9F86EB5731f0F8FDA8fA359E56"

    const deployEF = await factory.deploy(
        LOPAddress,
        "0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9",
        ethers.ZeroAddress,
        deployer.address,
        60 * 30,
        60 * 30,
    )

    await deployEF.waitForDeployment();
    const EFAddress = await deployEF.getAddress();
    console.log(EFAddress);
}

deployEscrowFactory();

//   config.contracts.limitOrderProtocol,  // LOP address
// config.contracts.wrappedNative,        // Fee token (WETH/WBNB)
// config.contracts.accessToken,          // Access token (0x0 for public)
// deployer.address,                      // Owner
// config.rescueDelays.src,               // Source rescue delay
// config.rescueDelays.dst

// rescueDelays: {
//     src: 60 * 30, // 30 minutes
//     dst: 60 * 30, // 30 minutes
//   }