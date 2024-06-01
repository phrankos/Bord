<script lang="ts">
    import DoerNavBar from "../../components/DoerDashboard/DoerNavBar.svelte";
    import { onMount } from "svelte";
    import { Contract, JsonRpcSigner, ethers } from "ethers"; // Actual BlockChain
    import { contract } from "../../store/index";
    import ABI from "../../contracts/Bord.sol/Bord.json";
    import SectionWrapper from "../../components/SectionWrapper.svelte";
    import Modal from "../../components/Modal.svelte";
    import LoadingModal from "../../components/LoadingModal.svelte";
    import { goto } from "$app/navigation";

    let currentAccount: string;
    async function getCurrentAccount() {
        const { ethereum } = window as any;
        const accounts = await ethereum.request({ method: "eth_accounts" });
        currentAccount = accounts[0];
    }
    onMount(() => {
        if (localStorage.getItem("role") != "DOER") {
            goto("/roles", {});
        }
        getCurrentAccount();
        getOpenTasks();
        getTasksByDoer();
    });

    const initializeContract = async () => {
        const { ethereum } = window as any;
        const provider = new ethers.BrowserProvider(ethereum);
        const signer = await provider.getSigner();
        return new Contract($contract, ABI, signer);
    };


    let tasks: any[] = [];
    let myTasks: any[] = [];

    async function getOpenTasks() {
        const contract = await initializeContract();
        const tasksResponse = await contract.getOpenTasks();
        tasks = tasksResponse.map(
            (task: {
                taskId: any;
                asker: any;
                doer: any;
                title: any;
                content: any;
                reward: any;
                dateTimeCreated: any;
                timeLimit: any;
                status: any;
                statusVal: any;
                videoLink: any;
                viewPrice: any;
            }) => ({
                taskId: task.taskId,
                asker: task.asker,
                doer: task.doer,
                title: task.title,
                content: task.content,
                reward: Number(task.reward),
                dateTimeCreated: Number(task.dateTimeCreated),
                timeLimit: (function () {
                    var seconds = Number(task.timeLimit);
                    const days = Math.floor(seconds / (3600 * 24));
                    seconds -= days * 3600 * 24;
                    const hours = Math.floor(seconds / 3600);
                    seconds -= hours * 3600;
                    const minutes = Math.floor(seconds / 60);
                    seconds -= minutes * 60;

                    let formatted = "";
                    if (days > 0)
                        formatted += `${days} day${days > 1 ? "s" : ""} `;
                    if (hours > 0)
                        formatted += `${hours} hour${hours > 1 ? "s" : ""} `;
                    if (minutes > 0)
                        formatted += `${minutes} minute${minutes > 1 ? "s" : ""} `;
                    if (seconds > 0 || formatted === "")
                        formatted += `${seconds} second${seconds !== 1 ? "s" : ""}`;

                    return formatted.trim();
                })(),
                status: (function () {
                    switch (Number(task.status)) {
                        case -1:
                            return "Deleted";
                        case 0:
                            return "Open";
                        case 1:
                            return "Accepted";
                        case 2:
                            return "Submitted";
                        case 3:
                            return "Completed";
                        case 4:
                            return "Claimable";
                        case 5:
                            return "Failed";
                        case 6:
                            return "Disputing";
                        default:
                            return "NULL";
                    }
                })(),
                statusVal: Number(task.status),
                videoLink: task.videoLink,
                viewPrice: task.viewPrice,
            })
        );
        filteredTasks = tasks;
        setFilter("Open");
        console.log(tasks);
    }

    async function getTasksByDoer() {
        const contract = await initializeContract();
        const tasksResponse = await contract.getTasksByDoer();
        myTasks = tasksResponse.map(
            (task: {
                taskId: any;
                asker: any;
                doer: any;
                title: any;
                content: any;
                reward: any;
                dateTimeCreated: any;
                timeLimit: any;
                status: any;
                statusVal: any;
                videoLink: any;
                viewPrice: any;
            }) => ({
                taskId: task.taskId,
                asker: task.asker,
                doer: (function () {
                    // console.log(Number(task.doer));
                    if (Number(task.doer) == 0) {
                        return "None";
                    } else {
                        return task.doer;
                    }
                })(),
                title: task.title,
                content: task.content,
                reward: Number(task.reward),
                dateTimeCreated: Number(task.dateTimeCreated),
                timeLimit: (function () {
                    var seconds = Number(task.timeLimit);
                    const days = Math.floor(seconds / (3600 * 24));
                    seconds -= days * 3600 * 24;
                    const hours = Math.floor(seconds / 3600);
                    seconds -= hours * 3600;
                    const minutes = Math.floor(seconds / 60);
                    seconds -= minutes * 60;

                    let formatted = "";
                    if (days > 0)
                        formatted += `${days} day${days > 1 ? "s" : ""} `;
                    if (hours > 0)
                        formatted += `${hours} hour${hours > 1 ? "s" : ""} `;
                    if (minutes > 0)
                        formatted += `${minutes} minute${minutes > 1 ? "s" : ""} `;
                    if (seconds > 0 || formatted === "")
                        formatted += `${seconds} second${seconds !== 1 ? "s" : ""}`;

                    return formatted.trim();
                })(),
                status: (function () {
                    switch (Number(task.status)) {
                        case -1:
                            return "Deleted";
                        case 0:
                            return "Open";
                        case 1:
                            return "Accepted";
                        case 2:
                            return "Submitted";
                        case 3:
                            return "Completed";
                        case 4:
                            return "Claimable";
                        case 5:
                            return "Failed";
                        case 6:
                            return "Disputing";
                        default:
                            return "NULL";
                    }
                })(),
                statusVal: Number(task.status),
                videoLink: task.videoLink,
                viewPrice: task.viewPrice,
            })
        );
        console.log(myTasks);
    }

    let taskDetails = {
        taskId: 0,
        asker: "",
        doer: "",
        title: "",
        content: "",
        reward: 0,
        dateTimeCreated: 0,
        timeLimit: 0,
        status: "",
        statusVal: 0,
        videoLink: "",
        viewPrice: 0,
    };

    let showLoadingModal: boolean = false;
    let transactionDone: boolean = false;
    let showTaskDetailsModal: boolean = false;
    async function openTaskDetails(taskId: number) {
        showTaskDetailsModal = true;
        taskDetails = filteredTasks.filter((task) => task.taskId === taskId)[0];
    }

    function waitTransaction() {
        transactionDone = true;
        setTimeout(() => {
            showLoadingModal = false;
            showTaskDetailsModal = false;
            getOpenTasks();
            getTasksByDoer();
        }, 500);
    }

    async function acceptTask(_taskId: number) {
        showLoadingModal = true;
        const contract = await initializeContract();
        try {
            const tx = await contract.acceptTask(_taskId);
            waitTransaction();
        } catch {
            console.log("An error has occured. Please try the transaction again.");
        }
    }

    let filter = "Open";
    let filteredTasks: any[] = [];
    function setFilter(_filter: string) {
        filter = _filter;
        // console.log(Number(task.asker) != Number(currentAccount));
        if (_filter === "Open") {
            filteredTasks = tasks;
            filteredTasks = filteredTasks.filter((task) => Number(task.asker) != Number(currentAccount));
        } else {
            filteredTasks = myTasks.filter((task) => task.status === _filter);
            filteredTasks = filteredTasks.filter((task) => Number(task.asker) != Number(currentAccount));
        }
        console.log(filteredTasks);
    }

    async function abandonTask(_taskId: number) {
        showLoadingModal = true;
        const contract = await initializeContract();
        try {
            const tx = await contract.abandonTask(_taskId);
            waitTransaction();
        } catch {
            console.log("An error has occured. Please try the transaction again.");
        }
    }

    async function submitTask(_taskId: number) {
        showLoadingModal = true;
        const contract = await initializeContract();
        try {
            const tx = await contract.submitTask(_taskId, "_videoLink", taskDetails.viewPrice);
            waitTransaction();
        } catch {
            console.log("An error has occured. Please try the transaction again.");
        }
    }

    async function claimReward(_taskId: number) {
        showLoadingModal = true;
        const contract = await initializeContract();
        try {
            const tx = await contract.claimReward(_taskId);
            waitTransaction();
        } catch {
            console.log("An error has occured. Please try the transaction again.");
        }
    }

    async function disputeTask(_taskId: number) {
        showLoadingModal = true;
        const contract = await initializeContract();
        try {
            const tx = await contract.disputeTask(_taskId);
            waitTransaction();
        } catch {
            console.log("An error has occured. Please try the transaction again.");
        }
    }
