<script>
    import { onMount } from 'svelte';
    let currentQuestionIndex = 0;
    let score = 0;
    let showScore = false;
  
    // Sample quiz questions
    const questions = [
      {
        question: "What is the capital of France?",
        choices: ["Berlin", "Madrid", "Paris", "Rome"],
        correctAnswer: "Paris",
      },
      {
        question: "Which language is primarily used for web development?",
        choices: ["Python", "JavaScript", "C++", "Java"],
        correctAnswer: "JavaScript",
      },
      {
        question: "Who wrote 'To Kill a Mockingbird'?",
        choices: ["Harper Lee", "Mark Twain", "J.K. Rowling", "Charles Dickens"],
        correctAnswer: "Harper Lee",
      },
    ];
  
    let selectedAnswer = "";
  
    // Function to handle the answer selection
    function selectAnswer(choice) {
      selectedAnswer = choice;
    }
  
    // Function to handle moving to the next question
    function nextQuestion() {
      if (selectedAnswer === questions[currentQuestionIndex].correctAnswer) {
        score++;
      }
      selectedAnswer = "";
  
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        showScore = true;
      }
    }
  
    // Reset the quiz
    function restartQuiz() {
      currentQuestionIndex = 0;
      score = 0;
      showScore = false;
    }
  </script>
  
  <style>
    .highlight {
      color: #E1AD01;
    }
    .quiz-container {
      max-width: 600px;
      margin: 0 auto;
      padding: 20px;
      background: #f8f9fa;
      border-radius: 8px;
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    }
    .question {
      font-size: 1.2em;
      margin-bottom: 10px;
    }
    .choice {
      display: block;
      margin: 8px 0;
      padding: 10px;
      background: #f1f1f1;
      border-radius: 5px;
      cursor: pointer;
      border: 1px solid transparent;
    }
    .choice:hover {
      border-color: #ddd;
    }
    .choice.selected {
      background: #e0e0e0;
      border-color: #E1AD01;
    }
    button {
      margin-top: 20px;
      padding: 10px 20px;
      background-color: #0077b6;
      color: white;
      border: none;
      border-radius: 5px;
      cursor: pointer;
      transition: background-color 0.3s;
    }
    button:hover {
      background-color: #005f8a;
    }
  </style>
  
  <div class="quiz-container">
    {#if !showScore}
      <div>
        <p class="question">{questions[currentQuestionIndex].question}</p>
        {#each questions[currentQuestionIndex].choices as choice}
          <span
            class="choice {selectedAnswer === choice ? 'selected' : ''}"
            on:click={() => selectAnswer(choice)}
          >
            {choice}
          </span>
        {/each}
  
        <button on:click={nextQuestion} disabled={!selectedAnswer}>
          Next
        </button>
      </div>
    {:else}
      <div>
        <h2 class="highlight">Quiz Completed!</h2>
        <p>Your score: {score} / {questions.length}</p>
        <button on:click={restartQuiz}>Restart Quiz</button>
      </div>
    {/if}
  </div>
  