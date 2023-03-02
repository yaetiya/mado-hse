<script lang="ts">
	import { goto } from '$app/navigation';

	const partners = [
		{
			name: 'Y2O',
			imgUrl: 'screens/partners/yllo-logo.svg',
			url: 'https://yllo.co'
		},
		{
			name: 'XLT',
			imgUrl: 'screens/partners/xlt-logo-dark.png',
			url: 'https://xlt.one'
		}
	];
</script>

<div class="wrapper">
	<h3>Partners</h3>
	<div class="partners">
		{#each partners as p}
			<div
				class="partner"
				on:click={() => {
					goto(p.url);
				}}
			>
				<img src={p.imgUrl} alt={p.name} class="logo" />
				<h5>{p.name}</h5>
			</div>
		{/each}
	</div>
</div>

<style lang="scss">
	.wrapper {
		padding-top: 40px;
		padding-bottom: 80px;
		h3 {
			font-size: 28px;
			text-align: center;
			width: 100%;
			color: #000;
            margin-bottom: 40px;
		}
		background-color: #fff;
		.partners {
			display: flex;
            flex-flow: row wrap;
            justify-content: center;
            width: 100%;
			.partner {
                display: flex;
                
                align-items: center;
				cursor: pointer;
                margin: 10px;
                border: 1px solid rgb(231, 231, 231);
                box-shadow: 0px 28px 82px rgba(0, 0, 0, 0.09);
                padding: 30px;
                border-radius: 30px;
				img {
					pointer-events: none;
					max-height: 50px;
					max-width: 50px;
				}
				h5 {
					width: 100%;
                    margin-left: 30px;
                    margin-right: 10px;
					text-align: center;
					font-size: 18px;
				}
			}
		}
	}
</style>
