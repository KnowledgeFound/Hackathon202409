import UUID "mo:uuid/UUID";
import Source "mo:uuid/async/SourceV4";
import Sha256 "mo:sha2/Sha256";
import Text "mo:base/Text";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import ICRC1 "mo:icrc1-types";
import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Nat8 "mo:base/Nat8";
import Char "mo:base/Char";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import JSON "mo:json.mo";
import Types "Types";
import Vector "mo:vector";
import Debug "mo:base/Debug";

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

  // Helper functions
  public func textToNat(txt : Text) : Nat {
    assert (txt.size() > 0);
    let chars = txt.chars();

    var num : Nat = 0;
    for (v in chars) {
      let charToNum = Nat32.toNat(Char.toNat32(v) -48);
      assert (charToNum >= 0 and charToNum <= 9);
      num := num * 10 + charToNum;
    };

    num;
  };

  public func textToNat64(txt : Text) : Nat64 {
    assert (txt.size() > 0);
    let chars = txt.chars();

    var num : Nat = 0;
    for (v in chars) {
      let charToNum = Nat32.toNat(Char.toNat32(v) -48);
      assert (charToNum >= 0 and charToNum <= 9);
      num := num * 10 + charToNum;
    };

    Nat64.fromNat(num);
  };

  public func hashText(v: Text) : Blob {
    switch (Text.decodeUtf8(Sha256.fromBlob(#sha256, Text.encodeUtf8(v)))) {
      case (null) {
        Debug.trap("Failed to hash text");
      };
      case (?t) {
        t;
      };
    }
  };
};
