import { Actor, HttpAgent } from "@dfinity/agent";
import canisterIds from "../../.dfx/local/canister_ids.json";
import fetch from "isomorphic-fetch";
import { idlFactory } from "../declarations/backend/backend.did";

export const CANISTER_ID = canisterIds.backend.local;
console.log("CANISTER_ID", CANISTER_ID);

export const createActor = (canisterId, options = {}) => {
  const agent = options.agent || HttpAgent.createSync({ ...options.agentOptions });

  if (options.agent && options.agentOptions) {
    console.warn(
      "Detected both agent and agentOptions passed to createActor. Ignoring agentOptions and proceeding with the provided agent."
    );
  }

  // Fetch root key for certificate validation during development
  if (process.env.DFX_NETWORK !== "ic") {
    agent.fetchRootKey().catch((err) => {
      console.warn(
        "Unable to fetch root key. Check to ensure that your local replica is running"
      );
      console.error(err);
    });
  }

  // Creates an actor with using the candid interface and the HttpAgent
  return Actor.createActor(idlFactory, {
    agent,
    canisterId,
    ...options.actorOptions,
  });
};

export const actor = createActor(CANISTER_ID, {
  agentOptions: { host: "http://127.0.0.1:4943", fetch },
});