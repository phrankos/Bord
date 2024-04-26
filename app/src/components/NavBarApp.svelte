<script>
    import { onMount } from "svelte";

    let role;

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
</script>

<div class="fixed top-0 left-0 w-full z-50 bg-white shadow-md">
    <div class="container mx-auto">
        <div class="flex justify-between items-center p-4">
            <!-- Logo or Brand -->
            <a href="/" class="font-bold text-4xl text-indigo-700 hover:tracking-tighter hover:rotate-[-5deg] transition-all">BORD</a>

            <div class="flex space-x-4">
                <nav class="hidden md:flex items-center gap-4 lg:gap-6">
                    <a href="/roles" class="text-xl cursor-pointer">
                        <button 
                        on:mouseenter={roleHover}
                        on:mouseleave={roleLeave}
                        class="font-mono font-bold text-xl rounded-md border border-indigo-500 py-2 px-4
                        transition duration-200 hover:text-white hover:bg-indigo-700 "
                            >{role}</button
                        >
                    </a>
                </nav>
            </div>
        </div>
    </div>
</div>