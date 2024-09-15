// Import necessary components
/* import Home from './pages/Home.svelte';
import Features from './pages/Features.svelte';
import Integrations from './pages/Integrations.svelte';
import Contact from './pages/Contact.svelte';
import Licensing from './pages/Licensing.svelte'; */
import dashboard from './pages/dashboard.svelte';

// Define a type for routes
type Routes = {
  [key: string]: typeof dashboard;
};

// Define routes and map them to components
const routes: Routes = {
  '/': dashboard,
  /* '/features': Features,
  '/integrations': Integrations,
  '/contact': Contact,
  '/licensing': Licensing, */
  /* '/dashboard': Dashboard, */
};

export default routes;
