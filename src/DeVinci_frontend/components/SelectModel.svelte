<script>
  import logo from "../../../public/image8.png";
  import hero from "../../../public/image9.png";
  import vr from "../../../public/vr2.png"
  import eye from "../../../public/image6.png"
  // import '../index.scss';
    // import { error } from 'console';
    //import {goto} from ''
 // import { authenticateWithInternetIdentity } from '../routes/services/auth';

  let isMenuOpen = false;

  function toggleMenu() {
    isMenuOpen = !isMenuOpen;
  }

  function handleSignUpClick() {
    goto('/experiences');
  }

  async function authenticateWithInternetIdentity() {
    // Your actual authentication logic here
    return new Promise((resolve) => {
      setTimeout(resolve, 1000); // Simulate a delay
    });
  }

  const items = [
    {
      id: "item1",
      title: "Enhanced Natural Language Processing",
      description:
        "Experience the power of advanced LLM that understands and generates human-like text. Elevate your conversational AI and content creation.",
      imgSrc: vr,
      progress: "50%",
    },
    {
      id: "item2",
      title: "Industry-specific Models",
      description:
        "Our LLMs are tailored for various industries like healthcare, finance, and legal, providing specialized insights and automation.",
      imgSrc: eye,
       progress: "5%"
    },
    {
      id: "item3",
      title: "Seamless Integration",
      description:
        "Integrate LLM technology effortlessly with your existing platforms to enhance user experience, productivity, and creativity.",
      imgSrc: logo,
       progress: "0%",
    },
  ];
</script>

<link
  rel="stylesheet"
  href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"
/>

<!-- Navbar -->
<header
  class="bg-gradient-to-r from-[#0f535c] to-[#38a0ac] text-white py-4 px-6 flex flex-col md:flex-row items-center justify-between shadow-lg fixed top-0 w-full z-50"
