<script lang="ts">
	import GooglePlayButton from '$lib/components/GooglePlayButton.svelte';
	import NftCard from '$lib/components/NftCard.svelte';
	import { _nftFeed } from '$lib/store/nftFeed';
	import { spring } from 'svelte/motion';

	import { onDestroy, onMount } from 'svelte';
	import AppStoreButton from '$lib/components/AppStoreButton.svelte';
	import TgButton from '$lib/components/TgButton.svelte';
	import Partners from '$lib/components/Partners.svelte';
	let nftFeedPos = spring(
		{ x: 600 },
		{
			stiffness: 0.1,
			damping: 1
		}
	);
	const onScroll = (e: Event) => {
		nftFeedPos.set({ x: -window.scrollY + 600 });
	};
	onMount(() => {
		const onScrollThrottled = window._.throttle(onScroll, 8);

		document.addEventListener('scroll', onScrollThrottled);
	});
</script>

<div class="wrapper">
	<div class="content">
		<div class="cl-1">
			<img src="screens/logo.png" class="logo" alt="logo" />
			<h1 class="title">The feed of the latest NFT sales</h1>

			<div class="btns-wrapper">
				<GooglePlayButton />
				<AppStoreButton />
				<TgButton />
			</div>
		</div>
		<div class="cl-2">
			<img src="screens/header.png" class="mob" alt="hero" />
			<img src="screens/hero.png" class="pc" alt="hero" />
		</div>
	</div>
</div>

<div class="nft-feeed-wrapper pc">
	<div class="nft-feed-container" style="transform: translateX({$nftFeedPos.x}px)">
		{#if $_nftFeed}
			{@const nftConf = $_nftFeed.config}{#each $_nftFeed.nfts as nftData}
				<NftCard {nftData} {nftConf} />
			{/each}
		{/if}
	</div>
</div>

<div class="wrapper">
	<div class="content">
		<h2>
			Crypto courses. Mado can explain you the basic web3: what is the wallet, explorer, e.t.c
			<br /><br />NFT feed. Don't miss new NFT trends
			<br /><br />Easy access to top crypto services like DEXs and NFT Marketplaces in one app
		</h2>

		<img src="screens/nft-feed.png" alt="nft-feed" />
	</div>
</div>
<Partners />

<style lang="scss">
	@import '../styles/breakpoints.scss';
	.nft-feeed-wrapper {
		min-height: 600px;
		background-color: #141414;
		padding: 40px 40px;
		overflow: hidden;
		width: 100%;
		position: relative;
		.nft-feed-container {
			display: flex;
		}
	}

	.wrapper {
		color: #161616;
		width: 100vw;

		background: transparent;

		display: flex;
		align-items: center;
		justify-content: center;
		& .content {
			display: flex;
			align-items: center;
			justify-content: center;
			flex-direction: column;
			& img {
				width: auto;
				max-width: 100%;
			}
			& h2 {
				text-align: center;
				font-size: 22px;
				max-width: auto;
				color: #545454;
				font-weight: 500;
				margin-right: 0px;
				margin-top: 20px;
				margin-bottom: 50px;
			}
			& .cl-1 {
				display: flex;
				flex-direction: column;
				align-items: center;
				padding: 10px;
				margin-right: 0px;
				max-width: 100%;
				& .logo {
					width: 100px;
				}
				& .title {
					margin-top: 70px;
					font-weight: 500;
					font-size: 32px;

					line-height: 122%;
					& img {
						width: 80px;
					}
					margin-bottom: 50px;
				}
				& p {
					font-size: 16px;
					color: #545454;
				}
				& .btns-wrapper {
					margin-top: 50px;
					width: 200px;

					max-width: 100%;
				}
			}
			& .cl-2 {
				width: 100%;
				max-width: 260px;
				& img {
					width: 100%;
				}
			}
		}
	}
	.pc {
		display: none;
	}
	@include media-breakpoint-up(md) {
		.mob {
			display: none;
		}
		.pc {
			display: block;
		}
		.wrapper {
			height: 100vh;
			& .content {
				& img {
					width: 300px;
				}
				& h2 {
					font-size: 28px;
					text-align: left;
					max-width: 50%;
					color: #000000;
					font-weight: 5 00;
					margin-right: 50px;
				}
				flex-direction: row;
				& .cl-1 {
					align-items: flex-start;
					width: 430px;
					margin-right: 20px;
					& .title {
						margin-top: 30px;
						font-size: 40px;
						margin-bottom: 50px;
					}
					& .btns-wrapper {
						width: 150px;
					}
				}
				& .cl-2 {
					max-width: 460px;
				}
			}
		}
	}
</style>
