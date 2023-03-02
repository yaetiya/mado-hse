<script>

import { goto } from "$app/navigation";

</script>
<div class="wrapper">
	<div class="content">
		<a href="mailto:appmado0@gmail.com" class="email">appmado0@gmail.com</a>
		<div class="linktree-btn" on:click={() => {
            goto("https://linktr.ee/madoapp")
        }}><img width="40" src="/screens/linktree.svg" alt="links" /></div>
	</div>
</div>

<style lang="scss">
	.wrapper {
		color: #161616;
		width: 100vw;
		height: 100vh;
		background: #141414;

		display: flex;
		align-items: center;
		justify-content: center;
		& .content {
			display: flex;
			align-items: center;
            justify-content: center;
            flex-direction: column;
			& a {
				text-decoration: none;
				text-transform: none;
				color: #FFF;
				font-weight: 600;
				font-size: 18px;
				&:hover {
					text-decoration: underline;
				}
			}
			& .linktree-btn {
                margin-top: 50px;
				border-radius: 50%;
				width: 60px;
				height: 60px;
				border: 3px solid #cbcbcb;
				display: flex;
				align-items: center;
				justify-content: center;
                &:hover {
                    cursor: pointer;
                }
			}
		}
	}
</style>
