<script lang="ts">
	/**
	 * @type {boolean}
	 */
	export let showLoadingModal = false;
	export let transactionStatus = 1;	// 0: Done ; 1: Waiting ; 2: Failed
  
	/**
	 * @type {HTMLDialogElement}
	 */
	let dialog: HTMLDialogElement; // HTMLDialogElement
  
	$: if (dialog && showLoadingModal) dialog.showModal();
	$: if (dialog &&!showLoadingModal) dialog.close();
  </script>
  
  <!-- svelte-ignore a11y-click-events-have-key-events a11y-no-noninteractive-element-interactions -->
  <dialog class=" select-none rounded-md backdrop:bg-gray-800 backdrop:bg-opacity-50 bg-zinc-50 justify-items-center focus-visible:outline-none"
	bind:this={dialog}
	on:close={() => (showLoadingModal = false)}
  >
	<!-- svelte-ignore a11y-no-static-element-interactions -->
	<div class=" w-96 p-8 pt-12 flex-col text-center" on:click|stopPropagation>
	  <div class="text-5xl flex-col justify-center">
		{#if transactionStatus == 1}
		<i class="fa-solid fa-circle-notch fa-spin text-indigo-600"></i>
	  	<div class="text-2xl mt-6">Transaction Pending</div>
		{:else if transactionStatus == 0}
		<i class="fa-solid fa-circle-check text-emerald-600"></i>
		<div class="text-2xl mt-6">Transaction Complete</div>
		{:else if transactionStatus == 2}
		<i class="fa-solid fa-circle-xmark text-rose-600"></i>
		<div class="text-2xl mt-6">Transaction Failed</div>
		{/if}
	  </div>
	  <slot />
	  <!-- svelte-ignore a11y-autofocus -->
	</div>
  </dialog>