<script>
    export let id = "";
</script>

<section {id} class={"min-h-screen flex flex-col px-4 pt-20 bg-zinc-100"}>
    <div class="flex flex-col flex-1 max-w-[1400px] mx-auto w-full">
        <slot />
    </div>
</section>