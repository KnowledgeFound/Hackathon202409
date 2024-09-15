import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';
import type { IDL } from '@dfinity/candid';

export type ApiError = { 'ZeroAddress' : null } |
  { 'NotFound' : string } |
  { 'InvalidTokenId' : null } |
  { 'Unauthorized' : null } |
  { 'Other' : string };
export interface Backend {
  'addAcls' : ActorMethod<[Principal], undefined>,
  'addQuestion' : ActorMethod<[string, Question], Result>,
  'changeApiKey' : ActorMethod<[string], Result_2>,
  'changeOwner' : ActorMethod<[string], Result_2>,
  'check_course_has_memory_vectors_entry' : ActorMethod<[string], Result_1>,
  'createCourse' : ActorMethod<[string, string], Result>,
  'createResource' : ActorMethod<
    [string, string, string, ResourceType__1],
    Result
  >,
  'delete_email_subscriber' : ActorMethod<[string], boolean>,
  'enrollCourse' : ActorMethod<[string, string], Result>,
  'generateQuestionsForCourse' : ActorMethod<[string], Result_3>,
  'generateRandomNumber' : ActorMethod<[bigint], bigint>,
  'getAcls' : ActorMethod<[], Array<Principal>>,
  'getCourseQuestions' : ActorMethod<[string], Result_7>,
  'getCourseResources' : ActorMethod<[string], Result_10>,
  'getOwner' : ActorMethod<[], Principal>,
  'getProfile' : ActorMethod<[string], Result_9>,
  'getRandomCourseQuestions' : ActorMethod<[string, bigint], Result_7>,
  'getRunMessage' : ActorMethod<[string, string], Result_8>,
  'getRunQuestions' : ActorMethod<[string], Result_7>,
  'getRunStatus' : ActorMethod<[string], Result_6>,
  'getRunsInQueue' : ActorMethod<[], Array<SharedThreadRun>>,
  'getUserEnrolledCourse' : ActorMethod<[string, string], Result_5>,
  'get_course_memory_vectors' : ActorMethod<[string], Result_4>,
  'get_education_experiences' : ActorMethod<[], Array<EducationExperience>>,
  'get_email_subscribers' : ActorMethod<[], Array<[string, EmailSubscriber]>>,
  'get_icrc1_token_canister_id' : ActorMethod<[], string>,
  'listCourses' : ActorMethod<[], Array<SharedCourse>>,
  'registerUser' : ActorMethod<[string], Result>,
  'removeAcls' : ActorMethod<[Principal], Result_2>,
  'removeQuestion' : ActorMethod<[string, string], Result_2>,
  'removeResource' : ActorMethod<[string, string], Result_2>,
  'sendMessage' : ActorMethod<[string, string, string], Result_3>,
  'setAssistantId' : ActorMethod<[string], Result_2>,
  'setRunProcess' : ActorMethod<[string, boolean], Result_2>,
  'set_icrc1_token_canister' : ActorMethod<[string], Result_2>,
  'store_course_memory_vectors' : ActorMethod<
    [string, Array<MemoryVector>],
    Result_1
  >,
  'submitQuestionsAttempt' : ActorMethod<
    [string, Array<SubmittedAnswer>, string],
    Result
  >,
  'submit_signup_form' : ActorMethod<[SignUpFormInput], string>,
  'transform' : ActorMethod<[TransformArgs], CanisterHttpResponsePayload>,
  'updateCourse' : ActorMethod<[string, string, string], Result>,
}
export interface CanisterHttpResponsePayload {
  'status' : bigint,
  'body' : Uint8Array | number[],
  'headers' : Array<HttpHeader>,
}
export type DatabaseToInclude = { 'Local' : null } |
  { 'None' : null } |
  { 'External' : null };
export interface EducationExperience {
  'id' : string,
  'isStandaloneApp' : boolean,
  'title' : string,
  'creator' : string,
  'note' : string,
  'databaseToInclude' : DatabaseToInclude,
  'shortDescription' : string,
  'standaloneAppUrl' : [] | [string],
  'databaseIdentifier' : [] | [string],
  'experienceType' : [] | [ExperienceType],
  'aiModelIdentifier' : [] | [string],
  'longDescription' : string,
}
export interface EmailSubscriber {
  'subscribedAt' : bigint,
  'emailAddress' : string,
  'pageSubmittedFrom' : string,
}
export type ExperienceType = { 'Onchain' : null } |
  { 'Offchain' : null } |
  { 'Ondevice' : null };
