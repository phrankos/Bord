<script lang="ts">
    import { Contract, JsonRpcSigner, ethers } from "ethers"; // Actual BlockChain
    import { contract, token, tokenName} from "../store/index";
    import dappABI from "../contracts/Bord.sol/Bord.json";
    import tokenABI from "../contracts/Bord.sol/BordToken.json";
    import { onMount } from "svelte";
    import Modal from "./Modal.svelte";

    export let showModal: boolean;
    export let showLoadingModal: boolean;
    export let transactionStatus: number;
    export let userTokenAmountDisplay: any;
    let dialog: HTMLDialogElement;

    onMount(() => {
        getUserTokenAmount();
        getTokenBuyPrice();
        getTokenSellPrice();
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

    let userTokenAmount: number = 0;
    const getUserTokenAmount = async () => {
        const BordToken = await initializeTokenContract();
        const signer = await getSigner();
        userTokenAmount = await BordToken.balanceOf(signer.address);
        userTokenAmountDisplay = Number(
            BigInt(userTokenAmount) /
                BigInt(10n ** (await BordToken.decimals()))
        );
        console.log(userTokenAmountDisplay);
    };

    let tokenBuyPrice: number;
    let tokenBuyPriceDisplay: number = 0;
    const getTokenBuyPrice = async () => {
        const BordToken = await initializeTokenContract();
        const signer = await getSigner();
        tokenBuyPrice = await BordToken.tokenBuyPrice();
        tokenBuyPriceDisplay =
            Number(BigInt(tokenBuyPrice) / 10n ** 9n) / 10 ** 9;
    };
    let tokenSellPrice: number;
    let tokenSellPriceDisplay: number = 0;
    const getTokenSellPrice = async () => {
        const BordToken = await initializeTokenContract();
        const signer = await getSigner();
        tokenSellPrice = Number(await BordToken.tokenSellPrice());
        tokenSellPriceDisplay =
            Number(BigInt(tokenSellPrice) / 10n ** 9n) / 10 ** 9;
    };

    const buyTokens = async () => {
        console.log(`Buying ${tokenAmount} ${$tokenName} tokens...`);
        
        transactionStatus = 1;
        showLoadingModal = true;

        const BordToken = await initializeTokenContract();
        const price: bigint = BigInt(tokenBuyPrice) * BigInt(tokenAmount);
        try {
            const tx = await BordToken.buyTokens(tokenAmount, { value: price });
            waitTransaction(tx);
        } catch (error) {
            transactionStatus = 2;
            setTimeout(() => {
                showLoadingModal = false;
                getUserTokenAmount();
            }, 500);
        }
    };

    const sellTokens = async () => {
        console.log(`Selling ${tokenAmount} ${$tokenName} tokens...`);
        
        transactionStatus = 1;
        showLoadingModal = true;

        const BordToken = await initializeTokenContract();
        try {
            const tx = await BordToken.sellTokens(tokenAmount);
            waitTransaction(tx);
        } catch (error) {
            transactionStatus = 2;
            setTimeout(() => {
                showLoadingModal = false;
            }, 500);
        }
        
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
            }, 500);
          }
       });
    };

    let tokenAmount = 5;
    function handleTokenAmountChange(event: any) {
        tokenAmount = event.target.value;
    }

    let shopMode: boolean = false;
    function toggleShopMode(): void {
        // true:Buy | false:Sell
        shopMode = !shopMode;
        console.log(shopMode);
    }

    $: if (dialog && showModal) dialog.showModal();
    $: if (dialog && !showModal) dialog.close();
</script>

<!-- svelte-ignore a11y-click-events-have-key-events a11y-no-noninteractive-element-interactions -->
<!-- <dialog class=" rounded-md backdrop:bg-gray-800 backdrop:bg-opacity-50 bg-zinc-50 justify-items-center"
        bind:this={dialog}
        on:close={() => (showModal = false)}
        on:click|self={() => dialog.close()}> -->
