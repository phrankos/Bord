<script lang="ts">
    /**
     * @type {boolean}
     */
    export let showModal = false; // boolean
    export let showLoadingModal = false;
    export let moreClasses = ""; // boolean
    export let transactionDone; // boolean
    export let getMyTasks = () => {}

    /**
     * @type {HTMLDialogElement}
     */
    let dialog: HTMLDialogElement;

    $: if (dialog && showModal) dialog.showModal();
    $: if (dialog && !showModal) dialog.close();

    
    import { Contract, JsonRpcSigner, ethers } from "ethers"; // Actual BlockChain
    import { contract, token } from "../../store/index";
    import ABI from "../../contracts/Bord.sol/Bord.json";
    import tokenABI from "../../contracts/Bord.sol/BordToken.json";

    const initializeDappContract = async () => {
        const { ethereum } = window as any;
        const provider = new ethers.BrowserProvider(ethereum);
        const signer = await provider.getSigner();
        return new Contract($contract, ABI, signer);
    };

    const initializeTokenContract = async () => {
        const signer = await getSigner();
        return new Contract($token, tokenABI, signer);
    };
    
    const getSigner = async () => {
        const { ethereum } = window as any;
        const provider = new ethers.BrowserProvider(ethereum);
        return await provider.getSigner();
    };

    let newTaskTitle = "";
    let newTaskContent = "";
    let newTaskReward = "";
    let newTaskTimeLimit = 0;
    let newTaskTimeLimitDays = 0;
    let newTaskTimeLimitHours = 0;
    let newTaskTimeLimitMinutes = 0;
    let newTaskTimeLimitSeconds = 0;
    async function createTask() {
        showLoadingModal = true;
        showModal = false;
        newTaskTimeLimit =
            newTaskTimeLimitDays * 60 * 60 * 24 +
            newTaskTimeLimitHours * 60 * 60 +
            newTaskTimeLimitMinutes * 60 +
            newTaskTimeLimitSeconds * 1;

        const dappContract = await initializeDappContract();
        const tokenContract = await initializeTokenContract();
        const decimals = await tokenContract.decimals();
        const newTaskRewardConverted = BigInt(newTaskReward)*10n**decimals;
        const response = await tokenContract.approve(dappContract.target, newTaskRewardConverted);
        const tx = await dappContract.createTask(
            newTaskTitle,
            newTaskContent,
            newTaskReward,
            newTaskTimeLimit
        );
        transactionDone = true;
        setTimeout(() => {
            showLoadingModal = false;
            getMyTasks();
        }, 500);
    }

    
    function validateForm() {
        const form = document.getElementById("createTaskForm") as HTMLFormElement;
        const rewardInputElement = document.getElementById("reward") as HTMLInputElement;

        const value = parseInt(rewardInputElement.value);
        if (value % 2 != 1) {
            rewardInputElement.setCustomValidity("Reward must be an odd amount.");
        }
        else {
            rewardInputElement.setCustomValidity("");
            if(form.reportValidity()) {
                createTask();
            }
        }

    }

</script>

<!-- svelte-ignore a11y-click-events-have-key-events a11y-no-noninteractive-element-interactions -->
<dialog
    class={` select-none rounded-md backdrop:bg-gray-800 backdrop:bg-opacity-50 bg-zinc-50 justify-items-center focus-visible:outline-none ${moreClasses}`}
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
        <div class="w-[25rem] p-4 mx-auto bg-white rounded-md">
            <h2 class="text-lg font-bold mb-4">Create TASK</h2>
            <form id="createTaskForm">
                <div class="flex flex-col mb-4">
                    <label for="title" class="text-sm font-medium text-gray-700"
                        >Title</label
                    >
                    <input
                        bind:value={newTaskTitle}
                        required
                        minlength="2"
                        maxlength="50"
                        type="text"
                        id="title"
                        class="w-full p-2 text-sm text-gray-700 border border-gray-300 rounded-md focus:outline-none focus:ring-indigo-500"
                    />
                </div>
                <div class="flex flex-col mb-4">
                    <label for="content" class="text-sm font-medium text-gray-700"
                        >Content</label
                    >
                    <textarea
                        required
                        minlength="2"
                        maxlength="250"
                        bind:value={newTaskContent}
                        id="content"
                        class="w-full p-2 text-sm text-gray-700 border border-gray-300 rounded-md focus:outline-none focus:ring-indigo-500"
                    ></textarea>
                </div>
                <div class="flex flex-col mb-4">
                    <label for="reward" class="text-sm font-medium text-gray-700"
                        >Reward (BRD)</label
                    >
                    <input
                        required
                        min=3
                        bind:value={newTaskReward}
                        type="number"
                        id="reward"
                        class="w-full p-2 text-sm text-gray-700 border border-gray-300 rounded-md focus:outline-none focus:ring-indigo-500"
                    />
                </div>
                <div class="flex flex-col mb-4">
                    <span class="text-sm font-medium text-gray-700 mb-1"
                        >Time Limit</span
                    >
                    <div class="grid grid-cols-4 gap-2">
                        <label for="days" class="text-sm font-medium text-gray-700"
                            >Days</label
                        >
                        <label for="hours" class="text-sm font-medium text-gray-700"
                            >Hours</label
                        >
                        <label for="minutes" class="text-sm font-medium text-gray-700"
                            >Minutes</label
                        >
                        <label for="seconds" class="text-sm font-medium text-gray-700"
                            >Seconds</label
                        >
                        <input
                            bind:value={newTaskTimeLimitDays}
                            type="number"
                            required
                            min=0
                            id="days"
                            class="p-2 text-sm text-gray-700 border border-gray-300 rounded-md focus:outline-none focus:ring-indigo-500"
                        />
                        <input
                            bind:value={newTaskTimeLimitHours}
                            type="number"
                            required
                            min=0
                            max=23
                            id="hours"
                            class="p-2 text-sm text-gray-700 border border-gray-300 rounded-md focus:outline-none focus:ring-indigo-500"
                        />
                        <input
                            bind:value={newTaskTimeLimitMinutes}
                            type="number"
                            required
                            min="0"
                            max=59
                            id="minutes"
                            class="p-2 text-sm text-gray-700 border border-gray-300 rounded-md focus:outline-none focus:ring-indigo-500"
                        />
                        <input
                            bind:value={newTaskTimeLimitSeconds}
                            type="number"
                            required
                            min="0"
                            max=59
                            id="seconds"
                            class="p-2 text-sm text-gray-700 border border-gray-300 rounded-md focus:outline-none focus:ring-indigo-500"
                        />
                    </div>
                </div>
            </form>
            <div class="mt-4">
                <!-- <button
                    on:click={() => (showModal = false)}
                    class="bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded-md"
                    >Cancel</button
                >
                <button
                    on:click={validateForm}
                    class="bg-indigo-500 hover:bg-indigo-700 text-white font-bold py-2 px-4 rounded-md ml-2 cursor-pointer"
                >Create</button> -->
                <button
                on:click={validateForm}
                    class=" w-[49%] rounded-md btn p-2 text-md font-bold border border-indigo-700 text-indigo-500 bg-white duration-150 mb-2 hover:bg-indigo-700 hover:text-white"
                    >Create</button
                >
                <button
                on:click={() => (showModal = false)}
                    class="float-right w-[49%] rounded-md btn p-2 text-md font-bold border border-rose-700 text-rose-700 bg-white duration-150
                    hover:bg-rose-700 hover:text-white"
                    >Cancel</button
                >
            </div>
        </div>
        <!-- svelte-ignore a11y-autofocus -->
    </div>
</dialog>
