<script>
    let taskId = '';
    let task = {};
  
    async function getTask() {
      // Call the getTask function from the contract
      // and retrieve the task details
    }
  
    onMount(() => {
      taskId = window.location.pathname.split('/').pop();
      getTask();
    });
  </script>
  
  <div class="max-w-md mx-auto p-4 pt-6 md:p-6 lg:p-12">
    <h1 class="text-3xl font-bold mb-4">{task.title}</h1>
    <p>{task.content}</p>
    <p>Price: {task.price}</p>
    <p>Time Limit: {task.timeLimit}</p>
    <p>Video Link: {task.videoLink}</p>
    <p>Created By: {task.asker}</p>
    <p>Created At: {new Date(task.dateTimeCreated * 1000).toLocaleString()}</p>
    {#if task.doer}
      <p>Assigned To: {task.doer}</p>
    {/if}
    {#if task.status === 'completed'}
      <p>Status: Completed</p>
    {:elseif task.status === 'ongoing'}
      <p>Status: Ongoing</p>
    {:else}
      <p>Status: Pending</p>
    {/if}
    <button on:click={() => console.log('Edit task')} class="inline-flex justify-center rounded-md border border-transparent bg-indigo-600 py-2 px-4 text-sm font-medium text-white shadow-sm hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2">Edit</button>
    <button on:click={() => console.log('Delete task')} class="inline-flex justify-center rounded-md border border-transparent bg-red-600 py-2 px-4 text-sm font-medium text-white shadow-sm hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-offset-2">Delete</button>
  </div>