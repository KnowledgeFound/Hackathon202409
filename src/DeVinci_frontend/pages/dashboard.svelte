<script>
   // import logo from '../assets/';
   // import hero from '../routes/assets/download2.png';
    //import '../index.scss';
   // import { authenticateWithInternetIdentity } from '../routes/services/auth';
  
    let isMenuOpen = false;
  
    function toggleMenu() {
      isMenuOpen = !isMenuOpen;
    }
  
    function handleSignUpClick() {
      goto('/signup'); // Navigate to the signup page
    }
  
   /*  function handleLoginClick() {
      authenticateWithInternetIdentity().catch((error) => {
        console.error("Authentication failed:", error);
      });
    } */
  
    const items = [
      {
        id: 'item1',
        title: 'Exclusive Artwork',
        description: "An exclusive piece of digital artwork, available for licensing and purchase. Perfect for enhancing your brand's visual identity.",
        imgSrc: logo
      },
      {
        id: 'item2',
        title: 'Premium Software',
        description: "Cutting-edge software solution designed for creative professionals. Explore licensing options and get started with a demo.",
        imgSrc: logo
      },
      {
        id: 'item3',
        title: 'Innovative Patents',
        description: "Explore groundbreaking patents and technologies. Perfect for licensing and collaboration opportunities.",
        imgSrc: logo
      }
    ];
  </script>
  
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
  
  <!-- Navbar -->
  <header class="bg-[#0f535c] text-white py-4 px-6 flex flex-col md:flex-row items-center justify-between shadow-lg fixed top-0 w-full z-50">
    <!-- Logo and Title -->
    <div class="flex items-center space-x-4 w-full md:w-auto">
      <a href="/" class="flex items-center space-x-2">
        <img src={logo} alt="Icon" class="w-12 h-12 sm:w-14 sm:h-14 rounded-full border-4 border-blue-200 transition-transform transform hover:scale-110 duration-300" />
        <h1 class="text-xl sm:text-2xl md:text-3xl font-bold">ChainGuard</h1>
      </a>
    </div>
  
    <!-- Center Links (Desktop) -->
    <nav class="hidden md:flex flex-grow justify-center space-x-6 mt-4 md:mt-0">
      {#each ['Features', 'Marketplace', 'Licensing', 'Protection'] as link}
        <a href="#{link.toLowerCase()}" class="text-white hover:text-blue-300 border-b-2 border-transparent hover:border-white px-4 py-2 transition-all duration-300">{link}</a>
      {/each}
    </nav>
  
    <!-- Right Section Buttons -->
    <div class="flex space-x-4 mt-4 md:mt-0">
      <button class="bg-gray-800 text-white px-4 py-2 rounded-full shadow-md hover:bg-gray-700 transition-all duration-300 transform hover:scale-105">Get Started 🚀</button>
      <button class="bg-transparent border border-blue-200 text-white px-4 py-2 rounded-full shadow-md hover:bg-blue-300 hover:text-[#0f535c] transition-all duration-300 transform hover:scale-105">Partner with Us 🤝</button>
    </div>
  </header>
  
  <!-- Hero Section -->
  <section class="hero min-h-screen flex items-center justify-center bg-[#0f535c] text-white">
    <div class="container mx-auto flex flex-col md:flex-row items-center justify-between p-8">
      <!-- Left Side: Text Content -->
      <div class="text-content md:w-1/2 text-center md:text-left">
        <h1 class="text-4xl md:text-5xl font-bold mb-4 leading-tight">
          Protect Your Creations with <span class="text-[#00C4CC]">ChainGuard</span>
        </h1>
        <p class="text-lg md:text-xl mb-6">
          Secure your intellectual property with blockchain. Ensure your creative work is safe and monetized effectively.
        </p>
        <!-- Styled Buttons -->
        <div class="flex justify-center md:justify-start space-x-4">
          <button 
            on:click={handleSignUpClick}
            class="bg-[#00C4CC] text-white px-11 py-2 text-lg font-semibold shadow-lg hover:bg-white hover:text-[#0f535c] transition-all duration-300 ease-in-out transform hover:scale-105">
            Sign Up
          </button>
        
          <button 
            on:click={handleLoginClick}
            class="bg-transparent border-2 border-white text-white px-11 py-2 text-lg font-semibold shadow-lg hover:bg-white hover:text-[#0f535c] transition-all duration-300 ease-in-out transform hover:scale-105">
            Login
          </button>
        </div>
      </div>
  
      <!-- Right Side: Image or Graphic -->
      <div class="image-content md:w-1/2 mt-8 md:mt-0">
        <img src={hero} alt="Blockchain Security Graphic" class="w-full h-auto rounded-lg " />
      </div>
    </div>
  </section>
  
  
  <!-- Features Section -->
  <section id="features" class="section-padding bg-gradient-to-r from-[#f0f4f8] to-white py-16">
    <div class="container mx-auto text-center">
      <h2 class="text-4xl font-bold text-[#0f535c] mb-8">Platform Features</h2>
      <p class="text-gray-600 mb-12 max-w-3xl mx-auto">Discover how ChainGuard protects and empowers creators through blockchain-powered digital rights management and licensing.</p>
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
        {#each items as {title, description}}
          <div class="bg-white p-6 rounded-lg shadow-lg hover:shadow-xl transition-shadow duration-300 transform hover:scale-105">
            <h3 class="text-xl font-semibold text-[#0f535c] mb-4">{title}</h3>
            <p class="text-gray-600">{description}</p>
          </div>
        {/each}
      </div>
    </div>
  </section>
  
  <!-- Marketplace Section -->
  <section id="marketplace" class="section-padding bg-gradient-to-r from-blue-50 to-white py-16">
    <div class="container mx-auto text-center">
      <h2 class="text-4xl font-bold text-[#0f535c] mb-8">Marketplace</h2>
      <p class="text-gray-600 mb-12 max-w-2xl mx-auto">
        Explore our dynamic marketplace where you can showcase your intellectual property, find licensing opportunities, and connect with potential partners and buyers.
      </p>
  
      <!-- Marketplace Cards -->
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
        {#each items as {imgSrc, title, description}}
          <div class="bg-white p-6 rounded-lg shadow-lg hover:shadow-xl transition-shadow duration-300 transform hover:scale-105">
            <img src={imgSrc} alt="Marketplace Item" class="w-full h-48 object-cover rounded-md mb-4" />
            <h3 class="text-xl font-semibold text-[#0f535c] mb-2">{title}</h3>
            <p class="text-gray-600 mb-4">{description}</p>
          </div>
        {/each}
      </div>
    </div>
  </section>
  
  <!-- Licensing Section -->
  <section id="licensing" class="section-padding bg-gradient-to-r from-[#f9f9f9] to-white py-16">
    <div class="container mx-auto text-center">
      <h2 class="text-4xl font-bold text-[#0f535c] mb-8">Licensing Opportunities</h2>
      <p class="text-gray-600 mb-12 max-w-3xl mx-auto">
        Discover various licensing models and opportunities to monetize your intellectual property. Tailored solutions for every creative professional.
      </p>
  
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
        <!-- Licensing cards will go here -->
      </div>
    </div>
  </section>
  <footer class="bg-[#0f535c] text-white py-6 text-center">
    <div class="container mx-auto">
      <p class="mb-4">&copy; 2024 ChainGuard. All rights reserved.</p>
      <div class="space-x-4 mb-4">
        <a href="/privacy" class="hover:text-blue-300">Privacy Policy</a>
        <a href="/terms" class="hover:text-blue-300">Terms of Service</a>
        <a href="#contact" class="hover:text-blue-300">Contact</a>
      </div>
      <div class="space-x-6">
        <a href="https://facebook.com" target="_blank" class="hover:text-blue-300">
          <i class="fab fa-facebook fa-lg"></i>
        </a>
        <a href="https://twitter.com" target="_blank" class="hover:text-blue-300">
          <i class="fab fa-twitter fa-lg"></i>
        </a>
        <a href="https://instagram.com" target="_blank" class="hover:text-blue-300">
          <i class="fab fa-instagram fa-lg"></i>
        </a>
        <a href="https://linkedin.com" target="_blank" class="hover:text-blue-300">
          <i class="fab fa-linkedin fa-lg"></i>
        </a>
      </div>
    </div>
  </footer>