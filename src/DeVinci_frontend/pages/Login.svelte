<script lang="ts">
    import { onMount } from 'svelte';
    import UsernameModal from '../components/UserNameMidel.svelte'
  
    let showModal = true;
    let username = '';
  
    function handleModalClose() {
      showModal = false;
    }
  
    function handleUsernameSubmit(event) {
      username = event.detail.username;
      console.log('Username submitted:', username);
      showModal = false;
    }
  </script>
  
  <!-- <UsernameModal
    {isOpen}
    bind:username
    on:close={handleModalClose}
    on:submit={handleUsernameSubmit}
  />
   -->
  <div class="main-content">
    <h1>Welcome, {username ? username : 'Guest'}</h1>
    <!-- Your main page content goes here -->
  </div>
  
  <style>
    .main-content {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      height: 100vh;
      text-align: center;
    }
  </style>
  