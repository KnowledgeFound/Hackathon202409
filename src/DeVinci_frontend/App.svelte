<script lang="ts">
<<<<<<< HEAD
  import Router from "svelte-spa-router";
  import { onMount } from "svelte";
  import { store } from "./store";

  // Your route components
  import UserSettings from "./pages/UserSettings.svelte";
  import Login from "./pages/Login.svelte";
  import SignUp from "./pages/SignUp.svelte";
  import About from "./pages/About.svelte";
  import Brand from "./pages/Brand.svelte";
  import NotFound from "./pages/NotFound.svelte";
  import LandingPage from "./pages/LandingPage.svelte";
  import ExperiencesSelection from "./pages/ExperiencesSelection.svelte";
  import ExperiencesCreation from "./pages/ExperiencesCreation.svelte";

  const routes = {
    "/": LandingPage,
    "/settings": UserSettings,
    "/login": Login,
    "/about": About,
    "/brand": Brand,
    "/signup": SignUp,
    "/experiences": ExperiencesSelection,
    "/experiences/create": ExperiencesCreation,
    "*": NotFound,
  };

  onMount(async () => {
    // Check login state or other setup
    await store.checkExistingLoginAndConnect();
    if ($store.isAuthed) {
      // Handle authentication status
=======
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
>>>>>>> bea6a3f (Resolved merge conflicts)
    }
  });
</script>

<div class="App">
  <Router {routes}>
    <Route path="/" component={LandingPage} />
    <Route path="/login" component={Login} />
    <Route path="/signup" component={SignUp} />
    <Route path="/dashboard" component={Dashboard} />
    <!-- Uncomment or add additional routes as needed -->
    <!-- <Route path="/about" component={About} />
    <Route path="/brand" component={Brand} />
    <Route path="*" component={NotFound} /> -->
  </Router>
</div>
