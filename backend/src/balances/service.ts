import axios from "axios";
import Web3 from "web3"
import { ethWeb3, ethWeb3Testnet, polyWeb3, polyWeb3Testnet } from "../tools/useWeb3";
export let prices = {
    maticPrice: 0, ethPrice: 0
}
const updateExchangeRates = async () => {
    const res = await axios.get('https://api.coingecko.com/api/v3/simple/price?ids=matic-network%2Cethereum&vs_currencies=usd');
    prices.ethPrice = res.data.ethereum.usd
    prices.maticPrice = res.data['matic-network'].usd
}

export const balancesService = {
    initExchangeRates: async () => {
        updateExchangeRates();
        setInterval(updateExchangeRates, 1000 * 60 * 60);
    },
    getBalance: async (address: string, currentWeb3: Web3) => {
        const balanceWei = await currentWeb3.eth.getBalance(address);
        return currentWeb3.utils.fromWei(balanceWei);
    },
    getBalances: async (address) => {
        const balances = {
            maticTestnet: await balancesService.getBalance(address, polyWeb3),
            maticMainnet: await balancesService.getBalance(address, polyWeb3Testnet),
            ethTestnet: await balancesService.getBalance(address, ethWeb3Testnet),
            ethMainnet: await balancesService.getBalance(address, ethWeb3),
            totalUsdBalance: ''
        };
        balances.totalUsdBalance = (parseFloat(balances.maticMainnet) * prices.maticPrice + parseFloat(balances.ethMainnet) * prices.ethPrice).toFixed(2);
        return balances
    }
}