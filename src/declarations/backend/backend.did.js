export const idlFactory = ({ IDL }) => {
  const QuestionOption = IDL.Record({
    'option' : IDL.Nat,
    'description' : IDL.Text,
  });
  const Question = IDL.Record({
    'id' : IDL.Text,
    'correctOption' : IDL.Nat,
    'description' : IDL.Text,
    'options' : IDL.Vec(QuestionOption),
  });
  const ApiError = IDL.Variant({
    'ZeroAddress' : IDL.Null,
    'NotFound' : IDL.Text,
    'InvalidTokenId' : IDL.Null,
    'Unauthorized' : IDL.Null,
    'Other' : IDL.Text,
  });
  const Result = IDL.Variant({ 'ok' : IDL.Text, 'err' : ApiError });
  const Result_2 = IDL.Variant({ 'ok' : IDL.Null, 'err' : ApiError });
  const Result_1 = IDL.Variant({ 'ok' : IDL.Bool, 'err' : ApiError });
  const ResourceType__1 = IDL.Variant({
    'Book' : IDL.Null,
    'Article' : IDL.Null,
    'Slides' : IDL.Null,
    'Video' : IDL.Null,
  });
  const SendMessageStatus = IDL.Variant({
    'Failed' : IDL.Text,
    'ThreadLock' : IDL.Record({ 'runId' : IDL.Text }),
    'Completed' : IDL.Record({ 'runId' : IDL.Text }),
  });
  const Result_3 = IDL.Variant({
    'ok' : SendMessageStatus,
    'err' : SendMessageStatus,
  });
  const Result_7 = IDL.Variant({ 'ok' : IDL.Vec(Question), 'err' : ApiError });
  const ResourceType = IDL.Variant({
    'Book' : IDL.Null,
    'Article' : IDL.Null,
    'Slides' : IDL.Null,
    'Video' : IDL.Null,
  });
  const Resource = IDL.Record({
    'id' : IDL.Text,
    'url' : IDL.Text,
    'title' : IDL.Text,
    'rType' : ResourceType,
  });
  const Result_10 = IDL.Variant({ 'ok' : IDL.Vec(Resource), 'err' : ApiError });
  const SharedUser = IDL.Record({
    'id' : IDL.Text,
    'principal' : IDL.Opt(IDL.Principal),
    'fullname' : IDL.Text,
    'claimableTokens' : IDL.Nat,
  });
  const Result_9 = IDL.Variant({ 'ok' : SharedUser, 'err' : ApiError });
  const MessgeType = IDL.Variant({ 'System' : IDL.Null, 'User' : IDL.Null });
  const Message__1 = IDL.Record({
    'content' : IDL.Text,
    'role' : MessgeType,
    'runId' : IDL.Opt(IDL.Text),
  });
  const Result_8 = IDL.Variant({ 'ok' : Message__1, 'err' : ApiError });
  const RunStatus__1 = IDL.Variant({
    'Failed' : IDL.Null,
    'Cancelled' : IDL.Null,
    'InProgress' : IDL.Null,
    'Completed' : IDL.Null,
    'Expired' : IDL.Null,
  });
  const Result_6 = IDL.Variant({ 'ok' : RunStatus__1, 'err' : ApiError });
  const ThreadRunJob = IDL.Variant({
    'Question' : IDL.Null,
    'Message' : IDL.Null,
  });
  const RunStatus = IDL.Variant({
    'Failed' : IDL.Null,
    'Cancelled' : IDL.Null,
    'InProgress' : IDL.Null,
    'Completed' : IDL.Null,
    'Expired' : IDL.Null,
  });
  const Time = IDL.Int;
  const SharedThreadRun = IDL.Record({
    'job' : ThreadRunJob,
    'status' : RunStatus,
    'lastExecuted' : IDL.Opt(Time),
    'timestamp' : Time,
    'threadId' : IDL.Text,
    'processing' : IDL.Bool,
    'runId' : IDL.Text,
  });
  const Message = IDL.Record({
    'content' : IDL.Text,
    'role' : MessgeType,
    'runId' : IDL.Opt(IDL.Text),
  });
  const SharedEnrolledCourse = IDL.Record({
    'id' : IDL.Text,
    'messages' : IDL.Vec(Message),
    'completed' : IDL.Bool,
    'threadId' : IDL.Text,
  });
  const Result_5 = IDL.Variant({
    'ok' : SharedEnrolledCourse,
    'err' : ApiError,
  });
  const MemoryVectorMetadata = IDL.Record({ 'id' : IDL.Int });
  const MemoryVector = IDL.Record({
    'content' : IDL.Text,
    'metadata' : MemoryVectorMetadata,
    'embedding' : IDL.Vec(IDL.Float64),
  });
  const Result_4 = IDL.Variant({
    'ok' : IDL.Vec(MemoryVector),
    'err' : ApiError,
  });
  const DatabaseToInclude = IDL.Variant({
    'Local' : IDL.Null,
    'None' : IDL.Null,
    'External' : IDL.Null,
  });
  const ExperienceType = IDL.Variant({
    'Onchain' : IDL.Null,
    'Offchain' : IDL.Null,
    'Ondevice' : IDL.Null,
  });
  const EducationExperience = IDL.Record({
    'id' : IDL.Text,
    'isStandaloneApp' : IDL.Bool,
    'title' : IDL.Text,
    'creator' : IDL.Text,
    'note' : IDL.Text,
    'databaseToInclude' : DatabaseToInclude,
    'shortDescription' : IDL.Text,
    'standaloneAppUrl' : IDL.Opt(IDL.Text),
    'databaseIdentifier' : IDL.Opt(IDL.Text),
    'experienceType' : IDL.Opt(ExperienceType),
    'aiModelIdentifier' : IDL.Opt(IDL.Text),
    'longDescription' : IDL.Text,
  });
  const EmailSubscriber = IDL.Record({
    'subscribedAt' : IDL.Nat64,
    'emailAddress' : IDL.Text,
    'pageSubmittedFrom' : IDL.Text,
  });
  const SharedCourse = IDL.Record({
    'id' : IDL.Text,
    'title' : IDL.Text,
    'summary' : IDL.Text,
  });
  const SubmittedAnswer = IDL.Record({
    'option' : IDL.Nat,
    'questionId' : IDL.Text,
  });
  const SignUpFormInput = IDL.Record({
    'emailAddress' : IDL.Text,
    'pageSubmittedFrom' : IDL.Text,
  });
  const HttpHeader = IDL.Record({ 'value' : IDL.Text, 'name' : IDL.Text });
  const HttpResponsePayload = IDL.Record({
    'status' : IDL.Nat,
    'body' : IDL.Vec(IDL.Nat8),
    'headers' : IDL.Vec(HttpHeader),
  });
  const TransformArgs = IDL.Record({
    'context' : IDL.Vec(IDL.Nat8),
    'response' : HttpResponsePayload,
  });
  const CanisterHttpResponsePayload = IDL.Record({
    'status' : IDL.Nat,
    'body' : IDL.Vec(IDL.Nat8),
    'headers' : IDL.Vec(HttpHeader),
  });
  const Backend = IDL.Service({
    'addAcls' : IDL.Func([IDL.Principal], [], ['oneway']),
    'addQuestion' : IDL.Func([IDL.Text, Question], [Result], []),
    'changeApiKey' : IDL.Func([IDL.Text], [Result_2], []),
    'changeOwner' : IDL.Func([IDL.Text], [Result_2], []),
    'check_course_has_memory_vectors_entry' : IDL.Func(
        [IDL.Text],
        [Result_1],
        ['query'],
      ),
    'createCourse' : IDL.Func([IDL.Text, IDL.Text], [Result], []),
    'createResource' : IDL.Func(
        [IDL.Text, IDL.Text, IDL.Text, ResourceType__1],
        [Result],
        [],
      ),
    'delete_email_subscriber' : IDL.Func([IDL.Text], [IDL.Bool], []),
    'enrollCourse' : IDL.Func([IDL.Text, IDL.Text], [Result], []),
    'generateQuestionsForCourse' : IDL.Func([IDL.Text], [Result_3], []),
    'generateRandomNumber' : IDL.Func([IDL.Nat], [IDL.Nat], []),
    'getAcls' : IDL.Func([], [IDL.Vec(IDL.Principal)], ['query']),
    'getCourseQuestions' : IDL.Func([IDL.Text], [Result_7], ['query']),
    'getCourseResources' : IDL.Func([IDL.Text], [Result_10], ['query']),
    'getOwner' : IDL.Func([], [IDL.Principal], ['query']),
    'getProfile' : IDL.Func([IDL.Text], [Result_9], ['query']),
    'getRandomCourseQuestions' : IDL.Func(
        [IDL.Text, IDL.Nat],
        [Result_7],
        ['query'],
      ),
    'getRunMessage' : IDL.Func([IDL.Text, IDL.Text], [Result_8], []),
    'getRunQuestions' : IDL.Func([IDL.Text], [Result_7], []),
    'getRunStatus' : IDL.Func([IDL.Text], [Result_6], ['query']),
    'getRunsInQueue' : IDL.Func([], [IDL.Vec(SharedThreadRun)], ['query']),
    'getUserEnrolledCourse' : IDL.Func(
        [IDL.Text, IDL.Text],
        [Result_5],
        ['query'],
      ),
    'get_course_memory_vectors' : IDL.Func([IDL.Text], [Result_4], ['query']),
    'get_education_experiences' : IDL.Func(
        [],
        [IDL.Vec(EducationExperience)],
        ['query'],
      ),
    'get_email_subscribers' : IDL.Func(
        [],
        [IDL.Vec(IDL.Tuple(IDL.Text, EmailSubscriber))],
        ['query'],
      ),
    'get_icrc1_token_canister_id' : IDL.Func([], [IDL.Text], ['query']),
    'listCourses' : IDL.Func([], [IDL.Vec(SharedCourse)], ['query']),
    'registerUser' : IDL.Func([IDL.Text], [Result], []),
    'removeAcls' : IDL.Func([IDL.Principal], [Result_2], []),
    'removeQuestion' : IDL.Func([IDL.Text, IDL.Text], [Result_2], []),
    'removeResource' : IDL.Func([IDL.Text, IDL.Text], [Result_2], []),
    'sendMessage' : IDL.Func([IDL.Text, IDL.Text, IDL.Text], [Result_3], []),
    'setAssistantId' : IDL.Func([IDL.Text], [Result_2], []),
    'setRunProcess' : IDL.Func([IDL.Text, IDL.Bool], [Result_2], []),
    'set_icrc1_token_canister' : IDL.Func([IDL.Text], [Result_2], []),
    'store_course_memory_vectors' : IDL.Func(
        [IDL.Text, IDL.Vec(MemoryVector)],
        [Result_1],
        [],
      ),
    'submitQuestionsAttempt' : IDL.Func(
        [IDL.Text, IDL.Vec(SubmittedAnswer), IDL.Text],
        [Result],
        [],
      ),
    'submit_signup_form' : IDL.Func([SignUpFormInput], [IDL.Text], []),
    'transform' : IDL.Func(
        [TransformArgs],
        [CanisterHttpResponsePayload],
        ['query'],
      ),
    'updateCourse' : IDL.Func([IDL.Text, IDL.Text, IDL.Text], [Result], []),
  });
  return Backend;
};
export const init = ({ IDL }) => { return []; };
