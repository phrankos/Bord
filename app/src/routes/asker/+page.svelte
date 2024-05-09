<script lang="ts">
  import AskerNavBar from "../../components/AskerDashboard/AskerNavBar.svelte";
  import { onMount } from 'svelte';
  import { Contract, JsonRpcSigner, ethers} from 'ethers'; // Actual BlockChain
  import { contract } from "../../store/index";
  import ABI  from "../../contracts/Bord.sol/Bord.json"
  import SectionWrapper from "../../components/SectionWrapper.svelte";
  import Modal from "../../components/Modal.svelte";
  import { goto } from "$app/navigation";
  import LoadingModal from "../../components/LoadingModal.svelte";

  onMount(() => {
    if (localStorage.getItem('role') != "ASKER") {
      goto("/roles", {});
    }
    getMyTasks();
  });


  const initializeContract = async (signer: JsonRpcSigner) => {
    return new Contract(
      $contract,
      ABI,
      signer
    );
  };
  
  let newTaskTitle = "";
  let newTaskContent = "";
  let newTaskPrize = "";
  let newTaskTimeLimit = 0;
  let tasks: any[] = [];
  let filteredTasks: any[] = [];
  let transactionDone: boolean = false;
  let showLoadingModal: boolean = false;

  async function createTask() {
    showLoadingModal = true;
    showTaskCreateModal = false;
    const { ethereum } = window as any;
    const provider = new ethers.BrowserProvider(ethereum);
    const signer = await provider.getSigner();
    const contract = await initializeContract(signer);
    const tx = await contract.createTask(newTaskTitle, newTaskContent, newTaskPrize, newTaskTimeLimit);
    transactionDone = true;
    setTimeout(() => {
      showLoadingModal = false;
      getMyTasks();
    }, 500);
  }

  async function getMyTasks() {
    const { ethereum } = window as any;
    const provider = new ethers.BrowserProvider(ethereum);
    const signer = await provider.getSigner();
    const contract = await initializeContract(signer);
    const tasksResponse = await contract.getTasksByAsker();
    tasks = tasksResponse.map((
      task: {
        taskId: any;
        asker: any;
        doer: any;
        title: any;
        content: any;
        prize: any;
        dateTimeCreated: any;
        timeLimit: any;
        status: any;
        statusVal: any;
        videoLink: any;
      }) => ({
        taskId: task.taskId,
        asker: task.asker,
        doer: task.doer,
        title: task.title,
        content: task.content,
        prize: Number(task.prize),
        dateTimeCreated: Number(task.dateTimeCreated),
        timeLimit: (function() {
          var seconds = Number(task.timeLimit);
          const days = Math.floor(seconds / (3600 * 24));
          seconds -= days * 3600 * 24;
          const hours = Math.floor(seconds / 3600);
          seconds -= hours * 3600;
          const minutes = Math.floor(seconds / 60);
          seconds -= minutes * 60;
          
          let formatted = '';
          if (days > 0) formatted += `${days} day${days > 1 ? 's' : ''} `;
          if (hours > 0) formatted += `${hours} hour${hours > 1 ? 's' : ''} `;
          if (minutes > 0) formatted += `${minutes} minute${minutes > 1 ? 's' : ''} `;
          if (seconds > 0 || formatted === '') formatted += `${seconds} second${seconds !== 1 ? 's' : ''}`;
          
          return formatted.trim();
        }()),
        status: (function(){
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
                    default:
                      return "NULL";
                  }})() ,
        statusVal: Number(task.status),
        videoLink: task.videoLink,
    }));
    filteredTasks = tasks;
    console.log(tasks);
  }
  
  let taskDetails={
    taskId: 0,
    asker: "",
    doer: "",
    title: "",
    content: "",
    prize: 0,
    dateTimeCreated: 0,
    timeLimit: 0,
    status: "",
    statusVal: 0,
    videoLink: ""
  }

  let showTaskDetailsModal: boolean = false;
  let showTaskCreateModal: boolean = false;
  async function openTaskDetails(taskId:number) {
    showTaskDetailsModal = true;
    taskDetails = tasks.filter((task) => task.taskId === taskId)[0];
    // const { ethereum } = window as any;
    // const provider = new ethers.BrowserProvider(ethereum);
    // const signer = await provider.getSigner();
    // const contract = await initializeContract(signer);
    // const taskResponse = await contract.getTask(taskId);
    // taskDetails = {
    //   taskId: taskResponse.taskId,
    //   asker: taskResponse.asker,
    //   doer: taskResponse.doer,
    //   title: taskResponse.title,
    //   content: taskResponse.content,
    //   prize: Number(taskResponse.prize),
    //   dateTimeCreated: Number(taskResponse.dateTimeCreated),
    //   timeLimit: Number(taskResponse.timeLimit),
    //   status: (function() {
    //     switch (Number(taskResponse.status)) {
    //       case -1:
    //         return "Deleted";
    //       case 0:
    //         return "Open";
    //       case 1:
    //         return "Accepted";
    //       case 2:
    //         return "Submitted";
    //       case 3:
    //         return "Completed";
    //       default:
    //         return "NULL";
    //     }
    //   })(),
    //   videoLink: taskResponse.videoLink,
    // };
  }

  let filter = "All";
  function setFilter(_filter: string) {
    filter = _filter;
    if (_filter === "All") {
      filteredTasks = tasks;
    }
    else {
      filteredTasks = tasks.filter(task => task.status === _filter);
    }
    console.log(filteredTasks);
  }
