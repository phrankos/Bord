<script lang="ts">
    import { Contract, JsonRpcSigner, ethers } from "ethers"; // Actual BlockChain
    import { contract, token, tokenName} from "../store/index";
    import dappABI from "../contracts/Bord.sol/Bord.json";
    import tokenABI from "../contracts/Bord.sol/BordToken.json";
    import { onMount } from "svelte";
    import BuyTokensModal from "../components/BuyTokensModal.svelte";

    let role: any = "-";
    let showTokenShopModal = false;
    export let showLoadingModal: boolean;
    export let transactionStatus: number;
    export let userTokenAmountDisplay:any;

    onMount(() => {
        isConnected();
        getUserTokenAmount();
        role = localStorage.getItem('role');
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
    // let userTokenAmountDisplay: number = 0;
    const getUserTokenAmount = async () => {
        const BordToken = await initializeTokenContract();
        const signer = await getSigner();
        userTokenAmount = await BordToken.balanceOf(signer.address);
        userTokenAmountDisplay = Number(
            BigInt(userTokenAmount) /
                BigInt(10n ** (await BordToken.decimals()))
        );
    };

    function roleHover() {
        role = "ROLES"; 
    }
    function roleLeave() {
        role = localStorage.getItem('role');
    }

    let shopHover:boolean = false;
    function tokenHover() {
        shopHover=true; 
    }
    function tokenLeave() {
        shopHover=false; 
    }

    async function isConnected() {
        const { ethereum } = window as any;
        const accounts = await ethereum.request({ method: "eth_accounts" });
        if (accounts.length) {
            console.log(`You're connected to: ${accounts[0]}`);
        } else {
            console.log("Metamask is not connected");
        }
    }

    function toggleTokenShop() {
        showTokenShopModal = !showTokenShopModal;
    }

</script>

<BuyTokensModal bind:showModal={showTokenShopModal} bind:showLoadingModal bind:transactionStatus={transactionStatus} bind:userTokenAmountDisplay/>

<div class="fixed top-0 left-0 w-full z-50 bg-white shadow-md">
    <div class="container mx-auto">
        <div class="flex justify-between items-center p-4">
            <!-- Logo or Brand -->
            <a href="/" class="font-bold text-4xl text-indigo-700 hover:tracking-tighter hover:rotate-[-5deg] transition-all">BORD</a>

            <div class="flex space-x-4">
                <nav class="hidden md:flex items-center gap-4 lg:gap-6">
                    <a href="" class="text-xl cursor-pointer">
                        <button 
                        on:mouseenter={tokenHover}
                        on:mouseleave={tokenLeave}
                        on:click={toggleTokenShop}
                        class="min-w-28 font-bold text-xl rounded-md border border-indigo-500 py-2 px-4
                        transition duration-200 hover:text-white hover:bg-indigo-700 hover:shadow-lg hover:shadow-indigo-300"
                            >{shopHover ? "Shop" : `${String(userTokenAmountDisplay)} `}{#if !shopHover}<span class=" text-indigo-700">{$tokenName}</span>{/if}</button
                        >
                    </a>
                    <a href="/roles" class="text-xl cursor-pointer">
                        <button 
                        on:mouseenter={roleHover}
                        on:mouseleave={roleLeave}
                        class="w-28 font-bold text-xl rounded-md border border-indigo-500 bg-indigo-700 text-white py-2 px-4
                        transition duration-200 hover:text-indigo-700 hover:bg-white hover:shadow-lg hover:shadow-indigo-300"
                            >{role}</button
                        >
                    </a>
                </nav>
            </div>
        </div>
    </div>
</div>