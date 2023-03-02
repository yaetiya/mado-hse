import { Network, Alchemy } from "alchemy-sdk";
import { configuration } from "../config/configuration";
const settings = {
    apiKey: configuration.alchemyKey,
    network: Network.ETH_MAINNET,
};

export const alchemy = new Alchemy(settings);
