<script>
  import { push } from 'svelte-spa-router'; // Import push from svelte-spa-router
  import logo from '../assets/devinci.svg';
  import hero from '../assets/apple-touch-icon.png';

  let isMenuOpen = false;

  function toggleMenu() {
    isMenuOpen = !isMenuOpen;
  }

  // Function to navigate to the login page using push
  function navigateToLogin() {
    push('/login'); // Navigate to the /login page
  }

  function handleLoginClick() {
    // Placeholder for additional login handling if needed
    navigateToLogin();
  }
</script>

<header class="bg-gradient-to-r from-[#00b4d8] to-[#0f4c75] text-white py-4 px-6 flex flex-col md:flex-row items-center justify-between shadow-lg fixed top-0 w-full z-50">
  <div class="flex items-center space-x-4 w-full md:w-auto">
    <a href="/" class="flex items-center space-x-2">
      <img src={logo} alt="LLM Logo" class="w-12 h-12 sm:w-14 sm:h-14 rounded-full border-4 border-blue-200 transition-transform transform hover:scale-110 duration-300" />
      <h1 class="text-xl sm:text-2xl md:text-3xl font-bold">LLMVerse</h1>
    </a>
  </div>

  <nav class="hidden md:flex flex-grow justify-center space-x-6 mt-4 md:mt-0">
    {#each ['Overview', 'Features', 'Integrations', 'Contact'] as link}
      <a href="#{link.toLowerCase()}" class="text-white hover:text-blue-300 border-b-2 border-transparent hover:border-white px-4 py-2 transition-all duration-300">{link}</a>
    {/each}
  </nav>

  <div class="flex space-x-4 mt-4 md:mt-0">
    <button class="bg-[#023e8a] text-white px-4 py-2 rounded-full shadow-md hover:bg-[#0077b6] transition-all duration-300 transform hover:scale-105">Get Started 🚀</button>
    <button 
      on:click={handleLoginClick} 
      class="bg-transparent border border-blue-200 text-white px-4 py-2 rounded-full shadow-md hover:bg-blue-300 hover:text-[#023e8a] transition-all duration-300 transform hover:scale-105">
      Login
    </button>
  </div>
</header>

<section class="hero min-h-screen flex items-center justify-center bg-[#0077b6] text-white">
  <div class="container mx-auto flex flex-col md:flex-row items-center justify-between p-8">
    <div class="text-content md:w-1/2 text-center md:text-left">
      <h1 class="text-4xl md:text-5xl font-bold mb-4 leading-tight">
        Empower Your Business with <span class="text-[#00C4CC]">LLMVerse</span>
      </h1>
      <p class="text-lg md:text-xl mb-6">
        Unlock the potential of large language models for enhanced customer engagement, automation, and data insights.
      </p>
      <div class="flex justify-center md:justify-start space-x-4">
        <button 
          class="bg-[#00C4CC] text-white px-11 py-2 text-lg font-semibold shadow-lg hover:bg-white hover:text-[#0077b6] transition-all duration-300 ease-in-out transform hover:scale-105">
          Sign Up
        </button>
        <button 
          on:click={handleLoginClick} 
          class="bg-transparent border-2 border-white text-white px-11 py-2 text-lg font-semibold shadow-lg hover:bg-white hover:text-[#0077b6] transition-all duration-300 ease-in-out transform hover:scale-105">
          Login
        </button>
      </div>
    </div>

    <div class="image-content md:w-1/2 mt-8 md:mt-0">
      <img src={hero} alt="LLM Hero Graphic" class="w-full h-auto rounded-lg" />
    </div>
  </div>
</section>

<footer class="bg-[#023e8a] text-white py-6 text-center">
  <div class="container mx-auto">
    <p class="mb-4">&copy; 2024 LLMVerse. All rights reserved.</p>
    <div class="space-x-4 mb-4">
      <a href="/privacy" class="hover:text-blue-300">Privacy Policy</a>
      <a href="/terms" class="hover:text-blue-300">Terms of Service</a>
      <a href="#contact" class="hover:text-blue-300">Contact</a>
    </div>
    <div class="space-x-6">
      <a href="#" class="hover:text-blue-300"><i class="fab fa-facebook"></i></a>
      <a href="#" class="hover:text-blue-300"><i class="fab fa-twitter"></i></a>
      <a href="#" class="hover:text-blue-300"><i class="fab fa-linkedin"></i></a>
    </div>
  </div>
</footer>
