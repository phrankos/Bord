<script>
    import { onMount } from "svelte";
    import BuyTokensModal from "../../components/BuyTokensModal.svelte";

    let role = "-";
    let showTokenShopModal = false;

    onMount(() => {
        isConnected();
        role = localStorage.getItem('role');
    });

    function roleHover() {
        role = "ROLES"; 
    }
    function roleLeave() {
        role = localStorage.getItem('role');
    }

    async function isConnected() {
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

<BuyTokensModal bind:showModal={showTokenShopModal} />

<div class="fixed top-0 left-0 w-full z-50 bg-white shadow-md">
    <div class="container mx-auto">
        <div class="flex justify-between items-center p-4">
            <!-- Logo or Brand -->
            <a href="/" class="font-bold text-4xl text-indigo-700 hover:tracking-tighter hover:rotate-[-5deg] transition-all">BORD</a>

            <div class="flex space-x-4">
                <nav class="hidden md:flex items-center gap-4 lg:gap-6">
                    <!-- Use the imported showTaskCreateModal variable -->
                    <a href="#" class="text-lg font-bold w-28 transition duration-200 hover:text-indigo-700" on:click={toggleTokenShop}>Token Shop</a>
                    <a href="/roles" class="text-xl cursor-pointer">
                        <button 
                        on:mouseenter={roleHover}
                        on:mouseleave={roleLeave}
                        class="w-28 font-bold text-xl rounded-md border border-indigo-500 py-2 px-4
                        transition duration-200 hover:text-white hover:bg-indigo-700 hover:shadow-lg hover:shadow-indigo-300"
                            >{role}</button
                        >
                    </a>
                </nav>
            </div>
        </div>
    </div>
</div>