<script>
    /**
     * @type {boolean}
     */
    export let showModal = false; // boolean
    export let moreClasses = ""; // boolean
    export let taskDetails;
    export let isEditingTask = false;

    /**
     * @type {HTMLDialogElement}
     */
    let dialog; // HTMLDialogElement

    $: if (dialog && showModal) dialog.showModal();
    $: if (dialog && !showModal) dialog.close();


    let editTaskTimeLimitDays = 0;
    let editTaskTimeLimitHours = 0;
    let editTaskTimeLimitMinutes = 0;
    let editTaskTimeLimitSeconds = 0;
    function toggleEditTask() {
        isEditingTask = !isEditingTask;
        var seconds = Number(taskDetails.timeLimitVal);
        editTaskTimeLimitDays = Math.floor(seconds / (3600 * 24));
        seconds -= editTaskTimeLimitDays * 3600 * 24;
        editTaskTimeLimitHours = Math.floor(seconds / 3600);
        seconds -= editTaskTimeLimitHours * 3600;
        editTaskTimeLimitMinutes = Math.floor(seconds / 60);
        seconds -= editTaskTimeLimitMinutes * 60;
        editTaskTimeLimitSeconds = seconds;
    }

</script>

<!-- svelte-ignore a11y-click-events-have-key-events a11y-no-noninteractive-element-interactions -->
<dialog
    class={`rounded-md backdrop:bg-gray-800 backdrop:bg-opacity-50 bg-zinc-50 justify-items-center focus-visible:outline-none ${moreClasses}`}
    bind:this={dialog}
    on:close={() => (showModal = false)}
    on:click|self={() => dialog.close()}
>
    <!-- svelte-ignore a11y-no-static-element-interactions -->
    <div class="p-4" on:click|stopPropagation>
        <div class="text-3xl text-slate-500 float-right">
            <i
                on:click={() => dialog.close()}
                class="rounded-full hover:cursor-pointer hover:text-rose-700 fa-sharp fa-solid fa-xmark transition duration-200"
            ></i>
        </div>
        <div class="p-6">
            <h2 class="text-3xl text-center font-bold mb-4">
                {#if isEditingTask}
                    <input
                        class="w-full border rounded-md border-slate-400 focus-visible:outline-indigo-500 px-1"
                        type="text"
                        value={taskDetails.title}
                    />
                {:else}
                    <span>{taskDetails.title}</span>
                {/if}
            </h2>
            <p class="mb-2 font-medium text-lg">
                Task Id: <span class="font-normal text-base"
                    >{taskDetails.taskId}</span
                >
            </p>
            <p class="mb-2 font-medium text-lg">
                Asker: <span class="font-normal text-base"
                    >{taskDetails.asker}</span
                >
            </p>
            <p class="mb-2 font-medium text-lg">
                Doer: <span class="font-normal text-base"
                    >{taskDetails.doer}</span
                >
            </p>
            <p class="mb-2 font-medium text-lg">
                Content:
                {#if isEditingTask}
                    <input
                        class="w-full font-normal text-base border rounded-md border-slate-400 focus-visible:outline-indigo-500 px-1"
                        type="text"
                        value={taskDetails.content}
                    />
                {:else}
                    <span class="font-normal text-base"
                        >{taskDetails.content}</span
                    >
                {/if}
            </p>
            <p class="mb-2 font-medium text-lg">
                Prize:
                {#if isEditingTask}
                    <input
                        class="w-full font-normal text-base border rounded-md border-slate-400 focus-visible:outline-indigo-500 px-1"
                        min="1"
                        type="number"
                        value={taskDetails.prize}
                    />
                {:else}
                    <span class="font-normal text-base"
                        >{taskDetails.prize}</span
                    >
                {/if}
            </p>
            <p class="mb-2 font-medium text-lg">
                Status: <span class="font-normal text-base"
                    >{taskDetails.status}</span
                >
            </p>
            <p class="mb-2 font-medium text-lg">
                Date Created: <span class="font-normal text-base"
                    >{new Date(taskDetails.dateTimeCreated * 1000)
                        .toLocaleString()
                        .split(",")[0]}</span
                >
            </p>
            <p class="mb-2 font-medium text-lg">
                Time Limit:
                {#if isEditingTask}
                    <div class="w-full grid grid-cols-4 gap-2">
                        <span class="text-sm font-medium text-gray-700"
                            >Days</span
                        >
                        <span class="text-sm font-medium text-gray-700"
                            >Hours</span
                        >
                        <span class="text-sm font-medium text-gray-700"
                            >Minutes</span
                        >
                        <span class="text-sm font-medium text-gray-700"
                            >Seconds</span
                        >
                        <input
                            bind:value={editTaskTimeLimitDays}
                            type="number"
                            min="0"
                            class="w-full font-normal text-base border rounded-md border-slate-400 focus-visible:outline-indigo-500 px-1"
                        />
                        <input
                            bind:value={editTaskTimeLimitHours}
                            type="number"
                            min="0"
                            class="w-full font-normal text-base border rounded-md border-slate-400 focus-visible:outline-indigo-500 px-1"
                        />
                        <input
                            bind:value={editTaskTimeLimitMinutes}
                            type="number"
                            min="0"
                            class="w-full font-normal text-base border rounded-md border-slate-400 focus-visible:outline-indigo-500 px-1"
                        />
                        <input
                            bind:value={editTaskTimeLimitSeconds}
                            type="number"
                            min="1"
                            class="w-full font-normal text-base border rounded-md border-slate-400 focus-visible:outline-indigo-500 px-1"
                        />
                    </div>
                {:else}
                    <span class="font-normal text-base"
                        >{taskDetails.timeLimit}</span
                    >
                {/if}
            </p>
            <p class="mb-2 font-medium text-lg">
                Video Link: <span class="font-normal text-base"
                    >{taskDetails.videoLink}</span
                >
            </p>
            {#if taskDetails.statusVal == 0}
                <div class="mt-4">
                    {#if !isEditingTask}
                        <button
                            on:click={toggleEditTask}
                            class="w-full rounded-md btn p-2 text-md font-bold border border-teal-500 text-teal-500 bg-white duration-150 mb-2 hover:bg-teal-500 hover:text-white"
                            >Edit</button
                        >
                    {:else}
                        <button
                            on:click={() => console.log()}
                            class=" w-[49%] rounded-md btn p-2 text-md font-bold border border-indigo-700 text-indigo-500 bg-white duration-150 mb-2 hover:bg-indigo-700 hover:text-white"
                            >Submit</button
                        >
                        <button
                            on:click={toggleEditTask}
                            class="float-right w-[49%] rounded-md btn p-2 text-md font-bold border border-amber-700 text-amber-700 bg-white duration-150 mb-2 hover:bg-amber-700 hover:text-white"
                            >Cancel</button
                        >
                    {/if}
                    <button
                        on:click={() => deleteTask(taskDetails.taskId)}
                        class="w-full rounded-md btn p-2 text-md font-bold border border-rose-700 text-rose-700 bg-white duration-150
      hover:bg-rose-700 hover:text-white">Delete</button
                    >
                </div>
            {/if}
        </div>
        <!-- svelte-ignore a11y-autofocus -->
    </div>
</dialog>
