import Web3 from 'web3'
import { conf } from '../config'
import _ from 'lodash'
import { Transaction, Log } from 'web3-core'
import telegramService from '../nftFeed/feedDistributors/telegram/telegramService'
import unleash from "../tools/unleash";
import { nftDealEvent } from '../nftDealEvent'

export const ethWeb3 = new Web3(new Web3.providers.HttpProvider(conf.ethProviderUrl))
export const polyWeb3 = new Web3(new Web3.providers.HttpProvider(conf.polyProviderUrl))
export const polyWeb3Testnet = new Web3(new Web3.providers.HttpProvider(conf.polyTestnetProviderUrl))
export const ethWeb3Testnet = new Web3(new Web3.providers.HttpProvider(conf.ethTestnetProviderUrl))

export type BlockCallbackFunction = (tx: Transaction, timestamp: string | number) => any
export type LogCallbackFunction = (log: Log) => any

const subscribeEthereumTxs = () => {
    let prevBlockNumber;
    setInterval(async () => {
        try {
            if (!unleash.isEnabled("is_handle_new_eth_tx")) return;
            const currentBlockNumber = await ethWeb3.eth.getBlockNumber()
            if (!prevBlockNumber) {
                prevBlockNumber = currentBlockNumber
                return
            }
            if (currentBlockNumber <= prevBlockNumber) {
                return
            }
            const options = {
                fromBlock: prevBlockNumber,
                toBlock: currentBlockNumber,
                address: nftDealEvent.eventNames() as string[], //Only get events from specific addresses
                topics: [], //What topics to subscribe to
            }
            await ethWeb3.eth.getPastLogs(options, (err, logs) => {
                if (err) {
                    console.error(options)
                    console.error(err)
                    telegramService.sendAlert('getPastLogs error');
                    console.error('getPastLogs error')
                    return
                }
                logs.forEach((v) => {
                    nftDealEvent.emit(v.address, v)
                })
            })
            prevBlockNumber = currentBlockNumber + 1
        } catch { }
    }, 30 * 1000)
}
export const ethSubscription = subscribeEthereumTxs()