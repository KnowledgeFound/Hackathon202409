<script lang="ts">
  import { onMount } from 'svelte';
  import { deviceType, supportsWebGpu } from "../store";

  import Navigation from "../components/Navigation.svelte";
  import ChatInterface from "../components/ChatInterface.svelte";
  import UnsupportedBrowserBanner from "../components/UnsupportedBrowserBanner.svelte";
  import UnsupportedDeviceBanner from "../components/UnsupportedDeviceBanner.svelte";

  function stopPropagation(event) {
    event.stopPropagation();
  };
</script>

{#if !(deviceType === 'desktop' || deviceType === 'Android')}
  <UnsupportedDeviceBanner />
{:else if !supportsWebGpu}
  <UnsupportedBrowserBanner />
{:else}
  <div class="flex flex-col h-screen w-screen">
    <main class="main flex flex-col flex-grow transition-all duration-150 ease-in">
      <header class="header bg-white shadow py-2 px-4 flex-shrink-0">
        <div class="header-content flex items-center flex-row">
          <!-- Sidebar Toggle Button for Small Devices -->
          <button id="sidebarToggle" data-drawer-target="chat" data-drawer-toggle="chat" aria-controls="chat" type="button" class="inline-flex items-center p-2 mt-2 ms-3 text-sm text-gray-500 rounded-lg md:hidden hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-gray-200 dark:text-gray-400 dark:hover:bg-gray-700 dark:focus:ring-gray-600">
            <span class="sr-only">Open sidebar</span>
            <svg class="w-6 h-6" aria-hidden="true" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
              <path clip-rule="evenodd" fill-rule="evenodd" d="M2 4.75A.75.75 0 012.75 4h14.5a.75.75 0 010 1.5H2.75A.75.75 0 012 4.75zm0 10.5a.75.75 0 01.75-.75h7.5a.75.75 0 010 1.5h-7.5a.75.75 0 01-.75-.75zM2 10a.75.75 0 01.75-.75h14.5a.75.75 0 010 1.5H2.75A.75.75 0 012 10z"></path>
            </svg>
          </button>
          <!-- Optional Navigation Component -->
          <!-- <div class="flex ml-auto">
            <Navigation />
          </div> -->
        </div>
      </header>
      <div class="flex-grow overflow-auto">
        <ChatInterface />
      </div>
    </main>
  </div>
{/if}

<style global>
  .main {
    display: flex;
    flex-direction: column;
    height: 100%;
  }

  .footer {
    background: rgba(255, 255, 255, 1);
    padding-top: 10px;
    padding-bottom: 10px;
  }

  .header {
    flex-shrink: 0;
  }
</style>
