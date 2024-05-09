<script>
	/**
	 * @type {boolean}
	 */
	export let showLoadingModal = false;
	export let transactionDone = false;
  
	/**
	 * @type {HTMLDialogElement}
	 */
	let dialog; // HTMLDialogElement
  
	$: if (dialog && showLoadingModal) dialog.showModal();
	$: if (dialog &&!showLoadingModal) dialog.close();
  </script>
  
  <!-- svelte-ignore a11y-click-events-have-key-events a11y-no-noninteractive-element-interactions -->
  <dialog class=" select-none rounded-md backdrop:bg-gray-800 backdrop:bg-opacity-50 bg-zinc-50 justify-items-center focus-visible:outline-none"
	bind:this={dialog}
	on:close={() => (showLoadingModal = false)}
  >
	<!-- svelte-ignore a11y-no-static-element-interactions -->
	<div class="p-8 pt-12 flex-col text-center" on:click|stopPropagation>
	  <div class="text-5xl flex-col justify-center">
		{#if !transactionDone}
		<i class="fa-solid fa-spinner fa-spin text-indigo-600"></i>
	  	<div class="text-2xl mt-6">Waiting for transaction to be mined</div>
		{:else}
		<i class="fa-regular fa-circle-check text-indigo-600"></i>
		<div class="text-2xl mt-6">Transaction Complete</div>
		{/if}
	  </div>
	  <slot />
	  <!-- svelte-ignore a11y-autofocus -->
	</div>
  </dialog>