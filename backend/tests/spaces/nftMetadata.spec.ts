require('dotenv').config()
import nftMetadataStoringService from "../../src/spaces/nftMetadataStoringService"


describe.skip('Get nft metadata', () => {

    it.skip('Foundation collection item', async (done) => {
        nftMetadataStoringService
            .fetchTokenMetadata('0x3B3ee1931Dc30C1957379FAc9aba94D1C48a5405', '106644').then(console.error).catch(console.error)
    })
    it.skip('Custom popular collection item', async (done) => {
        nftMetadataStoringService
            .fetchTokenMetadata('0x5985ED7bce4bEA12433f130D73354C07FF038914', '7').then(console.error).catch(console.error)
    })
    it.skip('Custom not popular collection item', async (done) => {
        nftMetadataStoringService
            .fetchTokenMetadata('0xE362a5ebff6186b8c0cDA15ea33E92B7510f89B2', '2').then(console.error).catch(console.error)
    })
    // it('Full data of token', async (done) => {
    //     nftMetadataStoringService
    //         .createTokenMetadata('0x5985ED7bce4bEA12433f130D73354C07FF038914', '7').then(console.error).catch(console.error)
    // })


})