export interface HttpHeader { 'value' : string, 'name' : string }
export interface HttpResponsePayload {
  'status' : bigint,
  'body' : Uint8Array | number[],
  'headers' : Array<HttpHeader>,
}
export interface MemoryVector {
  'content' : string,
  'metadata' : MemoryVectorMetadata,
  'embedding' : Array<number>,
}
export interface MemoryVectorMetadata { 'id' : bigint }
export interface Message {
  'content' : string,
  'role' : MessgeType,
  'runId' : [] | [string],
}
export interface Message__1 {
  'content' : string,
  'role' : MessgeType,
  'runId' : [] | [string],
}
export type MessgeType = { 'System' : null } |
  { 'User' : null };
export interface Question {
  'id' : string,
  'correctOption' : bigint,
  'description' : string,
  'options' : Array<QuestionOption>,
}
export interface QuestionOption { 'option' : bigint, 'description' : string }
export interface Resource {
  'id' : string,
  'url' : string,
  'title' : string,
  'rType' : ResourceType,
}
export type ResourceType = { 'Book' : null } |
  { 'Article' : null } |
  { 'Slides' : null } |
  { 'Video' : null };
export type ResourceType__1 = { 'Book' : null } |
  { 'Article' : null } |
  { 'Slides' : null } |
  { 'Video' : null };
export type Result = { 'ok' : string } |
  { 'err' : ApiError };
export type Result_1 = { 'ok' : boolean } |
  { 'err' : ApiError };
export type Result_10 = { 'ok' : Array<Resource> } |
  { 'err' : ApiError };
export type Result_2 = { 'ok' : null } |
  { 'err' : ApiError };
export type Result_3 = { 'ok' : SendMessageStatus } |
  { 'err' : SendMessageStatus };
export type Result_4 = { 'ok' : Array<MemoryVector> } |
  { 'err' : ApiError };
export type Result_5 = { 'ok' : SharedEnrolledCourse } |
  { 'err' : ApiError };
export type Result_6 = { 'ok' : RunStatus__1 } |
  { 'err' : ApiError };
export type Result_7 = { 'ok' : Array<Question> } |
  { 'err' : ApiError };
export type Result_8 = { 'ok' : Message__1 } |
  { 'err' : ApiError };
export type Result_9 = { 'ok' : SharedUser } |
  { 'err' : ApiError };
export type RunStatus = { 'Failed' : null } |
  { 'Cancelled' : null } |
  { 'InProgress' : null } |
  { 'Completed' : null } |
  { 'Expired' : null };
export type RunStatus__1 = { 'Failed' : null } |
  { 'Cancelled' : null } |
  { 'InProgress' : null } |
  { 'Completed' : null } |
  { 'Expired' : null };
export type SendMessageStatus = { 'Failed' : string } |
  { 'ThreadLock' : { 'runId' : string } } |
  { 'Completed' : { 'runId' : string } };
export interface SharedCourse {
  'id' : string,
  'title' : string,
  'summary' : string,
}
export interface SharedEnrolledCourse {
  'id' : string,
  'messages' : Array<Message>,
  'completed' : boolean,
  'threadId' : string,
}
export interface SharedThreadRun {
  'job' : ThreadRunJob,
  'status' : RunStatus,
  'lastExecuted' : [] | [Time],
  'timestamp' : Time,
  'threadId' : string,
  'processing' : boolean,
  'runId' : string,
}
export interface SharedUser {
  'id' : string,
  'principal' : [] | [Principal],
  'fullname' : string,
  'claimableTokens' : bigint,
}
export interface SignUpFormInput {
  'emailAddress' : string,
  'pageSubmittedFrom' : string,
}
export interface SubmittedAnswer { 'option' : bigint, 'questionId' : string }
export type ThreadRunJob = { 'Question' : null } |
  { 'Message' : null };
export type Time = bigint;
export interface TransformArgs {
  'context' : Uint8Array | number[],
  'response' : HttpResponsePayload,
}
export interface _SERVICE extends Backend {}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