>
  <div class="flex items-center space-x-4 w-full md:w-auto">
    <a use:link href="/" class="flex items-center space-x-2">
      <img src={logo} alt="LLM Logo" class="w-12 h-12 sm:w-14 sm:h-14 rounded-full border-4 border-blue-200 transition-transform transform hover:scale-110 duration-300" />
      <h1 class="text-xl sm:text-2xl md:text-3xl font-bold">LLMVerse</h1>
    </a>
  </div>

  <!-- Center Links (Desktop) -->
  <nav class="hidden md:flex flex-grow justify-center space-x-6 mt-4 md:mt-0">
    {#each ['Overview', 'Features', 'Integrations', 'Contact'] as link}
      <a use:link href="#{link.toLowerCase()}" class="text-white hover:text-blue-300 border-b-2 border-transparent hover:border-white px-4 py-2 transition-all duration-300">{link}</a>
    {/each}
  </nav>

  <!-- Right Section Buttons -->
  <div class="flex space-x-4 mt-4 md:mt-0">
    <button 
      on:click={handleLoginClick}
      class="bg-[#023e8a] text-white px-4 py-2 rounded-full shadow-md hover:bg-[#0077b6] transition-all duration-300 transform hover:scale-105">
      Get Started 🚀
    </button>
    <button 
      class="bg-transparent border border-blue-200 text-white px-4 py-2 rounded-full shadow-md hover:bg-blue-300 hover:text-[#023e8a] transition-all duration-300 transform hover:scale-105">
      Partner with Us 🤝
    </button>
  </div>
</header>

<!-- Hero Section -->
<section
  class="hero min-h-screen flex items-center justify-center bg-[#0f535c] text-white"
>
  <div
    class="container mx-auto flex flex-col md:flex-row items-center justify-between p-8"
  >
    <!-- Left Side: Text Content -->
    <div class="text-content md:w-1/2 text-center md:text-left">
      <h1 class="text-4xl md:text-5xl font-bold mb-4 leading-tight">
        Welcome to <span class="text-[#E1AD01]"
        >Anti-Corrupt AI </span
      >Expand your knowledge on corruption using 
      </h1>
      <p class="text-lg md:text-xl mb-6">
        Leveraging the power of blockchain and AI to enhance learning and create
        an overall corruption free environment all over the world.
      </p>
      <!-- Styled Buttons -->
      <div class="flex justify-center md:justify-start space-x-4">
        <button 
          on:click={handleLoginClick}
          class="bg-[#00C4CC] text-white px-11 py-2 text-lg font-semibold shadow-lg hover:bg-white hover:text-[#0077b6] transition-all duration-300 ease-in-out transform hover:scale-105">
          Go to learning
        </button>
      </div>
    </div>

    <!-- Right Side: Image or Graphic -->
    <div class="image-content md:w-1/2 mt-8 md:mt-0">
      <img src={logo} alt="LLM Hero Graphic" class="w-150 h-auto rounded-lg" />
      <img src={hero} alt="LLM Hero Graphic" class="w-150 h-auto rounded-lg" />
    </div>
  </div>
</section>

<!-- Features Section -->
<section
  id="features"
  class="section-padding bg-gradient-to-r from-[#38a0ac] to-white py-16"
>
  <div class="container mx-auto text-center">
    <h2 class="text-4xl font-bold text-[#0f535c] mb-8">Features</h2>
    <p class="text-gray-600 mb-12 max-w-3xl mx-auto">
      Discover the cutting-edge capabilities of LLMVerse. Explore
      industry-specific models, seamless integration, and unmatched language
      understanding.
    </p>
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
      {#each items as { title, description }}
        <div
          class="bg-[#0f535c] p-6 rounded-lg shadow-lg hover:shadow-xl transition-shadow duration-300 transform hover:scale-105"
        >
          <h3 class="text-xl font-semibold text-[#E1AD01] mb-4">{title}</h3>
          <!-- Removed the hyphen after the color code -->
          <p class="text-gray-800">{description}</p>
        </div>
      {/each}
    </div>
  </div>
</section>

<!-- Courses Section -->
<section
  id="courses"
  class="section-padding bg-gradient-to-r from-[#38a0ac] to-[#ffff]"
>
  <div class="container mx-auto text-center">
    <h2 class="text-4xl font-bold text-[#E1AD01] mb-8">Courses</h2>
    <p class="text-gray-900 mb-12 max-w-2xl mx-auto">
      Connect with various platforms and enhance the AI-driven features of your products. LLMVerse fits into your existing workflow effortlessly.
    </p>

    <!-- Courses Cards -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
      {#each items as { imgSrc, title, description, progress }}
        <div
          class="bg-[#0f535c] p-6 rounded-lg shadow-lg hover:shadow-xl transition-shadow duration-300 transform hover:scale-105"
        >
          <img
            src={imgSrc}
            alt="Integration"
            class="w-full h-48 object-cover rounded-md mb-4"
          />
          <h3 class="text-xl font-semibold text-[#E1AD01] mb-2">{title}</h3>
          <p class="text-gray-900 mb-4">{description}</p>
          
          <!-- Progress Bar -->
          <div class="w-full bg-gray-200 rounded-full h-4 mb-4">
            <div class="bg-[#E1AD01] h-4 rounded-full" style="width: {progress};"></div>
          </div>
          <p class="text-white">{progress}</p>
        </div>
      {/each}
    </div>
  </div>
</section>

<!-- Licensing Section -->
<section
  id="licensing"
  class="section-padding bg-gradient-to-r from-[#38a0ac] to-[#fff] py-16"
>
  <div class="container mx-auto text-center">
    <h2 class="text-4xl font-bold text-[#023e8a] mb-8">Licensing Opportunities</h2>
    <p class="text-gray-600 mb-12 max-w-2xl mx-auto">
      Explore licensing options to bring LLMVerse's advanced capabilities to your organization. Contact us to discuss tailored solutions.
    </p>
  </div>
</section>

<!-- Contact Us Section -->
<section id="contact" class="section-padding bg-[#023e8a] text-white py-16">
  <div class="container mx-auto text-center">
    <h2 class="text-4xl font-bold mb-6">Contact Us</h2>
    <p class="text-lg mb-6">Have questions or want to partner with us? Get in touch with our team for more information.</p>
    <p class="text-lg mb-6">Email: <a href="mailto:info@llmverse.com" class="underline">info@llmverse.com</a></p>
    <p class="text-lg">Phone: <a href="tel:+1234567890" class="underline">+1 (234) 567-890</a></p>
  </div>
</section>

<!-- Footer -->
<footer class="bg-gradient-to-r from-[#38a0ac] to-[#ffff] text-[#0f535c] py-6 text-center">
  <div class="container mx-auto">
    <p class="mb-4">&copy; 2024 LLMVerse. All rights reserved.</p>
    <div class="space-x-4 mb-4">
      <a href="/privacy" class="hover:text-blue-300">Privacy Policy</a>
      <a href="/terms" class="hover:text-blue-300">Terms of Service</a>
      <a href="#contact" class="hover:text-blue-300">Contact</a>
    </div>
    <div class="space-x-6">
      <a href="#" class="hover:text-blue-300">
        <i class="fab fa-facebook"></i>
      </a>
      <a href="#" class="hover:text-blue-300">
        <i class="fab fa-twitter"></i>
      </a>
      <a href="#" class="hover:text-blue-300">
        <i class="fab fa-linkedin"></i>
      </a>
    </div>
  </div>
</footer>

<footer class="bg-[#023e8a] text-white py-8">
  <div class="container mx-auto text-center">
    <p class="text-sm">© 2024 LLMVerse. All rights reserved.</p>
  </div>
</footer>
