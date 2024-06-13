<script>
    export let id = "";
    export let bg = "bg-zinc-100";
</script>

<section {id} class={` ${bg} min-h-screen flex flex-col px-4 pt-20 select-none`}>
    <div class="flex flex-col flex-1 max-w-[1400px] mx-auto w-full">
        <slot />
    </div>
</section>