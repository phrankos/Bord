<script lang="ts">
    /**
     * @type {boolean}
     */
    export let showModal = false; // boolean
    export let showLoadingModal = false;
    export let transactionStatus = 1;
    export let moreClasses = ""; // boolean
    export let taskDetails: any;
    export let voteStatus: any;
    export let getAllTasks = () => {}
    export let getUserTokenAmount = () => {}
    export let initializeDappContract = async (): Promise<any> => {}
    export let initializeTokenContract = async (): Promise<any> => {}

    /**
     * @type {HTMLDialogElement}
     */
    let dialog: HTMLDialogElement; // HTMLDialogElement

    $: if (dialog && showModal) dialog.showModal();
    $: if (dialog && !showModal) dialog.close();

    const waitTransaction = async (tx: any) => {
        transactionStatus = 1;
        showLoadingModal = true;
        
        tx.wait().then(async (receipt: any) => {
        console.log("start", receipt, receipt.status);
          if (receipt && receipt.status == 1) {
            console.log("end", receipt, receipt.status);
             // transaction success.
            transactionStatus = 0;
            setTimeout(() => {
                showLoadingModal = false;
                getUserTokenAmount();
                getAllTasks();
            }, 500);
          }
       });
    };

    async function voteTaskSucceeded(_taskId: number) {
        transactionStatus = 1;
        showLoadingModal = true;
        showModal = false;
        try {
            if (Number(voteStatus[0]) != Number(voteStatus[1])) {
                const dappContract = await initializeDappContract() as any;
                const tokenContract = await initializeTokenContract() as any;
                const decimals = await tokenContract.decimals();
                const voteTaskPrice = BigInt(1)*10n**decimals;
                const response = await tokenContract.approve(dappContract.target, voteTaskPrice);
                const tx = await dappContract.voteSucceedTask(_taskId);
                waitTransaction(tx);
            }
        } catch (error) {
            transactionStatus = 2;
            setTimeout(() => {
                showLoadingModal = false;
            }, 500);
        }
    }

    async function voteTaskFailed(_taskId: number) {
        transactionStatus = 1;
        showLoadingModal = true;
        showModal = false;
        try {
            if (Number(voteStatus[0]) != Number(voteStatus[1])) {
                const dappContract = await initializeDappContract() as any;
                const tokenContract = await initializeTokenContract() as any;
                const decimals = await tokenContract.decimals();
                const voteTaskPrice = BigInt(1)*10n**decimals;
                const response = await tokenContract.approve(dappContract.target, voteTaskPrice);
                const tx = await dappContract.voteFailTask(_taskId);
                waitTransaction(tx);
            }
        } catch (error) {
            transactionStatus = 2;
            setTimeout(() => {
                showLoadingModal = false;
            }, 500);
        }
    }


</script>

<!-- svelte-ignore a11y-click-events-have-key-events a11y-no-noninteractive-element-interactions -->
<dialog
    class={` select-none w-[40rem] rounded-md backdrop:bg-gray-800 backdrop:bg-opacity-50 bg-zinc-50 justify-items-center focus-visible:outline-none ${moreClasses}`}
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
        <form id="taskDetailsForm" class="p-6">
            <h2 class="text-3xl text-center font-bold mb-4">
            <span>{taskDetails.title}</span>
            </h2>
            <!-- <p class="mb-2 font-medium text-lg">
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
                Status: <span class="font-normal text-base"
                    >{taskDetails.status}</span
                >
            </p> -->
            <p class="mb-2 font-medium text-lg">
                Content: <span class="font-normal text-base"
                        >{taskDetails.content}</span
                    >
            </p>
            <p class="mb-2 font-medium text-lg">
                Reward: <span class="font-normal text-base"
                >{taskDetails.reward} BRD</span
            >
            </p>
            <p class="mb-2 font-medium text-lg">
                Date Created: <span class="font-normal text-base"
                    >{new Date(taskDetails.dateTimeCreated * 1000)
                        .toLocaleString()}</span
                >
            </p>
            {#if taskDetails.statusVal != 0}
                <p class="mb-2 font-medium text-lg">
                    Date Accepted: <span class="font-normal text-base"
                        >{new Date(taskDetails.dateTimeAccepted * 1000)
                            .toLocaleString()}</span
                    >
                </p>
            {/if}
            <p class="mb-2 font-medium text-lg">
                <span>Time Limit:</span>
                    <span class="font-normal text-base"
                        >{taskDetails.timeLimit}</span
                    >
            </p>
            {#if taskDetails.statusVal != 0 || taskDetails.statusVal != 1}
                <p class="mb-2 font-medium text-lg">
                    Video Link: <a href="{taskDetails.videoLink}" class=" font-medium text-base text-indigo-700"
                        >{taskDetails.videoLink}</a
                    >
                </p>
            {/if}
            {#if taskDetails.statusVal == 6}
                <div>
                    <div class="flex my-4">
                        <p class="w-fit text-nowrap mb-2 font-medium text-lg mr-4">
                            Vote Progress:
                        </p>
                        <div class=" text-lg font-medium text-center w-full h-7 bg-zinc-300 rounded-full dark:bg-gray-700 shadow-inner shadow-zinc-400">
                            <span class=" absolute">{Number(voteStatus[0]) > 0 ? "" : `${Number(voteStatus[0])} / ${Number(voteStatus[1])}`}</span>
                            <div class=" h-7 text-white shadow-md shadow-indigo-500 bg-indigo-700 rounded-full" style={`width: ${Number(voteStatus[0])/Number(voteStatus[1])*100}%`}>
                                {Number(voteStatus[0]) > 0 ? `${Number(voteStatus[0])} / ${Number(voteStatus[1])}` : ""}
                            </div>
                        </div>
                    </div>
                    <button
                        on:click={() => voteTaskSucceeded(taskDetails.taskId)}
                        class="w-full rounded-md btn p-2 text-md font-bold border border-teal-500 text-teal-500 bg-white duration-150 mb-2 hover:bg-teal-500 hover:text-white"
                        >Vote Succeeded</button
                    >
                    <button
                        on:click={() => voteTaskFailed(taskDetails.taskId)}
                        class="w-full rounded-md btn p-2 text-md font-bold border border-rose-700 text-rose-700 bg-white duration-150
      hover:bg-rose-700 hover:text-white">Vote Failed</button
                    >
                </div>
            {/if}
        </form>
        <!-- svelte-ignore a11y-autofocus -->
    </div>
</dialog>
