<script lang="ts">
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
    }
  });
</script>

<div class="App">
  <Router {routes} />
</div>
