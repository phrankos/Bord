<script lang="ts">
  import NavBarApp from "../../components/NavBarApp.svelte";
  import { onMount } from 'svelte';
  
  let role;

  // Retrieve the count from sessionStorage on component mount
  onMount(() => {
    role = sessionStorage.getItem('role');
  });
</script>

<title>JUDGE Dashboard</title>
<NavBarApp/>

<main class="flex flex-col">
    <div class="min-h-screen flex flex-col items-center justify-center bg-gray-100 saira">
		<h1 class="text-9xl font-bold text-outline">JUDGE</h1>
		<p class="text-2xl font-semibold">Dashboard</p>
    </div>
</main>