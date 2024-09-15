<script lang="ts">
  import Router from "svelte-spa-router";
  import { onMount } from "svelte";
  import { store } from "./store";
  

  // import UserChatsOverview from "./pages/UserChatsOverview.svelte";
  import UserSettings from "./pages/UserSettings.svelte";
  import Login from "./pages/Login.svelte";
  import Signup from "./pages/SignUp.svelte";
  import About from "./pages/About.svelte";
  import Brand from "./pages/Brand.svelte";
  import NotFound from "./pages/NotFound.svelte";
  import LandingPage from "./pages/LandingPage.svelte";
  import ExperiencesSelection from "./pages/ExperiencesSelection.svelte";
  import ExperiencesCreation from "./pages/ExperiencesCreation.svelte";

  import { syncLocalChanges } from "./helpers/localStorage";
    import SignUp from "./pages/SignUp.svelte";

  const routes = {
    
    "/": LandingPage,
    //"/mychats": UserChatsOverview, TODO
    "/settings": UserSettings,
    "/login": Login,
    "/about": About,
    "/brand": Brand,
    "/signup": SignUp,
    "/experiences": ExperiencesSelection, 
    "/experiences/create": ExperiencesCreation,
    // Catch-all (this is optional, but if present it must be the last)
    "*": NotFound,
  };

  onMount(async () => {
    // Check login state
    await store.checkExistingLoginAndConnect();
    if ($store.isAuthed) {
      syncLocalChanges(); // Sync any local changes (from offline usage), only works if back online
    };
  });
</script>

<div class="App">
  <Router {routes} />
</div>
