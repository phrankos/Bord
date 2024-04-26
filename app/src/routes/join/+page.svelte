<script lang="ts">
  import { ethers } from "ethers";
  import type { BrowserProvider } from "ethers";
  import { onMount } from "svelte";
  import { goto } from "$app/navigation";

  let provider: BrowserProvider;
  let visibility: String = "invisible";
  let visibility1: String = "invisible";

  onMount(() => {
    // connectWallet();
    isConnected();
  });

  async function isConnected() {
    const { ethereum } = window as any;
    const accounts = await ethereum.request({ method: "eth_accounts" });
    if (accounts.length) {
      console.log(`You're connected to: ${accounts[0]}`);
      goto("/roles", {});
    } else {
      console.log("Metamask is not connected");
      visibility1 = "visible";
    }
  }

  const connectWallet = async () => {
    const { ethereum } = window as any;
    provider = new ethers.BrowserProvider(ethereum);

    const accounts = await ethereum.request({ method: "eth_accounts" });
    if (accounts.length) {
      console.log(`You're connected to: ${accounts[0]}`);
    } else {
      console.log("Metamask is not connected");
    }

    try {
      const signer = await provider.getSigner();
      const address = signer.address;
      console.log(address);
      isConnected();
    } catch (error) {
      console.error("Error:", error);
      visibility = "visibile";
    }
  };
</script>

<div
  class="{visibility1} min-h-screen flex flex-col items-center justify-center bg-gray-100 saira"
>
  <div class="bg-white p-8 rounded shadow-md max-w-md w-full">
    <h2 class="text-2xl mb-4 text-center font-bold">
      Connect Your Wallet to Join
    </h2>
    <h1 class="text-9xl font-bold text-indigo-700 text-center">BORD</h1>
    <p class="text-gray-600 text-center mb-8">
      To become an <i class="fa-solid fa-person-chalkboard" /> ASKER,
      <i class="fa-solid fa-person-running" /> DOER, or one of the <br />
      <i class="fa-solid fa-users-line" /> JUDGES, connect your wallet provider.
    </p>
    <div class="flex justify-center">
      <button
        class="bg-blue-500 hover:bg-blue-600 text-white font-semibold py-2 px-4 rounded"
        on:click={connectWallet}>Connect Wallet</button
      >
    </div>
  </div>
  <div
    class="{visibility} my-5 bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative"
    role="alert"
  >
    <strong class="font-bold">Error:</strong>
    <span class="block sm:inline"
      >Something went wrong. Please try again later.</span
    >
  </div>
</div>
