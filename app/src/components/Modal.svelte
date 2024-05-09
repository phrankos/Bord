<script>
	/**
     * @type {boolean}
     */
	 export let showModal; // boolean

	/**
     * @type {HTMLDialogElement}
     */
	let dialog; // HTMLDialogElement
	
	$: if (dialog && showModal) dialog.showModal();
	$: if (dialog &&!showModal) dialog.close();
</script>

<!-- svelte-ignore a11y-click-events-have-key-events a11y-no-noninteractive-element-interactions -->
<dialog class=" rounded-md backdrop:bg-gray-800 backdrop:bg-opacity-50 bg-zinc-50 justify-items-center"
	bind:this={dialog}
	on:close={() => (showModal = false)}
	on:click|self={() => dialog.close()}>
	<!-- svelte-ignore a11y-no-static-element-interactions -->
	<div class="p-4" on:click|stopPropagation>
		<div class="text-3xl text-slate-500 float-right ">
			<i on:click={() => dialog.close()} class="rounded-full hover:cursor-pointer hover:text-rose-700 fa-sharp fa-solid fa-xmark transition duration-200"></i>
		</div>
		<slot name="header" />
		<slot />
		<!-- svelte-ignore a11y-autofocus -->
	</div>
</dialog>
