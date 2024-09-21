import Text "mo:base/Text";
import { test; suite; expect } "mo:test/async";
import Utils "../Utils";
import JSON "mo:json.mo";

await suite(
  "Test utils",
  func() : async () {
    await test(
      "test hashing text",
      func() : async () {
        let result = Utils.hashText("Bob");
        expect.text(result).equal("cd9fb1e148ccd8442e5aa74904cc73bf6fb54d1d54d333bd596aa9bb4bb4e961");
      },
    );
    await test(
      "test uuid",
      func() : async () {
        let result = await Utils.uuid();
        let len = Text.size(result);
        expect.nat(len).equal(36);
      },
    );
    await test(
      "test get open ai run value",
      func() : async () {

        let open_ai_messages = JSON.parse("
        {
            \"object\": \"list\",
            \"data\": [
                {
                    \"id\": \"msg_Wo25cukH1UjdhjIFQvpJYx0j\",
                    \"object\": \"thread.message\",
                    \"created_at\": 1724773505,
                    \"assistant_id\": \"asst_XZBwCj5Y1RVhWH6dVLB8hl1m\",
                    \"thread_id\": \"thread_kBrvDwkgulFR6kciogmG3lxn\",
                    \"run_id\": \"run_W8s2VKzRCzy5Ak5NXM2tOfvX\",
                    \"role\": \"assistant\",
                    \"content\": [
                        {
                            \"type\": \"text\",
                            \"text\": {
                                \"value\": \"Hello\",
                                \"annotations\": []
                            }
                        }
                    ],
                    \"attachments\": [],
                    \"metadata\": {}
                }
            ],
            \"first_id\": \"msg_Wo25cukH1UjdhjIFQvpJYx0j\",
            \"last_id\": \"msg_hDQvx81p2bUMVd7BkjG608Cw\",
            \"has_more\": false
        }
        ");

        switch (open_ai_messages) {
          case (null) {
            assert false;
          };
          case (?json) {
            let result = Utils.getOpenAiRunValue(json, "run_W8s2VKzRCzy5Ak5NXM2tOfvX");
            switch (result) {
              case (?v) {
                expect.text(v).equal("Hello");
              };
              case (null) {
                assert false;
              };
            };
          };
        };
      },
    );
  },
);
