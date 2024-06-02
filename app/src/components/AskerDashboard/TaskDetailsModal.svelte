<script lang="ts">
    import { ethers } from "ethers";

    /**
     * @type {boolean}
     */
    export let showModal = false; // boolean
    export let showLoadingModal = false;
    export let transactionStatus:number = 1;
    export let userTokenAmountDisplay;
    export let moreClasses = ""; // boolean
    export let taskDetails: any;
    export let isEditingTask = false;
    export let getMyTasks = () => {}
    export let initializeDappContract = async (): Promise<any> => {}
    export let initializeTokenContract = async (): Promise<any> => {}

    /**
     * @type {HTMLDialogElement}
     */
    let dialog: HTMLDialogElement; // HTMLDialogElement

    $: if (dialog && showModal) dialog.showModal();
    $: if (dialog && !showModal) dialog.close();

    const getSigner = async () => {
        const { ethereum } = window as any;
        const provider = new ethers.BrowserProvider(ethereum);
        return await provider.getSigner();
    };
    
    const getUserTokenAmount = async () => {
        const BordToken = await initializeTokenContract();
        const signer = await getSigner();
        var userTokenAmount = await BordToken.balanceOf(signer.address);
        userTokenAmountDisplay = Number(
            BigInt(userTokenAmount) /
                BigInt(10n ** (await BordToken.decimals()))
        );
    };

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
                getMyTasks();
            }, 500);
          }
       });
    };

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

    async function editTask(_taskId:number) {
        var editTitle = (document.getElementById("editTitleInput") as HTMLInputElement).value
        var editContent = (document.getElementById("editContentInput") as HTMLTextAreaElement).value
        var editTimeLimit = editTaskTimeLimitDays*3600*24 + editTaskTimeLimitHours*3600 + editTaskTimeLimitMinutes*60 + editTaskTimeLimitSeconds;
        // console.log(`Title: ${editTitle}\nContent: ${editContent}\nTime Limit: ${editTimeLimit}`);
        transactionStatus = 1;
        showLoadingModal = true;
        showModal = false;

        const dappContract = await initializeDappContract() as any;
        const tokenContract = await initializeTokenContract() as any;
        const decimals = await tokenContract.decimals();
        const editTaskPrice = BigInt(1)*10n**decimals;
        try {
            const response = await tokenContract.approve(dappContract.target, editTaskPrice);
            const tx = await dappContract.editTask(_taskId, editTitle, editContent, editTimeLimit);
            waitTransaction(tx);
            isEditingTask = !isEditingTask;
            showModal = false;
        } catch (error) {
            transactionStatus = 2;
            setTimeout(() => {
                showLoadingModal = false;
            }, 500);
        }
    }

    async function deleteTask(_taskId: number) {
        transactionStatus = 1;
        showLoadingModal = true;
        showModal = false;

        const dappContract = await initializeDappContract() as any;
        const tokenContract = await initializeTokenContract() as any;
        const decimals = await tokenContract.decimals();
        const deleteTaskPrice = BigInt(1)*10n**decimals;
        try {
            const response = await tokenContract.approve(dappContract.target, deleteTaskPrice);
            const tx = await dappContract.deleteTask(_taskId);
            waitTransaction(tx);
        } catch (error) {
            transactionStatus = 2;
            setTimeout(() => {
                showLoadingModal = false;
            }, 500);
        }
    }

    async function passTask(_taskId:number) {
        transactionStatus = 1;
        showLoadingModal = true;
        showModal = false;
        
        try {
            const contract = await initializeDappContract() as any;
            const tx = await contract.passTask(_taskId);
            waitTransaction(tx);
        } catch (error) {
            transactionStatus = 2;
            setTimeout(() => {
                showLoadingModal = false;
            }, 500);
        }
    }

    async function failTask(_taskId:number) {
        transactionStatus = 1;
        showLoadingModal = true;
        showModal = false;
        try {
            const contract = await initializeDappContract() as any;
            const tx = await contract.failTask(_taskId);
            waitTransaction(tx);
        } catch (error) {
            transactionStatus = 2;
            setTimeout(() => {
                showLoadingModal = false;
                showModal = false;
            }, 500);
        }
    }

    async function dropDoer(_taskId:number) {
        transactionStatus = 1;
        showLoadingModal = true;
        showModal = false;
        try {
            const dappContract = await initializeDappContract() as any;
            const tokenContract = await initializeTokenContract() as any;
            const decimals = await tokenContract.decimals();
            const currentDateTime = Math.floor(new Date().getTime()/1000);
            if (currentDateTime - taskDetails.dateTimeAccepted <= taskDetails.timeLimitVal) {
                const dropDoerEarlyPrice = BigInt(1)*10n**decimals;
                const response = await tokenContract.approve(dappContract.target, dropDoerEarlyPrice);
                const tx = await dappContract.dropDoerBeforeTimeLimit(_taskId);
                waitTransaction(tx);
            }
            else {
                const tx = await dappContract.dropDoerAfterTimeLimit(_taskId);
                waitTransaction(tx);
            }
        } catch (error) {
            transactionStatus = 2;
            setTimeout(() => {
                showLoadingModal = false;
                showModal = false;
            }, 500);
        }
    }

    function validateForm(_taskId:number) {
        var form = document.getElementById("taskDetailsForm") as HTMLFormElement;
        if(form.reportValidity()) {
            editTask(_taskId);
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
                {#if isEditingTask}
                    <input
                        id="editTitleInput"
                        class="w-full border rounded-md border-slate-400 focus-visible:outline-indigo-500 px-1"
                        type="text"
                        required
                        minlength="2"
                        maxlength="50"
                        value={taskDetails.title}
                    />
                {:else}
                    <span>{taskDetails.title}</span>
                {/if}
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
                Content:
                {#if isEditingTask}
                    <textarea
                        id="editContentInput"
                        required
                        minlength="2"
                        maxlength="250"
                        value={taskDetails.content}
                        class="w-full p-2 text-sm text-gray-700 border border-gray-300 rounded-md focus:outline-none focus-visible:outline-indigo-500"
                    ></textarea>
                {:else}
                    <span class="font-normal text-base"
                        >{taskDetails.content}</span
                    >
                {/if}
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
                {#if isEditingTask}
                    <div class="grid grid-cols-5 gap-2">
                        <div class="row-span-2 flex items-center">
                            <span class="inline-block align-middle">Time Limit:</span>
                          </div>
                        <span class=" col-start-2 text-sm font-medium text-gray-700"
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
                            required
                            min="0"
                            class="w-full font-normal text-base border rounded-md border-slate-400 focus-visible:outline-indigo-500 px-1"
                        />
                        <input
                            bind:value={editTaskTimeLimitHours}
                            type="number"
                            required
                            min="0"
                            class="w-full font-normal text-base border rounded-md border-slate-400 focus-visible:outline-indigo-500 px-1"
                        />
                        <input
                            bind:value={editTaskTimeLimitMinutes}
                            type="number"
                            required
                            min="0"
                            class="w-full font-normal text-base border rounded-md border-slate-400 focus-visible:outline-indigo-500 px-1"
                        />
                        <input
                            bind:value={editTaskTimeLimitSeconds}
                            type="number"
                            required
                            min="0"
                            class="w-full font-normal text-base border rounded-md border-slate-400 focus-visible:outline-indigo-500 px-1"
                        />
                    </div>
                {:else}
                    <span>Time Limit:</span>
                    <span class="font-normal text-base"
                        >{taskDetails.timeLimit}</span
                    >
                {/if}
            </p>
            {#if taskDetails.statusVal != 0 && taskDetails.statusVal != 1}
                <p class="mb-2 font-medium text-lg">
                    Video Link: <a href="{taskDetails.videoLink}" class=" font-medium text-base text-indigo-700"
                        >{taskDetails.videoLink}</a
                    >
                </p>
            {/if}
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
                            on:click={() => validateForm(taskDetails.taskId)}
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
            {#if taskDetails.statusVal == 2}
                <div class="mt-4">
                    <button
                        on:click={() => passTask(taskDetails.taskId)}
                        class="w-full rounded-md btn p-2 text-md font-bold border border-teal-500 text-teal-500 bg-white duration-150 mb-2 hover:bg-teal-500 hover:text-white"
                        >Pass Task</button
                    >
                    <button
                        on:click={() => failTask(taskDetails.taskId)}
                        class="w-full rounded-md btn p-2 text-md font-bold border border-rose-700 text-rose-700 bg-white duration-150
      hover:bg-rose-700 hover:text-white">Fail Task</button
                    >
                </div>
            {/if}
            {#if taskDetails.statusVal == 1}
                <div class="mt-4">
                    <button
                        on:click={() => dropDoer(taskDetails.taskId)}
                        class="w-full rounded-md btn p-2 text-md font-bold border border-rose-700 text-rose-700 bg-white duration-150 mb-2 hover:bg-rose-700 hover:text-white"
                        >Drop DOER</button
                    >
                </div>
            {/if}
        </form>
        <!-- svelte-ignore a11y-autofocus -->
    </div>
</dialog>
