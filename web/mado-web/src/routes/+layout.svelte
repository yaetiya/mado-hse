<script lang="ts">
	import '../styles/app.scss';
	import { _user } from '$lib/store/user';

	import { onMount } from 'svelte';
	import UnlockNotification from '$lib/components/UnlockNotification.svelte';
	import { _runtimeData } from '$lib/store/runtimeData';
	import Footer from '$lib/components/Footer.svelte';
	import firebaseService from '$lib/services/firebaseService';
	import { _nftFeed } from '$lib/store/nftFeed';

	onMount(() => {
		_user.tryAuth();
		_runtimeData.init();
		firebaseService.init();
		_nftFeed.init();
	});
</script>

{#if $_runtimeData.featureConfig?.isOnAppStoreCheck === false && $_user?._id && !$_user?.isUnlocked}
	<UnlockNotification />
{/if}
<slot />
<Footer />
