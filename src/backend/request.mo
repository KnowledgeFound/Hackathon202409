import Blob "mo:base/Blob";
import Cycles "mo:base/ExperimentalCycles";
import Array "mo:base/Array";
import Text "mo:base/Text";
import Result "mo:base/Result";
import Iter "mo:base/Iter";
import Buffer "mo:base/Buffer";
import Debug "mo:base/Debug";
import Source "mo:uuid/async/SourceV4";
import UUID "mo:uuid/UUID";
import Types "Types";
import JSON "mo:json.mo";

module Request {
  type Result<A, B> = Result.Result<A, B>;

  let ic : Types.IC = actor ("aaaaa-aa");

  public func getHost(url : Text) : Text {
    // Remove the protocol
    let urlWithoutProtocol = Text.trimStart(Text.trimStart(url, #text "https://"), #text "http://");
    let parts = Iter.toArray(Text.split(urlWithoutProtocol, #char '/'));
    assert Array.size(parts) != 0;
    return parts[0];
  };

  public func getPort(url : Text) : Text {
    if (Text.startsWith(url, #text "https://")) {
      return ":443";
    };
    return ":80";
  };

  public func formatHttpResponse(
    http_response : Types.HttpResponsePayload
  ) : async Types.HttpReponse {
    let response_body : Blob = Blob.fromArray(http_response.body);
    let jsonBody = switch (Text.decodeUtf8(response_body)) {
      case (null) { #Object([("error", #String("No response"))]) };
      case (?y) {
        // Clean y
        let t = Text.replace(y, #text "1.0", "1");
        switch (JSON.parse(t)) {
          case (null) {
            #Object([("error", #String("Invalid json string: " # y))]);
          };
          case (?json) { json };
        };
      };
    };
    return {
      status = http_response.status;
      body = jsonBody;
    };
  };

  public func getHeaders(url : Text, headers : ?[Types.HttpHeader]) : async [Types.HttpHeader] {
    let g = Source.Source();
    let idempotency_key = UUID.toText(await g.new());
    var request_headers = [
      { name = "Host"; value = getHost(url) # getPort(url) },
      { name = "User-Agent"; value = "unkorrupt_canister" },
      { name = "Content-Type"; value = "application/json" },
      { name = "Idempotency-Key"; value = idempotency_key },
    ];

    switch (headers) {
      case (?h) {
        let initial = Buffer.fromArray<Types.HttpHeader>(request_headers);
        let new = Buffer.fromArray<Types.HttpHeader>(h);
        initial.append(new);
        request_headers := Buffer.toArray(initial);
      };
      case (null) {};
    };

    return request_headers;
  };

  public func get(
    url : Text,
    transform : Types.TransformFn,
    headers : ?[Types.HttpHeader],
  ) : async Types.HttpReponse {

    let request_headers = await getHeaders(url, headers);

    let transform_context : Types.TransformContext = {
      function = transform;
      context = Blob.fromArray([]);
    };

    let http_request : Types.HttpRequestArgs = {
      url = url;
      max_response_bytes = null; //optional for request
      headers = request_headers;
      body = null; //optional for request
      method = #get;
      transform = ?transform_context;
    };

    Cycles.add<system>(20_949_972_000);

    let http_response : Types.HttpResponsePayload = await ic.http_request(http_request);
    return await formatHttpResponse(http_response);
  };

  public func post(
    url : Text,
    data : ?JSON.JSON,
    transform : Types.TransformFn,
    headers : ?[Types.HttpHeader],
  ) : async Types.HttpReponse {
    let request_headers = await getHeaders(url, headers);

    var request_body_as_nat8 : ?[Nat8] = null;

    switch (data) {
      case (null) {};
      case (?d) {
        let request_body_as_blob : Blob = Text.encodeUtf8(JSON.show(d));
        request_body_as_nat8 := ?Blob.toArray(request_body_as_blob);
      };
    };

    let transform_context : Types.TransformContext = {
      function = transform;
      context = Blob.fromArray([]);
    };

    let http_request : Types.HttpRequestArgs = {
      url = url;
      max_response_bytes = null; //optional for request
      headers = request_headers;
      body = request_body_as_nat8;
      method = #post;
      transform = ?transform_context;
    };

    Cycles.add<system>(230_850_258_000);

    let http_response : Types.HttpResponsePayload = await ic.http_request(http_request);
    return await formatHttpResponse(http_response);
  };
};
