<script lang="ts">
	import { goto } from '$app/navigation';
	import { _user } from '$lib/store/user';

	import { fly, fade } from 'svelte/transition';
	import { analytics } from '$lib/services/firebaseService';
	import { logEvent } from 'firebase/analytics';
	import { onMount } from 'svelte';

	onMount(() => {
		logEvent(analytics, 'subs_notification_shown');
	});
</script>

<div class="wrapper" in:fly={{ y: -100, duration: 250 }}>
	<h4 class="content">
		Get Premium for free <div class="btn-wrapper">
			<span
				class="btn"
				on:click={() => {
					logEvent(analytics, 'subs_notification_clicked');
					_user.unlock();
				}}>Get Premium</span
			>
			<span
				class="btn btn-2"
				on:click={() => {
					goto('/subs');
				}}>About Premium</span
			>
		</div>
	</h4>
</div>

<style lang="scss">
	@import '../../styles/breakpoints.scss';

	.wrapper {
		color: #fff;
		margin-bottom: 40px;
		padding: 10px;
		display: flex;
		align-items: center;
		justify-content: center;
		background: linear-gradient(89.8deg, #809fb4 0.17%, #ff4318 50.17%), #d9d9d9;
		& .content {
			text-align: center;
			font-size: 16px;
			font-weight: 500;
			& .btn-wrapper {
				padding: 15px;
				& span {
					font-size: 12px;
					cursor: pointer;
					&.link {
						text-decoration: underline;
					}

					&.btn {
						color: #fff;
						font-weight: 500;
						background-color: #fff;
						color: #000;
						border-radius: 40px;
						padding: 10px 15px;
					}
					&.btn-2 {
						margin-left: 10px;
						border: 1px solid #fff;
						background-color: transparent;
						color: #fff;
						&:hover {
							background-color: #fff;
							color: #000;
						}
					}
				}
			}
		}
	}
	@include media-breakpoint-up(md) {
		.wrapper {
			margin-bottom: 0px;
			padding: 0px;
			position: absolute;
			width: 100vw;
			height: 80px;
			& .content {
				display: flex;
				& .btn-wrapper {
					padding: 0px;
					margin-left: 50px;
				}
			}
		}
	}
</style>
