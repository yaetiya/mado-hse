<script lang="ts">
	import { analytics } from '$lib/services/firebaseService';
	import { logEvent } from 'firebase/analytics';
</script>

<img
	src="screens/google-play.png"
	alt="google-play"
	on:click={() => {
		logEvent(analytics, 'google_play_click');
		window.open('https://play.google.com/store/apps/details?id=com.mado.madoapp', '_blank');
	}}
/>

<style>
	img {
		width: 100%;
		cursor: pointer;
	}
</style>
