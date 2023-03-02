<script lang="ts">
	import { analytics } from '$lib/services/firebaseService';
	import { logEvent } from 'firebase/analytics';
</script>

<div class="btn-wrapper">
	<div class="arrow">
		<svg
			width="349"
			height="466"
			viewBox="0 0 349 466"
			fill="none"
			xmlns="http://www.w3.org/2000/svg"
		>
			<path
				d="M10 456C10 456 261 403 339 10"
				stroke="red"
				stroke-width="18"
				stroke-linecap="round"
			/>
		</svg>
	</div>
	<div class="arrow-text">You need not to download any app for using Mado</div>
	<img
		src="screens/tg-btn.png"
		alt="telegram-join"
		on:click={() => {
			logEvent(analytics, 'telegram_join_click');
			window.open('https://t.me/madoapp', '_blank');
		}}
	/>
</div>

<style lang="scss">
	@import '../../styles/breakpoints.scss';
	@include media-breakpoint-up(md) {
		.arrow, .arrow-text {
			display: block !important;
		}
	}
	.btn-wrapper {
		margin-top: 10px;
		position: relative;
		.arrow {
			display: none;
			width: 160px;
			height: 100px;
			position: absolute;
			top: -40px;
			right: -160px;

			svg {
				// transform: scale(0.2);
				width: 60px;
				height: 60px;
			}
		}
		.arrow-text {
			display: none;
			width: 160px;
			height: 100px;
			position: absolute;
			top: -90px;
			right: -200px;
			font-size: 12px;
			font-weight: 700;
		}
	}
	img {
		width: 100%;
		cursor: pointer;
	}
</style>
