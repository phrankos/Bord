<script lang="ts">    
    import { goto } from "$app/navigation";

    function chooseRole(role:string) {
        localStorage.setItem("role", role);
        switch (role) {
            case "ASKER":
                goto("/asker", {});
                break;
            case "DOER":
                goto("/doer", {});
                break;
            case "JUDGE":
                goto("/judge", {});
                break;
        
            default:
                break;
        }
    }
</script>

<title>Select Role</title>
<main class="flex flex-col md:flex-row min-h-screen text-7xl font-bold divide-x-4 divide-gray-200">
    <button on:click={() => chooseRole("ASKER")} class="group px-4  text-gray-500 hover:text-black md:w-1/3 flex flex-col items-center justify-center transition-width duration-200 hover:text-8xl hover:w-5/12">
        <i class="group-hover:text-indigo-700 text-white fa-solid fa-person-chalkboard duration-200"/>
        ASKER
        <p class="opacity-0 group-hover:opacity-100 text-lg mt-4 text-center transition duration-200">
            Craft thrilling challenges, offer rewards, and spark excitement!
        </p>
    </button>
    <button on:click={() => chooseRole("DOER")} class="group px-4 text-gray-500 hover:text-black  md:w-1/3 flex flex-col items-center justify-center transition-width duration-200 hover:text-8xl hover:w-5/12">
        <i class="group-hover:text-indigo-700 text-white fa-solid fa-person-running duration-200"/>
        DOER
        <p class="opacity-0 group-hover:opacity-100 text-lg mt-4 text-center transition duration-200">
            Embrace adventure, conquer challenges, and earn rewards!
        </p>
    </button>
    <button on:click={() => chooseRole("JUDGE")} class="group px-4 text-gray-500 hover:text-black md:w-1/3 flex flex-col items-center justify-center transition-width duration-200 hover:text-8xl hover:w-5/12">
        <i class="group-hover:text-indigo-700 text-white fa-solid fa-users-line duration-200"/>
        JUDGE
        <p class="opacity-0 group-hover:opacity-100 text-lg mt-4 text-center transition duration-200">
            Crown champions, shape the future, and enjoy the fun!
        </p>
    </button>
</main>