<Modal bind:showModal moreClasses="bg-zinc-100">
    <div class="p-6 pb-2 w-[20rem] select-none">
        <h2 class="text-3xl text-center font-bold mb-4">
            <span class=" text-indigo-700">{$tokenName}</span> Token Shop
        </h2>
        <p class="text-lg font-normal text-center">
            Current Tokens: <span class="font-medium"
                >{userTokenAmountDisplay}
            </span><span class="font-medium text-indigo-800">BRD</span>
        </p>
        <label
            class="flex items-center cursor-pointer mt-4 shadow-lg"
            for="shopModeToggle"
        >
            <div class="relative w-full group">
                <input
                    type="checkbox"
                    id="shopModeToggle"
                    class="sr-only"
                    bind:checked={shopMode}
                    on:click={toggleShopMode}
                />
                <div
                    class={"w-full h-10 bg-gray-400 rounded-md shadow-inner transition duration-200"}
                >
                    <div
                        class={`absolute w-1/2 h-full flex justify-center items-center transition duration-400
                        ${shopMode ? "text-gray-500 " : "text-gray-400"} text-xl font-medium`}
                    >
                        Buying
                    </div>
                    <div
                        class={`absolute w-1/2 h-full flex justify-center items-center transition duration-400
                        ${shopMode ? "text-gray-400" : "text-gray-500 "} text-xl font-medium right-0`}
                    >
                        Selling
                    </div>
                </div>
                <div
                    class={`absolute w-1/2 h-10 rounded-md shadow inset-y-0 left-0 transition duration-200 ${
                        shopMode
                            ? "transform translate-x-full bg-emerald-500  group-hover:bg-cyan-700 group-hover:shadow-cyan-600 group-hover:shadow-md group-hover:translate-x-[calc(100%-0.5rem)] shadow-lg shadow-emerald-600"
                            : "bg-indigo-700 group-hover:bg-cyan-700 group-hover:shadow-cyan-600 group-hover:shadow-md group-hover:translate-x-2 shadow-lg shadow-indigo-400"
                    }`}
                >
                    <div
                        class="h-full flex justify-center items-center text-white text-xl font-medium"
                    >
                        {shopMode ? "Selling" : "Buying"}
                    </div>
                </div>
            </div>
        </label>
        <div class="mt-4 flex flex-col md:flex-row justify-between gap-4">
            <div class="w-full">
                <label
                    class="block text-gray-700 text-sm font-bold mb-2"
                    for={shopMode ? "sellAmount" : "buyAmount"}
                >
                    {shopMode ? "Sell Amount" : "Buy Amount"}
                </label>
                <select
                    class="shadow-md appearance-none border rounded w-full py-2 px-3 bg-white text-gray-700 leading-tight hover:cursor-pointer focus:outline-none focus:shadow-outline"
                    id={shopMode ? "sellAmount" : "buyAmount"}
                    on:change={handleTokenAmountChange}
                >
                    {#each [5, 10, 50, 100] as amount}
                        <option value={amount}>{amount} {$tokenName}</option>
                    {/each}
                </select>
                <p class="mt-4 text-sm">
                    Price per Token: <span
                        class="float-right font-medium font-mono"
                    >
                        {shopMode
                            ? tokenSellPriceDisplay.toFixed(6)
                            : tokenBuyPriceDisplay.toFixed(6)} ETH
                    </span>
                </p>
                <p class="mt-1 text-sm">
                    Total: <span class="float-right font-medium font-mono">
                        {(
                            tokenAmount *
                            (shopMode
                                ? tokenSellPriceDisplay
                                : tokenBuyPriceDisplay)
                        ).toFixed(6)} ETH
                    </span>
                </p>
                <button
                    on:click={shopMode ? sellTokens : buyTokens}
                    class={`w-full rounded-md btn mt-4 p-2 text-md font-bold border 
                ${shopMode ? "border-emerald-600 text-emerald-600" : "border-indigo-700 text-indigo-700"} bg-white duration-150 ${shopMode ? "hover:bg-emerald-600" : "hover:bg-indigo-700"} hover:text-white`}
                >
                    {shopMode ? "Sell" : "Buy"}
                </button>
            </div>
        </div>
    </div>
</Modal>