</script>

<title>DOER Dashboard</title>

<DoerNavBar />
<main class="flex flex-col">
    <SectionWrapper id="AskerDash">
        <div class="pt-10 pb-20">
            <h1 class="text-5xl font-bold mb-4">DOER Dashboard</h1>
            <ul class="text-xl select-none flex text-center mt-8">
                {#each ["Open", "Accepted", "Submitted", "Claimable", "Completed", "Failed", "Disputing"] as status}
                    <!-- svelte-ignore a11y-click-events-have-key-events -->
                    <!-- svelte-ignore a11y-no-noninteractive-element-interactions -->
                    <li
                        class={`flex-1 py-4 rounded-t-lg cursor-pointer
                  ${filter === status ? " font-medium text-indigo-700 border-2 border-b-0 border-zinc-300" : "text-slate-600 hover:bg-zinc-100 hover:border-t-2 hover:border-zinc-300 hover:text-indigo-700 hover:to-0% bg-gradient-to-t from-zinc-200 to-10% bg-zinc-100 border-t-2 border-b-zinc-300 border-zinc-100"}`}
                        on:click={() => setFilter(status)}
                    >
                        {status}
                    </li>
                {/each}
            </ul>
            <ul
                class="grid grid-cols-1 mt-10 md:grid-cols-2 lg:grid-cols-3 gap-4"
            >
                {#each filteredTasks as task}
                    <li
                        class="font-mono text-slate-700 bg-zinc-50 border border-slate-200 text-wrap overflow-clip shadow-md transition duration-200
            hover:cursor-pointer hover:shadow-2xl hover:bg-white hover:text-black"
                    >
                        <button
                            class="p-4 w-full text-left"
                            on:click={() => openTaskDetails(task.taskId)}
                        >
                            <h2 class="text-xl font-bold">{task.title}</h2>
                            <!-- <p>Content: {task.content}</p> -->
                            <p class=" font-medium">
                                Reward: <span class="font-normal"
                                    >{task.reward}</span
                                >
                            </p>
                            <p class=" font-medium">
                                Status: <span class="font-normal"
                                    >{task.status}</span
                                >
                            </p>
                            <p class=" font-medium">
                                Date Created: <span class="font-normal"
                                    >{new Date(task.dateTimeCreated * 1000)
                                        .toLocaleString()
                                        .split(",")[0]}</span
                                >
                            </p>
                        </button>
                    </li>
                {/each}
            </ul>
        </div>
    </SectionWrapper>

    {#if showLoadingModal}
        <LoadingModal bind:showLoadingModal bind:transactionDone />
    {/if}

    <Modal bind:showModal={showTaskDetailsModal} moreClasses="focus-visible:outline-none select-none">
        <div class="p-6">
            <h2 class="text-3xl text-center font-bold mb-4">
                {taskDetails.title}
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
                Content: <span class="font-normal text-base"
                    >{taskDetails.content}</span
                >
            </p>
            <p class="mb-2 font-medium text-lg">
                Reward: <span class="font-normal text-base"
                    >{taskDetails.reward}</span
                >
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
                Time Limit: <span class="font-normal text-base"
                    >{taskDetails.timeLimit}</span
                >
            </p>
            <p class="mb-2 font-medium text-lg">
                Video Link: 
                {#if taskDetails.statusVal == 1 && Number(currentAccount) == Number(taskDetails.doer)}
                    <input required type="url" id="videoLink" placeholder="Enter a video link" bind:value={taskDetails.videoLink} class="p-2 text-sm text-gray-700 border border-gray-300 rounded-md focus:outline-none focus:ring-indigo-500">
                {:else}
                    <span class="font-normal text-base">{taskDetails.videoLink}</span>
                {/if}
            </p>
            <div class="mt-4">
                {#if taskDetails.statusVal == 0 && Number(currentAccount) != Number(taskDetails.asker)}
                    <button
                        on:click={() => acceptTask(Number(taskDetails.taskId))}
                        class="w-full rounded-md btn p-2 text-md font-bold border border-indigo-500 text-indigo-700 bg-white duration-150 
       hover:bg-indigo-700 hover:text-white">Accept Task</button 
                    >
                {:else if taskDetails.statusVal == 1}
                <p class="mb-2 font-medium text-lg">
                    View Price: 
                    <input required type="number" min=1 id="viewPrice" bind:value={taskDetails.viewPrice} class="p-2 text-sm text-gray-700 border border-gray-300 rounded-md focus:outline-none focus:ring-indigo-500">
                </p>
                    <button
                        on:click={() => submitTask(Number(taskDetails.taskId))}
                        class="w-full rounded-md btn p-2 text-md font-bold border border-teal-600 text-teal-600 bg-white duration-150 mb-2 
    hover:bg-teal-600 hover:text-white">Submit Task</button 
                    >
                    <button
                        on:click={() => abandonTask(Number(taskDetails.taskId))}
                        class="w-full rounded-md btn p-2 text-md font-bold border border-rose-700 text-rose-700 bg-white duration-150 
    hover:bg-rose-700 hover:text-white">Abandon Task</button 
                    >
                {:else if taskDetails.statusVal == 4}
                    <button
                        on:click={() => claimReward(Number(taskDetails.taskId))}
                        class="w-full rounded-md btn p-2 text-md font-bold border border-teal-600 text-teal-600 bg-white duration-150 mb-2 
    hover:bg-teal-600 hover:text-white">Claim Reward</button 
                    >
                {:else if taskDetails.statusVal == 5}
                    <button
                        on:click={() => disputeTask(Number(taskDetails.taskId))}
                        class="w-full rounded-md btn p-2 text-md font-bold border border-indigo-700 text-indigo-700 bg-white duration-150 mb-2 
    hover:bg-indigo-700 hover:text-white">Dispute Task</button 
                    >
                {/if}
            </div>
        </div>
    </Modal>
</main>
