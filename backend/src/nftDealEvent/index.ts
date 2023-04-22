import { EventEmitter } from 'node:events';
class NftDealEvent extends EventEmitter { }

export const nftDealEvent = new NftDealEvent();
