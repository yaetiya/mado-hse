import { BigNumber, ethers } from "ethers";
import { ethSubscription, ethWeb3 } from "../../tools/useWeb3";
import nftFeedService, { EEventTypes } from "../nftFeedService";

const fndMarketAbi = require('../../../contracts/fnd_market_abi.json');
const fndProxyMarketContractAddress = '0xcDA72070E455bb31C7690a170224Ce43623d0B6f'
const handleNftTxsService = {
    main: () => {
        const fndMarketContract = new ethWeb3.eth.Contract(fndMarketAbi, fndProxyMarketContractAddress)
        const fndMarketContractIface = new ethers.utils.Interface(fndMarketAbi);

        ethSubscription.addLogCallback(fndProxyMarketContractAddress, async (log) => {
            const decodedLog = fndMarketContractIface.parseLog(log);
            console.error(decodedLog.name)
            console.error(decodedLog.args)
            if (decodedLog.name === "OfferMade") {
                nftFeedService.handleNftEvent({
                    type: EEventTypes.BuyOffer,
                    contractAddress: decodedLog.args.nftContract,
                    tokenId: ethWeb3.utils.hexToNumberString(decodedLog.args.tokenId._hex),
                    amount: ethWeb3.utils.fromWei(ethWeb3.utils.hexToNumberString(decodedLog.args.amount._hex)),
                    buyer: decodedLog.args.buyer
                })
            }
            // if (decodedLog.name === "ReserveAuctionBidPlaced") {
            //     const nftData = await fndMarketContract.methods.getReserveAuction(decodedLog.args.auctionId).call();
            //     nftFeedService.handleNftEvent({
            //         type: EEventTypes.BidPlaced,
            //         contractAddress: nftData.nftContract,
            //         tokenId: nftData.tokenId,
            //         amount: ethWeb3.utils.fromWei(nftData.amount),
            //         buyer: nftData.bidder
            //     })
            // }
            if (decodedLog.name === "ReserveAuctionFinalized") {
                console.error(decodedLog.args.auctionId)
                const nftData = await fndMarketContract.methods.getReserveAuction(decodedLog.args.auctionId).call();
                nftFeedService.handleNftEvent({
                    type: EEventTypes.AuctionFinalized,
                    contractAddress: nftData.nftContract,
                    tokenId: nftData.tokenId,
                    amount: ethWeb3.utils.fromWei(nftData.amount
                        .toLocaleString('fullwide', { useGrouping: false })
                    ),
                    buyer: decodedLog.args.bidder
                })
            }
        })
    }
}
export default handleNftTxsService;