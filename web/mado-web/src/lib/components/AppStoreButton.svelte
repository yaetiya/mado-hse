<script lang="ts">
	import { analytics } from '$lib/services/firebaseService';
	import { logEvent } from 'firebase/analytics';
</script>

<img
	src="screens/app-store-btn.png"
	alt="app-store"
	on:click={() => {
		logEvent(analytics, 'app_store_click');
		window.open('https://apps.apple.com/app/mado/id1637595130?l=en', '_blank');
	}}
/>

<style>
	img {
		width: 100%;
		cursor: pointer;
		margin-top: 10px;
	}
</style>
