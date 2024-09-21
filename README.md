# DeVinci

DeVinci is live on the Internet Computer. If you like, you can give it a try [here](https://px7id-byaaa-aaaak-albiq-cai.icp0.io/).

[Backend Canister](https://a4gq6-oaaaa-aaaab-qaa4q-cai.raw.icp0.io/?id=pq6ox-maaaa-aaaak-albia-cai)

## Design

Checkout the [design](https://miro.com/app/board/uXjVLfeaOGQ=/?share_link_id=752667331634) for the project on Miro.

### Goals

Better User Experience. We decided to go with the approach of using on offchain AI model because it's faster and more efficient. The user can interact with the AI model in real-time without too much delay. The AI model is pre-trained with the UNODC materails using Vector embeddings and stored off-chain.

The goal of this project is to create a decentralized AI chatbot that can be used by anyone to learn about corruption. The AI chatbot will be able to answer questions about any course and also provide quizzes for users to test their knowledge.

1. Ensure users can interact with the AI model in a decentralized manner.
2. User's don't need to log in to use the AI model to learn.
3. User's chats are stored on the canister ensuring they can always continue from where they left off.
4. Users can access their knowledge about any course by taking a quiz.
5. User's with internet identity will earn knowledge tokens for passing a quiz 100%.
6. If a user does not have an internet identity, they tokens earned will be placed on the canister which they can claim when they login with their internet identity anytime.

**Notes**:

- Currently, only Chrome and Edge on desktop support the required features (WebGPU). Other devices, including smartphones, and other browsers, cannot run it (for now).
- AI models are pretty huge and require quite some computational resources. As DeVinci runs on the user's device (via the browser), whether and how fast it may run depend on the device's hardware. If a given model doesn't work, the user can thus try a smaller one and see if the device can support it.
- For the best possible experience, we recommend running as few other programs and browser tabs as possible besides DeVinci as those can limit the computational resources available for DeVinci.

Do you have any feedback? We'd love to hear it! You can open an issue on GitHub or share your thoughts on this [forum post](https://forum.dfinity.org/t/browser-based-ai-chatbot-served-from-the-ic/22263). Thank you!

## About DeVinci

DeVinci is the personalized AI assistant that redefines the paradigm of digital privacy and trust. It's decentralized, trusted, open-source, and truly user-focused. Powered by an open-source AI model that runs directly within the browser, the interactions with DeVinci happen on the user's device, giving users unprecedented control.

### Key Features

- **Decentralized**: Operates directly within the browser. Users can choose if they want to log in and store their chats on the decentralized cloud and under their control.
- **Trusted**: No corporation behind, just an AI serving the user.
- **Open-source**: Built on open-source software (notably Web LLM and Internet Computer).
- **Personalized**: Users engage in meaningful conversations and ask questions, all while ensuring their privacy.

### How DeVinci Works

DeVinci comprises a frontend canister which integrates the AI model and a backend canister for optional chat history storage. Here's a glimpse of how DeVinci is structured:

#### Frontend Canister

The frontend canister serves the user interface, including HTML, CSS, and JavaScript files. It leverages the Web LLM npm library to wrap the AI model into the DeVinci chat app.

#### Web LLM

The open-source project Web LLM allows us to load and interact with open-source AI models. The selected model is loaded and cached into the browser and runs directly there, thus on the user's device. That way all interactions and data may stay local to the device. This significantly improves privacy and control over user data.

#### Offchain LLM

The AI model is pre-trained and stored off-chain. Using OpenAI's GPT-3 model, the AI can generate human-like text responses to user inputs. the canister interacts with this model using ICP HTTPS Outcalls.

#### Backend Canister

The backend canister enables users to persist their chats and to store any other user data (e.g. settings) if they choose to (DeVinci can be used without logging in and even when logged in users have the choice whether they want their chats to be stored). All of this is achieved in a decentralized manner through the Internet Computer, ensuring high availability and scalability.

## Internet Computer Resources

DeVinci is built and hosted on the Internet Computer. To learn more about it, see the following documentation available online:

- [Quick Start](https://sdk.dfinity.org/docs/quickstart/quickstart-intro.html)
- [SDK Developer Tools](https://sdk.dfinity.org/docs/developers-guide/sdk-guide.html)
- [Motoko Programming Language Guide](https://sdk.dfinity.org/docs/language-guide/motoko.html)
- [Motoko Language Quick Reference](https://sdk.dfinity.org/docs/language-guide/language-manual.html)
- [JavaScript API Reference](https://erxue-5aaaa-aaaab-qaagq-cai.raw.ic0.app)

## Running the project locally

If you want to run this project locally, you can use the following commands:

### 1. Install dependencies

```bash
npm install
```

### 2. Imstall mops

```bash
npm install -g ic-mops
```

### 3. Start a local replica

```bash
dfx start --background
```

Note: this starts a local replica of the Internet Computer (IC) which includes the canisters state stored from previous sessions.
If you want to start a clean local IC replica (i.e. all canister state is erased) run instead:

```bash
dfx start --clean --background
```

### 4. Setting up DFX deps

- Initialize the dependencies:

```bash
dfx deps init
```

- Install the dependencies:

```bash
dfx deps pull
```

- Deploy the dependencies:

```bash
dfx deps deploy
```

### 5. Deploy the canisters locally

- Deploy the backend canister:

```bash
dfx deploy backend --local
dfx deploy DeVinci_frontend --local
```

- Deploy the frontend canister:

```bash
dfx deploy DeVinci_frontend --local
```

Alternative: Run a local vite UI

```bash
npm run vite
```

### Running tests

To run the tests, use the following command:

```bash
mops test
```

This uses `mops test` package to run the tests. Unit tests only.

To run `e2e` tests, use the following command:

```bash
npm run test
```

This uses vitest to run the tests. End-to-end tests only.

### Deployment to the Internet Computer mainnet

Deploy the code as canisters to the live IC where it's accessible via regular Web browsers.

### Development Stage

```bash
dfx deploy --network development --argument "( principal\"$(dfx identity get-principal)\" )" backend
dfx deploy --network development DeVinci_frontend
```

### Testing Stage

```bash
dfx deploy --network testing --argument "( principal\"$(dfx identity get-principal)\" )" backend
dfx deploy --network testing DeVinci_frontend
```

For setting up stages, see [Notes on Stages](./notes/NotesOnStages.md)

### Production Deployment

```bash
npm install

dfx start --background
```

Deploy to Mainnet (live IC):
Ensure that all changes needed for Mainnet deployment have been made (e.g. define HOST in store.ts)

```bash
dfx deploy --network ic --argument "( principal\"$(dfx identity get-principal)\" )" backend
dfx deploy --network ic DeVinci_frontend
```

In case there are authentication issues, you could try this command
(Note that only authorized identities which are set up as canister controllers may deploy the production canisters)

```bash
dfx deploy --network ic --wallet "$(dfx identity --network ic get-wallet)"
```

## Credits

Running DeVinci in your browser is enabled by the great open-source project [Web LLM](https://webllm.mlc.ai/)

Serving this app and hosting the data securely and in a decentralized way is made possible by the [Internet Computer](https://internetcomputer.org/)

## Get and delete Email Subscribers

The project has email subscription functionality included. The following commands are helpful for managing subscriptions.

```bash
dfx canister call backend get_email_subscribers
dfx canister call backend delete_email_subscriber 'j@g.com'

dfx canister call backend get_email_subscribers --network development
dfx canister call backend delete_email_subscriber 'j@g.com' --network development

dfx canister call backend get_email_subscribers --network ic
dfx canister call backend delete_email_subscriber 'j@g.com' --network ic
```

## Cycles for Production Canisters

Due to the IC's reverse gas model, developers charge their canisters with cycles to pay for any used computational resources. The following can help with managing these cycles.

[Fund wallet with cycles (from ICP)](https://medium.com/dfinity/internet-computer-basics-part-3-funding-a-cycles-wallet-a724efebd111)

Top up cycles:

```bash
dfx identity --network=ic get-wallet
dfx wallet --network ic balance
dfx canister --network ic status backend
dfx canister --network ic status DeVinci_frontend
dfx canister --network ic --wallet 3v5vy-2aaaa-aaaai-aapla-cai deposit-cycles 3000000000000 backend
dfx canister --network ic --wallet 3v5vy-2aaaa-aaaai-aapla-cai deposit-cycles 300000000000 DeVinci_frontend
```
