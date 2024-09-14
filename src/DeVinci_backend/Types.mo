// https://github.com/dfinity/examples/blob/master/motoko/dip-721-nft-container/src/Types.mo
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Nat16 "mo:base/Nat16";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import Blob "mo:base/Blob";
import Principal "mo:base/Principal";
import List "mo:base/List";
import AssocList "mo:base/AssocList";
import Time "mo:base/Time";
import Vector "mo:vector";
import JSON "mo:json.mo";
import Result "mo:base/Result";

module {
  public type Vector<T> = Vector.Vector<T>;
  public type Result<A, B> = Result.Result<A, B>;

  public type User = {
    id : Text;
    principal : ?Principal;
    fullname : Text;
    claimableTokens : Nat;
    enrolledCourses : Vector<EnrolledCourse>;
  };

  public type SharedUser = {
    id : Text;
    fullname : Text;
    principal : ?Principal;
    claimableTokens : Nat;
  };

  public type EnrolledCourse = {
    id : Text;
    threadId: Text;
    completed : Bool;
    messages : Vector<Message>;
  };

  public type SharedEnrolledCourse = {
    id : Text;
    threadId: Text;
    completed : Bool;
    messages : [Message];
  };

  public type EnrolledCourseProgress = {
    id : Nat;
    title : Text;
    completed : Bool;
  };

  public type RunStatus = {
    #InProgress;
    #Completed;
    #Failed;
    #Cancelled;
    #Expired;
  };

  public type ThreadRunJob = {
    #Message;
    #Question;
  };

  public type ThreadRun = {
    runId : Text;
    threadId : Text;
    status : RunStatus;
    timestamp : Time.Time;
    lastExecuted : ?Time.Time;
    job : ThreadRunJob;
    var processing : Bool;
  };

  public type SharedThreadRun = {
    runId : Text;
    threadId : Text;
    status : RunStatus;
    timestamp : Time.Time;
    lastExecuted : ?Time.Time;
    job : ThreadRunJob;
    processing : Bool;
  };

  public type MessgeType = {
    #User;
    #System;
  };

  public type Message = {
    runId : ?Text;
    content : Text;
    role : MessgeType;
  };

  public type SendMessageStatus = {
    #Completed : {
      runId : Text;
    };
    #ThreadLock : {
      runId : Text;
    };
    #Failed : Text;
  };

  public type Course = {
    id : Nat;
    title : Text;
    summary : Text;
    resources : Vector<Resources>;
    questions : Vector<Question>;
  };

  public type SharedCourse = {
    id : Nat;
    title : Text;
    summary : Text;
  };

  public type ResourceType = {
    #Book;
    #Video;
    #Article;
    #Slides;
  };

  public type Resource = {
    id : Text;
    title : Text;
    url : Text;
    rType : ResourceType;
  };

  public type Question = {
    id : Text;
    description : Text;
    options : [QuestionOption];
    correctOption : Nat;
  };

  public type QuestionOption = {
    option : Nat;
    description : Text;
  };

  public type SubmittedAnswer = {
    questionId : Nat;
    option : Nat;
  };

  // HTTP Request types
  public type Timestamp = Nat64;

  public type HttpRequestArgs = {
    url : Text;
    max_response_bytes : ?Nat64;
    headers : [HttpHeader];
    body : ?[Nat8];
    method : HttpMethod;
    transform : ?TransformRawResponseFunction;
  };

  public type HttpHeader = {
    name : Text;
    value : Text;
  };

  public type HttpMethod = {
    #get;
    #post;
    #head;
  };

  public type HttpResponsePayload = {
    status : Nat;
    headers : [HttpHeader];
    body : [Nat8];
  };

  public type HttpReponse = {
    status : Nat;
    body : JSON.JSON;
  };

  public type TransformFn = shared query TransformArgs -> async HttpResponsePayload;

  public type TransformRawResponseFunction = {
    function : TransformFn;
    context : Blob;
  };

  public type TransformArgs = {
    response : HttpResponsePayload;
    context : Blob;
  };

  public type CanisterHttpResponsePayload = {
    status : Nat;
    headers : [HttpHeader];
    body : [Nat8];
  };

  public type TransformContext = {
    function : TransformFn;
    context : Blob;
  };

  public type IC = actor {
    http_request : HttpRequestArgs -> async HttpResponsePayload;
  };

  public type Chat = {
    id : Text;
    messages : [Message];
    owner : Principal;
    creationTime : Nat64;
    firstMessagePreview : Text;
    chatTitle : Text;
  };

  public type ChatPreview = {
    id : Text;
    creationTime : Nat64;
    firstMessagePreview : Text;
    chatTitle : Text;
  };

  public type UpdateChatObject = {
    id : Text;
    chatTitle : Text;
  };

  public type Message = {
    sender : Text;
    content : Text;
  };

  public type ChatCreationResult = Result<Text, ApiError>;

  public type ChatResult = Result<Chat, ApiError>;

  public type ChatsResult = Result<[Chat], ApiError>;

  public type ChatIdResult = Result<Text, ApiError>;

  public type ChatsPreviewResult = Result<[ChatPreview], ApiError>;

  public type UserSettings = {
    selectedAiModelId : Text;
  };

  public type UserSettingsResult = Result<UserSettings, ApiError>;

  public type UpdateUserSettingsResult = Result<Bool, ApiError>;

  public type Dip721NonFungibleToken = {
    logo : LogoResult;
    name : Text;
    symbol : Text;
    maxLimit : Nat16;
  };

  public type ApiError = {
    #Unauthorized;
    #InvalidTokenId;
    #ZeroAddress;
    #Other : Text;
  };

  public type Result<S, E> = {
    #Ok : S;
    #Err : E;
  };

  public type OwnerResult = Result<Principal, ApiError>;
  public type TxReceipt = Result<Nat, ApiError>;

  public type TransactionId = Nat;
  public type TokenId = Nat64;

  public type InterfaceId = {
    #Approval;
    #TransactionHistory;
    #Mint;
    #Burn;
    #TransferNotification;
  };

  public type LogoResult = {
    logo_type : Text;
    data : Text;
  };

  public type Nft = {
    owner : Principal;
    id : TokenId;
    metadata : MetadataDesc;
  };

  public type NftResult = Result<Nft, ApiError>;

  public type ExtendedMetadataResult = Result<{ metadata_desc : MetadataDesc; token_id : TokenId }, ApiError>;

  public type MetadataResult = Result<MetadataDesc, ApiError>;

  public type MetadataDesc = [MetadataPart];

  public type MetadataPart = {
    purpose : MetadataPurpose;
    key_val_data : [MetadataKeyVal];
    data : Blob;
  };

  public type MetadataPurpose = {
    #Preview;
    #Rendered;
  };

  public type MetadataKeyVal = {
    key : Text;
    val : MetadataVal;
  };

  public type MetadataVal = {
    #TextContent : Text;
    #BlobContent : Blob;
    #NatContent : Nat;
    #Nat8Content : Nat8;
    #Nat16Content : Nat16;
    #Nat32Content : Nat32;
    #Nat64Content : Nat64;
    #PrincipalContent : Principal; // added
    #TextArrayContent : [Text]; // added
    #TextToTextAssocListContent : AssocList.AssocList<Text, Text>; // added
  };

  public type MintReceipt = Result<MintReceiptPart, ApiError>;

  public type MintReceiptPart = {
    token_id : TokenId;
    id : Nat;
  };

  public type UpdateMetadataValuesInput = {
    id : TokenId;
    updatedOwnerName : Text;
    updatedOwnerContactInfo : Text;
    updatedSpaceDescription : Text;
    updatedSpaceName : Text;
    updatedSpaceData : ?Text;
  };

  public type MemoryVectorMetadata = {
    id : Int;
  };

  public type MemoryVector = {
    content : Text;
    embedding : [Float];
    metadata : MemoryVectorMetadata;
  };

  public type MemoryVectorsStoredResult = Result<Bool, ApiError>;

  public type MemoryVectorsResult = Result<[MemoryVector], ApiError>;

  public type MemoryVectorsCheckResult = Result<Bool, ApiError>;

  public type SignUpFormInput = {
    emailAddress : Text; // provided by user on signup
    pageSubmittedFrom : Text; // capture for analytics
  };

  public type EmailSubscriber = {
    emailAddress : Text;
    pageSubmittedFrom : Text;
    subscribedAt : Nat64;
  };

  public type EducationExperience = {
    id : Text; // Internal id assigned to experience
    title : Text; // Title of experience to be shown on overview
    creator : Text; // Name of the team who created this experience
    shortDescription : Text; // max 2 sentences (200 characters)
    longDescription : Text; // max 100 words
    note : Text; // space for additional info team wants to provide to user on overview (max 50 words)
    isStandaloneApp : Bool; // Whether this experience loads in its own new tab or can be loaded directly in this app
    standaloneAppUrl : ?Text; // Only for isStandaloneApp=true, URL to open in new tab
    experienceType : ?ExperienceType; // For experiences loaded in this app, possible values: ondevice, onchain, offchain
    aiModelIdentifier : ?Text; // Identifies and locates the AI model, value depends on experienceType
    databaseToInclude : DatabaseToInclude; // Database to include in model's responses, possible values: none, external, local
    databaseIdentifier : ?Text; // Identifies and locates the (vector) database or its data to use
  };

  public type ExperienceType = {
    #Ondevice;
    #Onchain;
    #Offchain;
  };

  public type DatabaseToInclude = {
    #None;
    #External;
    #Local;
  };
};
