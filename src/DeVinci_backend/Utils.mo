import UUID "mo:uuid/UUID";
import Source "mo:uuid/async/SourceV4";
import Sha256 "mo:sha2/Sha256";
import Text "mo:base/Text";
import ICRC1 "mo:icrc1-types";
import Array "mo:base/Array";
import Result "mo:base/Result";
import JSON "mo:json.mo";
import Types "Types";
import Vector "mo:vector";

module {
  type Result<A, B> = Result.Result<A, B>;
  type Model = {
    id : Nat;
  };

  type ModelConvertible = {
    #resource : Vector.Vector<Types.Resource>;
    #question : Vector.Vector<Types.Question>;
  };

  public func resourceEqual(a : Types.Resource, b : Types.Resource) : Bool {
    return a.id == b.id;
  };

  public func questionEqual(a : Types.Question, b : Types.Question) : Bool {
    return a.id == b.id;
  };

  public func vecContains(x : ModelConvertible, id : Text) : Bool {
    switch (x) {
      case (#resource(v)) {
        for (k in Vector.vals(v)) {
          if (k.id == id) {
            return true;
          };
        };
      };
      case (#question(v)) {
        for (k in Vector.vals(v)) {
          if (k.id == id) {
            return true;
          };
        };
      };
    };
    return false;
  };

  public func createIcrcActor(canisterId : Text) : async ICRC1.Service {
    actor (canisterId);
  };

  public func uuid() : async Text {
    let g = Source.Source();
    UUID.toText(await g.new());
  };

  public func hashText(v : Text) : Text {
    let h = debug_show(Sha256.fromBlob(#sha256, Text.encodeUtf8(v)));
    var out: Text = Text.replace(h, #char '\\', "");
    let trimmed = Text.trim(out, #char '\"');
    return Text.toLowercase(trimmed);
  };

  public func getOpenAiRunValue(body : JSON.JSON, runId : Text) : ?Text {
    var value : ?Text = null;

    switch (body) {
      case (#Object(v)) {
        label findData for ((k, v) in v.vals()) {
          if (k == "data") {
            switch (v) {
              case (#Array(v)) {
                for (i in v.vals()) {
                  switch (i) {
                    case (#Object(v)) {
                      var foundRunId = false;
                      label findRunId for ((k, v) in v.vals()) {
                        if (k == "run_id") {
                          switch (v) {
                            case (#String(rid)) {
                              if (rid == runId) {
                                foundRunId := true;
                              };
                            };
                            case (_) {};
                          };
                          break findRunId;
                        };
                      };
                      if (foundRunId) {
                        label findContent for ((k, v) in v.vals()) {
                          if (k == "content") {
                            switch (v) {
                              case (#Array(items)) {
                                if (Array.size(items) != 0) {
                                  let firstItem = items[0];
                                  switch (firstItem) {
                                    case (#Object(v)) {
                                      label findText for ((k, v) in v.vals()) {
                                        if (k == "text") {
                                          switch (v) {
                                            case (#Object(v)) {
                                              label findValue for ((k, v) in v.vals()) {
                                                if (k == "value") {
                                                  switch (v) {
                                                    case (#String(t)) {
                                                      value := ?t;
                                                    };
                                                    case (_) {};
                                                  };
                                                  break findValue;
                                                };
                                              };
                                            };
                                            case (_) {};
                                          };
                                          break findText;
                                        };
                                      };
                                    };
                                    case (_) {};
                                  };
                                };
                              };
                              case (_) {};
                            };
                            break findContent;
                          };
                        };
                      };
                    };
                    case (_) {};
                  };
                };
              };
              case (_) {};
            };
          };
        };
      };
      case (_) {};
    };

    value;
  };
};
