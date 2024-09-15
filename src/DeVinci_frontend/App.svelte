<script lang="ts">
  import { Router, Route } from 'svelte-spa-router';
  import { onMount } from 'svelte';
  import { store } from './store'; // Ensure your store is correctly set up

  import Login from './pages/Login.svelte';
  import SignUp from './pages/SignUp.svelte';
  import LandingPage from './pages/LandingPage.svelte';
  import Dashboard from './pages/dashboard.svelte'; // Ensure this path and import are correct

  // Import any additional pages/components if necessary
  // import Brand from './pages/Brand.svelte'; // Ensure this import is correct
  // import About from './pages/About.svelte'; // Ensure this import is correct

  import { syncLocalChanges } from './helpers/localStorage';

  const routes = {
    '/': LandingPage,
    '/login': Login,
    '/signup': SignUp,
    '/dashboard': Dashboard,
    // Define additional routes if necessary
    // '/about': About,
    // '/brand': Brand,
  };

  onMount(async () => {
    await store.checkExistingLoginAndConnect();
    if ($store.isAuthed) {
      syncLocalChanges(); // Sync any local changes
    }
  });
</script>

<div class="App">
  <Router {routes} />
</div>