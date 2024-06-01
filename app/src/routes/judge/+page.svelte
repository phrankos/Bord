<script lang="ts">
  import { Contract, JsonRpcSigner, ethers } from "ethers"; // Actual BlockChain
  import { contract } from "../../store/index";
  import ABI from "../../contracts/Bord.sol/Bord.json";
  import { onMount } from "svelte";
  import { goto } from "$app/navigation";
  import AskerNavBar from "../../components/AskerDashboard/AskerNavBar.svelte";
  import SectionWrapper from "../../components/SectionWrapper.svelte";
  import Modal from "../../components/Modal.svelte";
  import LoadingModal from "../../components/LoadingModal.svelte";
  import TaskDetailsModal from "../../components/AskerDashboard/TaskDetailsModal.svelte";
  import JudgeNavBar from "../../components/JudgeDashboard/JudgeNavBar.svelte";
</script>

<title>JUDGE Dashboard</title>
<JudgeNavBar/>

<main class="flex flex-col">
  <SectionWrapper id="AskerDash">
      <div class="pt-10 pb-20">
          <h1 class="text-5xl font-bold mb-4">ASKER Dashboard</h1>
          <ul class="text-xl select-none flex text-center mt-8">
              {#each ["All", "Open", "Accepted", "Submitted", "Completed", "Deleted"] as status}
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
                              Prize: <span class="font-normal"
                                  >{task.prize}</span
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

  {#if showTaskDetailsModal}
      <TaskDetailsModal bind:showModal={showTaskDetailsModal} bind:taskDetails/>
  {/if}

  {#if showTaskCreateModal}
      <Modal bind:showModal={showTaskCreateModal}>
          <div class="w-[25rem] p-4 mx-auto bg-white rounded-md">
              <h2 class="text-lg font-bold mb-4">Create TASK</h2>
              <form>
                  <div class="flex flex-col mb-4">
                      <span class="text-sm font-medium text-gray-700"
                          >Title</span
                      >
                      <input
                          bind:value={newTaskTitle}
                          type="text"
                          id="title"
                          class="w-full p-2 text-sm text-gray-700 border border-gray-300 rounded-md focus:outline-none focus:ring-indigo-500"
                      />
                  </div>
                  <div class="flex flex-col mb-4">
                      <span class="text-sm font-medium text-gray-700"
                          >Content</span
                      >
                      <textarea
                          bind:value={newTaskContent}
                          id="content"
                          class="w-full p-2 text-sm text-gray-700 border border-gray-300 rounded-md focus:outline-none focus:ring-indigo-500"
                      ></textarea>
                  </div>
                  <div class="flex flex-col mb-4">
                      <span class="text-sm font-medium text-gray-700"
                          >Prize</span
                      >
                      <input
                          bind:value={newTaskPrize}
                          type="number"
                          min="1"
                          id="prize"
                          class="w-full p-2 text-sm text-gray-700 border border-gray-300 rounded-md focus:outline-none focus:ring-indigo-500"
                      />
                  </div>
                  <div class="flex flex-col mb-4">
                      <span class="text-sm font-medium text-gray-700"
                          >Time Limit</span
                      >
                      <div class="grid grid-cols-4 gap-2">
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
                              bind:value={newTaskTimeLimitDays}
                              type="number"
                              min="0"
                              class="p-2 text-sm text-gray-700 border border-gray-300 rounded-md focus:outline-none focus:ring-indigo-500"
                          />
                          <input
                              bind:value={newTaskTimeLimitHours}
                              type="number"
                              min="0"
                              class="p-2 text-sm text-gray-700 border border-gray-300 rounded-md focus:outline-none focus:ring-indigo-500"
                          />
                          <input
                              bind:value={newTaskTimeLimitMinutes}
                              type="number"
                              min="0"
                              class="p-2 text-sm text-gray-700 border border-gray-300 rounded-md focus:outline-none focus:ring-indigo-500"
                          />
                          <input
                              bind:value={newTaskTimeLimitSeconds}
                              type="number"
                              min="1"
                              class="p-2 text-sm text-gray-700 border border-gray-300 rounded-md focus:outline-none focus:ring-indigo-500"
                          />
                      </div>
                  </div>
              </form>
              <div class="flex justify-end mt-4">
                  <button
                      on:click={() => (showTaskCreateModal = false)}
                      class="bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded-md"
                      >Cancel</button
                  >
                  <button
                      on:click={createTask}
                      class="bg-indigo-500 hover:bg-indigo-700 text-white font-bold py-2 px-4 rounded-md ml-2"
                      >Create</button
                  >
              </div>
          </div>
      </Modal>
  {/if}
</main>
