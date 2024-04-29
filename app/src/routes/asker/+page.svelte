<script lang="ts">
  import NavBarApp from "../../components/NavBarApp.svelte";
  import SectionWrapper from "../../components/SectionWrapper.svelte";
  import { onMount } from 'svelte';
  
  let role;
  onMount(() => {
    role = sessionStorage.getItem('role');
  });

  import { ethers } from 'ethers';

  import { ABI } from "./abi";

  const { ethereum } = window as any;
  const provider = new ethers.BrowserProvider(ethereum);
  const contractAddress = '0x1234567890123456789012345678901234567890'; // replace with your contract address
  const socialMediaContract = new ethers.Contract(contractAddress, ABI, provider);

  let content = '';

  // async function createPost() {
  //   const signer = await provider.getSigner();
  //   await socialMediaContract.connect(signer).createPost(content);
  //   content = '';
  // }

  // async function getPosts() {
  //   const posts = await socialMediaContract.getPosts();
  //   console.log(posts);
  // }
</script>

<title>ASKER Dashboard</title>

<NavBarApp/>
<main class="flex flex-col">
    <div class="min-h-screen flex flex-col items-center justify-center bg-gray-100">
      <h1 class="text-9xl font-bold text-outline">ASKER</h1>
      <p class="text-2xl font-semibold">Dashboard</p>
    </div>
    <SectionWrapper id="test">
      <div class="flex h-screen items-center justify-center">
        <div class="w-full max-w-md space-y-8">
          <div class="text-center">
            <h2 class="text-3xl font-bold tracking-tight text-gray-900">Create a new post</h2>
          </div>
          <div class="rounded-md shadow-sm">
            <textarea id="content" name="content" rows="4" class="block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm" placeholder="Enter your post content" v-model="content"></textarea>
          </div>
          <div class="text-center">
            <button class="inline-flex justify-center rounded-md border border-transparent bg-indigo-600 py-2 px-4 text-sm font-medium text-white shadow-sm hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2">Create Post</button>
          </div>
          <div class="text-center">
            <button class="inline-flex justify-center rounded-md border border-transparent bg-indigo-600 py-2 px-4 text-sm font-medium text-white shadow-sm hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2">Get Posts</button>
          </div>
        </div>
      </div>
    </SectionWrapper>
</main>
