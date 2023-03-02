<script lang="ts">
	import type { INftFeedConfig, INftFeedElement } from '$lib/store/nftFeed';
	export let nftData: INftFeedElement;
	export let nftConf: INftFeedConfig;
</script>

<div class="wrapper">
	<div class="content-wrapper">
		{#if nftData.mediaUrl.endsWith('mp4')}
			<video src={nftData.mediaUrl} autoplay muted playsinline />
		{:else}
			<img loading="lazy" src={nftData.mediaUrl} alt="nft-content" />
		{/if}
	</div>
	<div class="caption-conteiner">
		<p>{nftData.postText}</p>
		<div class="emoji-wrapper">
			{#each nftData.emojis as emoji}
				{@const emojiData = nftConf.emoji.find((x) => x.name === emoji.emoji)}
				<div
					class="emoji"
					style="background-color: {emojiData?.bgColor}; color: {emojiData?.textColor}"
				>
					{emojiData?.symbol}
					{emoji.count}
				</div>
			{/each}
		</div>
	</div>
</div>

<style lang="scss">
	.wrapper {
		background-color: #fff;
		border-radius: 14px;
		padding: 3px;
		.content-wrapper {
			background-color: #ececec;
			border-radius: 13px;
		}
		img {
			width: 25vw;
			height: 25vw;

			border-radius: 13px;
		}
		.caption-conteiner {
			margin: 10px 10px;
			margin-bottom: 60px;
		}
		.emoji-wrapper {
			display: flex;
			position: absolute;
			bottom: 10px;
		}
		.emoji {
			border-radius: 40px;
			margin-right: 8px;
			font-style: 17px;
			padding: 4px 12px;
			width: max-content;
			cursor: not-allowed;

			position: relative;
			&::after {
				content: 'Install Mado mobile app for adding reactions 😑';
				position: absolute;
				bottom: -2px;
				width: 180px;
				background-color: #000;
				color: #fff;
				display: none;
				left: 50%;
				transform: translate(-50%, 100%);
				text-align: center;
				border: 1px solid #fff;
				font-size: 12px;
				border-radius: 4px;
				padding: 3px 10px;
			}
			&:hover::after {
				display: initial;
			}
		}
		margin-right: 40px;
	}
</style>
