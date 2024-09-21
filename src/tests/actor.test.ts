import { expect, test } from "vitest";
import { actor } from "./actor";

test("should handle generating random number", async () => {
  const result1 = await actor.generateRandomNumber(10n);
  expect(result1).to.lessThan(10);
});
