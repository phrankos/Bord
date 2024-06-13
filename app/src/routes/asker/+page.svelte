<script lang="ts">
    import { Contract, JsonRpcSigner, ethers } from "ethers"; // Actual BlockChain
    import { contract, token } from "../../store/index";
    import dappABI from "../../contracts/Bord.sol/Bord.json";
    import tokenABI from "../../contracts/Bord.sol/BordToken.json";
    import { onMount } from "svelte";
    import { goto } from "$app/navigation";
    import SectionWrapper from "../../components/SectionWrapper.svelte";
    import LoadingModal from "../../components/LoadingModal.svelte";
    import TaskDetailsModal from "../../components/AskerDashboard/TaskDetailsModal.svelte";
    import CreateTaskModal from "../../components/AskerDashboard/CreateTaskModal.svelte";
    import NavBarApp from "../../components/NavBarApp.svelte";

    onMount(() => {
        if (localStorage.getItem("role") != "ASKER") {
            goto("/roles", {});
        }
        getMyTasks();
    });

    const getSigner = async () => {
        const { ethereum } = window as any;
        const provider = new ethers.BrowserProvider(ethereum);
        return await provider.getSigner();
    };

    const initializeDappContract = async () => {
        const signer = await getSigner();
        return new Contract($contract, dappABI, signer);
    };

    const initializeTokenContract = async () => {
        const signer = await getSigner();
        return new Contract($token, tokenABI, signer);
    };

    let tasks: any[] = [];
    let filteredTasks: any[] = [];
    let transactionStatus: number = 1;
    let showLoadingModal: boolean = false;
    let userTokenAmountDisplay = 0;

    async function getMyTasks() {
        const contract = await initializeDappContract();
        const tasksResponse = await contract.getTasksByAsker();
        tasks = tasksResponse.map(
            (task: {
                taskId: any;
                asker: any;
                doer: any;
                title: any;
                content: any;
                reward: any;
                dateTimeCreated: any;
                dateTimeAccepted: any;
                timeLimit: any;
                timeLimitVal: any;
                status: any;
                statusVal: any;
                videoLink: any;
                // viewPrice: any;
            }) => ({
                taskId: task.taskId,
                asker: task.asker,
                doer: task.doer,
                title: task.title,
                content: task.content,
                reward: Number(task.reward),
                dateTimeCreated: Number(task.dateTimeCreated),
                dateTimeAccepted: Number(task.dateTimeAccepted),
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
                timeLimitVal: task.timeLimit,
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
                // viewPrice: task.viewPrice
            })
        );
        filteredTasks = tasks;
        setFilter(filter);
    }

    let taskDetails = {
        taskId: 0,
        asker: "",
        doer: "",
        title: "",
        content: "",
        reward: 0,
        dateTimeCreated: 0,
        dateTimeAccepted: 0,
        timeLimit: 0,
        timeLimitVal: 0,
        status: "",
        statusVal: 0,
        videoLink: "",
        // viewPrice: 0
    };

    let showTaskDetailsModal: boolean = false;
    let showTaskCreateModal: boolean = false;
    let isEditingTask = false;
    async function openTaskDetails(taskId: number) {
        showTaskDetailsModal = true;
        isEditingTask = false;
        taskDetails = tasks.filter((task) => task.taskId === taskId)[0];
    }

    let filter = "Open";
    function setFilter(_filter: string) {
        filter = _filter;
        filteredTasks = tasks.filter((task) => task.status === _filter);
    }

</script>

<title>ASKER Dashboard</title>

<NavBarApp bind:showLoadingModal bind:transactionStatus={transactionStatus} bind:userTokenAmountDisplay/>
<main class="flex flex-col">
    <SectionWrapper id="AskerDash">
        <div class="pt-10 pb-20">
            <h1 class="text-5xl font-bold mb-4">ASKER Dashboard</h1>
            <div class="flex max-w-full mt-6">
                <button class="w-fit inline-block text-xl font-bold text-indigo-700 rounded-md border border-indigo-500 py-2 px-4
                transition duration-200 hover:text-white hover:bg-indigo-700 hover:shadow-lg hover:shadow-indigo-300" on:click={() => showTaskCreateModal = true}>
                    <i class="fa-solid fa-square-plus"></i>
                    Create TASK
                </button>
            </div>
            <ul class="block text-xl select-none flex text-center mt-3">
                {#each ["Open", "Accepted", "Submitted", "Claimable", "Completed", "Failed", "Disputing"] as status}
                    <!-- svelte-ignore a11y-click-events-have-key-events -->
                    <!-- svelte-ignore a11y-no-noninteractive-element-interactions -->
                    <li
                        class={`flex-1 py-4 rounded-t-lg cursor-pointer
                  ${filter === status ? " font-medium text-indigo-700 border-2 border-b-0 border-zinc-300" : "text-slate-600 hover:bg-zinc-100 hover:border-t-2 hover:border-zinc-300 hover:text-indigo-700 hover:to-0% bg-gradient-to-t from-zinc-200 to-10% bg-zinc-100 border-t-0 border-b-zinc-300 border-zinc-100"}`}
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
                                    >{task.reward} BRD</span
                                >
                            </p>
                            <p class=" font-medium">
                                Time Limit: <span class="font-normal"
                                    >{task.timeLimit}</span
                                >
                            </p>
                            <!-- <p class=" font-medium">
                                Status: <span class="font-normal"
                                    >{task.status}</span
                                >
                            </p> -->
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
        <LoadingModal bind:showLoadingModal bind:transactionStatus={transactionStatus} />
    {/if}

    {#if showTaskDetailsModal}
        <TaskDetailsModal bind:showModal={showTaskDetailsModal} bind:taskDetails bind:isEditingTask bind:showLoadingModal bind:transactionStatus={transactionStatus} 
        initializeDappContract={initializeDappContract} initializeTokenContract={initializeTokenContract}  bind:userTokenAmountDisplay getMyTasks={getMyTasks}/>
    {/if}

    {#if showTaskCreateModal}
        <CreateTaskModal bind:showLoadingModal bind:transactionStatus={transactionStatus} getMyTasks={getMyTasks} bind:showModal={showTaskCreateModal}  bind:userTokenAmountDisplay/>
    {/if}
</main>
