<script lang="ts">
    import { createEventDispatcher } from 'svelte';
  
    export let isOpen = false;
    export let username = '';
  
    const dispatch = createEventDispatcher();
  
    function closeModal() {
      dispatch('close');
    }
  
    function submitUsername() {
      dispatch('submit', { username });
      closeModal();
    }
  </script>
  
  {#if isOpen}
    <div class="modal-overlay" on:click={closeModal}>
      <div class="modal-container" on:click|stopPropagation>
        <div class="modal-header">
          <h2>Enter Your Username</h2>
          <button class="close-button" on:click={closeModal}>×</button>
        </div>
        <div class="modal-body">
          <input
            type="text"
            placeholder="Username"
            bind:value={username}
            class="input-field"
          />
        </div>
        <div class="modal-footer">
          <button class="submit-button" on:click={submitUsername}>Submit</button>
        </div>
      </div>
    </div>
  {/if}
  
  <style>
    .modal-overlay {
      position: fixed;
      top: 0;
      left: 0;
      width: 100vw;
      height: 100vh;
      background: rgba(0, 0, 0, 0.5);
      display: flex;
      justify-content: center;
      align-items: center;
      z-index: 1000;
    }
  
    .modal-container {
      background: white;
      padding: 20px;
      border-radius: 8px;
      width: 90%;
      max-width: 400px;
      position: relative;
    }
  
    .modal-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 10px;
    }
  
    .close-button {
      background: transparent;
      border: none;
      font-size: 1.5rem;
      cursor: pointer;
    }
  
    .modal-body {
      margin-bottom: 20px;
    }
  
    .input-field {
      width: 100%;
      padding: 8px;
      border: 1px solid #ccc;
      border-radius: 4px;
    }
  
    .modal-footer {
      display: flex;
      justify-content: flex-end;
    }
  
    .submit-button {
      padding: 8px 16px;
      background-color: #4CAF50;
      color: white;
      border: none;
      border-radius: 4px;
      cursor: pointer;
    }
  </style>
  