require('dotenv').config()
import { assert } from "chai"
import { EMediaTypes } from "../../src/nftFeed/feedDistributors/models"
import TextGeneratorService from "../../src/nftFeed/TextGeneratorService"
import TelegramService from "../../src/nftFeed/feedDistributors/telegram/telegramService"
import strTools from "../../src/tools/strTools"
import { ethWeb3 } from '../../src/tools/useWeb3'
import { EEventTypes } from "../../src/nftFeed/nftFeedService"

const fndMarketAbi = require('../../contracts/fnd_market_abi.json');
const fndProxyMarketContractAddress = '0xcDA72070E455bb31C7690a170224Ce43623d0B6f'

describe('Test handle processing', () => {
    const fndMarketContract = new ethWeb3.eth.Contract(fndMarketAbi, fndProxyMarketContractAddress)

    it('Handle Big number price', async () => {
        const auctionId = 109175;
        const nftData = await fndMarketContract.methods.getReserveAuction(auctionId).call();
        console.error(nftData.amount)
        console.error(ethWeb3.utils.fromWei(nftData.amount.toLocaleString('fullwide', { useGrouping: false })))
        console.error(ethWeb3.utils.fromWei(nftData.amount))
    })

})
