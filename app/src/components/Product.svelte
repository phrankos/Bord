<script>
    // import ProductCard from "./ProductCard.svelte";
    import SectionWrapper from "./SectionWrapper.svelte";
</script>

<SectionWrapper id="product">
    <div
        class="flex flex-col gap-10 flex-1 items-center justify-center pt-5 mt:pb-9 pb-10 md:pb-14"
    >
        <div class="flex flex-col gap-2 max-w-[50em]">            
            <h3
                class="text-4xl sm:text-5xl md:text-6xl max-w-[1000px] mx-auto w-full font-semibold text-center"
            >
                How does <span class="text-1xl font-bold text-indigo-700">BORD</span> work?
            </h3>

            <div class="flex items-center pt-10 mt:pb-14 mb-4" >
                <div>
                  <h3 class="text-3xl font-semibold mb-2"><i class="fa-solid fa-person-chalkboard"></i> Askers</h3>
                  <p class="text-gray-700">Do you have an imaginative challenge in mind? Post a task along with the prize money you're willing to offer. Your creativity fuels the excitement on BORD!</p>
                </div>
              </div>
            
              <div class="flex items-center mb-4">
                <div>
                  <h3 class="text-3xl font-semibold mb-2"><i class="fa-solid fa-person-running"></i> Doers</h3>
                  <p class="text-gray-700">Ready to earn some cash by completing thrilling challenges? Browse through tasks posted by Askers and choose the ones that excite you. Your daring spirit brings tasks to life!</p>
                </div>
              </div>
            
              <div class="flex items-center mb-4">
                <div>
                  <h3 class="text-3xl font-semibold mb-2"><i class="fa-solid fa-video"></i> Film & Upload</h3>
                  <p class="text-gray-700">Once you've chosen a task, film yourself completing it and upload the video to BORD. Share your experiences and inspire others to join in the fun!</p>
                </div>
              </div>
            
              <div class="flex items-center mb-4">
                <div>
                  <h3 class="text-3xl font-semibold mb-2"><i class="fa-solid fa-users-line"></i> Judges</h3>
                  <p class="text-gray-700">A panel of Judges will review your performance based on the task given by the Asker. They'll vote on whether you successfully completed the task.</p>
                </div>
              </div>
            
              <div class="flex items-center mb-4">
                <div>
                  <h3 class="text-3xl font-semibold mb-2"><i class="fa-solid fa-hand-holding-dollar"></i> Prize Money</h3>
                  <p class="text-gray-700">If the Judges reach a consensus that you successfully completed the task, you'll be awarded the prize money set by the Asker. If not, a new voting session will begin. Your effort is rewarded!</p>
                </div>
              </div>

        </div>
    </div>
</SectionWrapper>