</script>

<title>ASKER Dashboard</title>

<AskerNavBar bind:showTaskCreateModal={showTaskCreateModal} />
<main class="flex flex-col">
  <SectionWrapper id="AskerDash">
    <div class="pt-10 pb-20">
      <h1 class="text-5xl font-bold mb-4">ASKER Dashboard</h1>
      <ul class="text-xl select-none flex text-center mt-8">
        {#each ['All', 'Open', 'Accepted', 'Submitted', 'Completed', 'Deleted'] as status}
          <!-- svelte-ignore a11y-click-events-have-key-events -->
          <!-- svelte-ignore a11y-no-noninteractive-element-interactions -->
          <li
            class={`flex-1 py-4 rounded-t-lg cursor-pointer
                  ${filter === status? ' font-medium text-indigo-700 border-2 border-b-0 border-zinc-300' : 'text-slate-600 hover:bg-zinc-100 hover:border-t-2 hover:border-zinc-300 hover:text-indigo-700 hover:to-0% bg-gradient-to-t from-zinc-200 to-10% bg-zinc-100 border-t-0 border-b-zinc-300 border-zinc-100'}`}
            on:click={() => setFilter(status)}
          >
            {status}
          </li>
        {/each}
      </ul>
      <ul class="grid grid-cols-1 mt-10 md:grid-cols-2 lg:grid-cols-3 gap-4">
        {#each filteredTasks as task}
          <li class="font-mono text-slate-700 bg-zinc-50 border border-slate-200 text-wrap overflow-clip shadow-md transition duration-200
            hover:cursor-pointer hover:shadow-2xl hover:bg-white hover:text-black">
            <button class="p-4 w-full text-left" on:click={()=>openTaskDetails(task.taskId)}>
              <h2 class="text-xl font-bold">{task.title}</h2>
              <!-- <p>Content: {task.content}</p> -->
              <p class=" font-medium">Prize: <span class="font-normal">{task.prize}</span></p>
              <p class=" font-medium">Status: <span class="font-normal">{task.status}</span></p>
              <p class=" font-medium">Date Created: <span class="font-normal">{new Date(task.dateTimeCreated * 1000).toLocaleString().split(',')[0]}</span></p>
            </button>
          </li>
        {/each}
      </ul>  
    </div>
  </SectionWrapper>

{#if showLoadingModal}
  <LoadingModal bind:showLoadingModal bind:transactionDone/>
{/if}

{#if showTaskDetailsModal}
  <Modal bind:showModal={showTaskDetailsModal}>
    <div class="p-6">
      <h2 class="text-3xl text-center font-bold mb-4">{taskDetails.title}</h2>
      <p class="mb-2 font-medium text-lg">Task Id: <span class="font-normal text-base">{taskDetails.taskId}</span></p>
      <p class="mb-2 font-medium text-lg">Asker: <span class="font-normal text-base">{taskDetails.asker}</span></p>
      <p class="mb-2 font-medium text-lg">Doer: <span class="font-normal text-base">{taskDetails.doer}</span></p>
      <p class="mb-2 font-medium text-lg">Content: <span class="font-normal text-base">{taskDetails.content}</span></p>
      <p class="mb-2 font-medium text-lg">Prize: <span class="font-normal text-base">{taskDetails.prize}</span></p>
      <p class="mb-2 font-medium text-lg">Status: <span class="font-normal text-base">{taskDetails.status}</span></p>
      <p class="mb-2 font-medium text-lg">Date Created: <span class="font-normal text-base">{new Date(taskDetails.dateTimeCreated * 1000).toLocaleString().split(',')[0]}</span></p>
      <p class="mb-2 font-medium text-lg">Time Limit: <span class="font-normal text-base">{taskDetails.timeLimit}</span></p>
      <p class="mb-2 font-medium text-lg">Video Link: <span class="font-normal text-base">{taskDetails.videoLink}</span></p>
      {#if taskDetails.statusVal == 0}
      <div class="mt-4">
        <button on:click={() => console.log('Edit task')} class="btn p-2 text-md font-bold text-white bg-indigo-700 hover:bg-indigo-700">Edit</button>
        <button on:click={() => console.log('Delete task')} class="btn p-2 text-md font-bold text-white bg-rose-700 hover:bg-red-700">Delete</button>
      </div>
      {/if}
  </div>
  </Modal>
{/if}

{#if showTaskCreateModal}
  <Modal bind:showModal={showTaskCreateModal}>
    <div class="w-[25rem] p-4 mx-auto bg-white rounded-md">
      <h2 class="text-lg font-bold mb-4">Create TASK</h2>
      <form>
        <div class="flex flex-col mb-4">
          <label for="title" class="text-sm font-medium text-gray-700">Title</label>
          <input bind:value={newTaskTitle} type="text" id="title" 
          class="w-full p-2 text-sm text-gray-700 border border-gray-300 rounded-md focus:outline-none focus:ring-indigo-500">
        </div>
        <div class="flex flex-col mb-4">
          <label for="content" class="text-sm font-medium text-gray-700">Content</label>
          <textarea bind:value={newTaskContent} id="content" class="w-full p-2 text-sm text-gray-700 border border-gray-300 rounded-md focus:outline-none focus:ring-indigo-500"></textarea>
        </div>
        <div class="flex flex-col mb-4">
          <label for="prize" class="text-sm font-medium text-gray-700">Prize</label>
          <input bind:value={newTaskPrize} type="number" id="prize" class="w-full p-2 text-sm text-gray-700 border border-gray-300 rounded-md focus:outline-none focus:ring-indigo-500">
        </div>
        <div class="flex flex-col mb-4">
          <label for="timeLimit" class="text-sm font-medium text-gray-700">Time Limit</label>
          <input bind:value={newTaskTimeLimit} type="number" id="timeLimit" class="w-full p-2 text-sm text-gray-700 border border-gray-300 rounded-md focus:outline-none focus:ring-indigo-500">
        </div>
      </form>
      <div class="flex justify-end mt-4">
        <button on:click={() => (showTaskCreateModal=false)} class="bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded-md">Cancel</button>
        <button on:click={createTask} class="bg-indigo-500 hover:bg-indigo-700 text-white font-bold py-2 px-4 rounded-md ml-2">Create</button>
      </div>
    </div>
  </Modal>
{/if}

</main>