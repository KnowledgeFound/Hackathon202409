import List "mo:base/List";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Nat16 "mo:base/Nat16";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import Time "mo:base/Time";
import Int "mo:base/Int";
import Char "mo:base/Char";
import AssocList "mo:base/AssocList";
import Buffer "mo:base/Buffer";
import Random "mo:base/Random";
import RBTree "mo:base/RBTree";
import HashMap "mo:base/HashMap";
import Array "mo:base/Array";

import FileTypes "./types/FileStorageTypes";
import Utils "./Utils";

import Types "./Types";

import Protocol "./Protocol";
import Blob "mo:base/Blob";

import Float "mo:base/Float";
import Request "request";
import Map "mo:map/Map";
import { hash } "mo:base/Hash";
import { thash; thash; nhash } "mo:map/Map";
import Vector "mo:vector";
import Error "mo:base/Error";
import Debug "mo:base/Debug";
import JSON "mo:json.mo";
import ICRC1 "mo:icrc1-types";
import { recurringTimer } = "mo:base/Timer";
import Prng "mo:prng";

shared ({ caller }) actor class Backend() {
  type Result<A, B> = Types.Result<A, B>;
  type SharedCourseWithResources = Types.SharedCourseWithResources;
  type SharedCourse = Types.SharedCourse;
  type User = Types.User;
  type SharedUser = Types.SharedUser;
  type Course = Types.Course;
  type Question = Types.Question;
  type ResourceType = Types.ResourceType;
  type QuestionOption = Types.QuestionOption;
  type Resource = Types.Resource;
  type EnrolledCourse = Types.EnrolledCourse;
  type SharedEnrolledCourse = Types.SharedEnrolledCourse;
  type SubmittedAnswer = Types.SubmittedAnswer;
  type Report = Types.Report;
  type RunStatus = Types.RunStatus;
  type ThreadRun = Types.ThreadRun;
  type SendMessageStatus = Types.SendMessageStatus;
  type Message = Types.Message;
  type SharedThreadRun = Types.SharedThreadRun;
  type EnrolledCourseProgress = Types.EnrolledCourseProgress;
  type ApiError = Types.ApiError;

  stable let members = Map.new<Text, User>();
  stable let courses = Map.new<Text, Course>();
  stable var threadRunQueue = Map.new<Text, ThreadRun>();
  stable var acls = Vector.new<Principal>();
  stable var courseThreads = Map.new<Nat, Text>();

  stable var owner = caller;

  var icrc1Actor_ : ICRC1.Service = actor ("mxzaz-hqaaa-aaaar-qaada-cai");
  stable var icrc1TokenCanisterId_ : Text = "invalid";

  stable var API_KEY : Text = "";
  stable var ASSISTANT_ID : Text = "";

  stable var seed : Nat32 = 0;
  let rng = Prng.SFC32a(); // or Prng.SFC32b()

  // Get current thread runs
  private func _getInProgressThreadRuns(threadId : Text) : [ThreadRun] {
    let runs = Map.filter(
      threadRunQueue,
      thash,
      func(k : Text, v : ThreadRun) : Bool {
        return v.threadId == threadId and v.status == #InProgress;
      },
    );
    return Iter.toArray(Map.vals(runs));
  };

  // Get course by id
  private func _getCourse(id : Text) : Course {
    Map.get(courses, thash, id);
  };

  // Generate a random number
  private func _getRandomNumber(range : Nat) : Nat {
    assert range > 0;
    rng.init(Nat32.fromIntWrap(Time.now()));
    let val = Nat32.toNat(rng.next());
    let randN = val * range / 4294967296;
    Debug.print("Generated number: " # debug_show (randN));
    return randN;
  };

  // Generate a random number with seed
  private func _getRandomNumberWithSeed(range : Nat) : Nat {
    assert range > 0;
    seed := seed + 1;
    rng.init(Nat32.fromIntWrap(Time.now()) + seed);
    let val = Nat32.toNat(rng.next());
    let randN = val * range / 4294967296;
    Debug.print("Generated number: " # debug_show (randN) # " With seed " # debug_show (seed));
    return randN;
  };

  // Generate x unique random numbers
  private func generateXUniqueRandomNumbers(x : Nat, range : Nat) : [Nat] {
    let vec = Vector.new<Nat>();
    var idx : Nat = 0;
    while (idx < x) {
      let n = _getRandomNumberWithSeed(range);
      let hasValue = Vector.forSome<Nat>(vec, func x { x == n });
      if (hasValue == false) {
        Vector.add(vec, n);
        idx := idx + 1;
      };
    };
    Vector.toArray(vec);
  };

  // Check if caller is owner
  private func _isOwner(p : Principal) : Bool {
    Principal.equal(owner, p);
  };

  // Check if caller is allowed
  private func _isAllowed(p : Principal) : Bool {
    if (_isOwner(p)) {
      return true;
    };
    for (k in Vector.vals(acls)) {
      if (Principal.equal(p, k)) {
        return true;
      };
    };
    return false;
  };

  // Generate random number
  public shared ({ caller }) func generateRandomNumber(range : Nat) : async Nat {
    await _getRandomNumber(range);
  };

  // Get acls
  public query func getAcls() : async [Principal] {
    Vector.toArray(acls);
  };

  // Get owner
  public query func getOwner() : async Principal {
    owner;
  };

  // Add acls
  public shared ({ caller }) func addAcls(p : Principal) : () {
    assert _isOwner(caller);
    Vector.add(acls, p);
  };

  // Remove acls
  public shared ({ caller }) func removeAcls(p : Principal) : async Result<(), ApiError> {
    assert _isOwner(caller);
    let newAcls = Vector.new<Principal>();
    if (Vector.contains<Principal>(acls, p, Principal.equal) == false) {
      return #err(#NotFound("Principal not found"));
    };
    for (k in Vector.vals(acls)) {
      if (Principal.notEqual(p, k)) {
        Vector.add(newAcls, k);
      };
    };
    acls := newAcls;
    #ok();
  };

  // get token canister id
  public query func get_icrc1_token_canister_id() : async Text {
    icrc1TokenCanisterId_;
  };

  // set icrc1 token canister
  public shared ({ caller }) func set_icrc1_token_canister(tokenCanisterId : Text) : async Result<(), ApiError> {
    if (not _isAllowed(caller)) return #err(#Unauthorized);

    let icrc1Canister = try {
      #ok(await Utils.createIcrcActor(tokenCanisterId));
    } catch e #err(e);

    switch (icrc1Canister) {
      case (#ok(icrc1Actor)) {
        icrc1Actor_ := icrc1Actor;
        icrc1TokenCanisterId_ := tokenCanisterId;
        #ok;
      };
      case (#err(e)) {
        #err(#Other("Failed to instantiate icrc1 token canister from given id(" # tokenCanisterId # ") for reason " # Error.message(e)));
      };
    };
  };

  public shared ({ caller }) func changeOwner(newOwner : Text) {
    if (not _isOwner(caller)) return #err(#Unauthorized);
    owner := Principal.fromText(newOwner);
  };

  // Set api key
  public shared ({ caller }) func changeApiKey(apiKey : Text) {
    if (not _isOwner(caller)) return #err(#Unauthorized);
    API_KEY := apiKey;
  };

  // Set assistant id
  public shared ({ caller }) func setAssistantId(id : Text) {
    if (not _isOwner(caller)) return #err(#Unauthorized);
    ASSISTANT_ID := id;
  };

  // List all courses
  public query func listCourses() : async [SharedCourse] {
    let filteredCourses = Vector.new<Types.SharedCourse>();
    for (course in Map.vals(courses)) {
      let sharedCourse = {
        id = course.id;
        title = course.title;
        summary = course.summary;
      };
      Vector.add(filteredCourses, sharedCourse);
    };
    return Vector.toArray(filteredCourses);
  };

  // Get user enrolled course details
  public query func getUserEnrolledCourse(courseId : Text, userId : Text) : async Result<SharedEnrolledCourse, ApiError> {
    let user = Map.get(members, thash, userId);
    switch (user) {
      case (?member) {
        let course = _getCourse(courseId);
        switch (course) {
          case (?c) {
            for (_course in Vector.vals(member.enrolledCourses)) {
              if (_course.id == c.id) {
                let sharedCourse = {
                  id = _course.id;
                  threadId = _course.threadId;
                  completed = _course.completed;
                  messages = Vector.toArray(_course.messages);
                };
                return #ok(sharedCourse);
              };
            };
            return #err(#NotFount("Course not enrolled"));
          };
          case (null) {
            return #err(#NotFound("Course " # Nat.toText(courseId) # " not found"));
          };
        };
      };
      case (null) {
        return #err(#NotFound("User not found"));
      };
    };
  };

  // Get course resources
  public query func getCourseResources(courseId : Text) : async Result<[Resource], ApiError> {
    let course = _getCourse(courseId);
    switch (course) {
      case (?c) {
        return #ok(Vector.toArray(c.resources));
      };
      case (null) {
        return #err(#NotFound("Course not found"));
      };
    };
  };

  // Get random course questions
  public query func getRandomCourseQuestions(courseId : Text, questionCount : Nat) : async Result<[Question], ApiError> {
    let course = _getCourse(courseId);
    switch (course) {
      case (?c) {
        let questions = Vector.new<Question>();
        let len = Vector.size(c.questions);

        if (len == 0) {
          return #err(#Other("Course has no questions"));
        };
        if (questionCount > len) {
          return #err(#Other("Question count " # Nat.toText(questionCount) # " is greater than the number of questions " # Nat.toText(len)));
        };

        let choices = generateXUniqueRandomNumbers(questionCount, len);

        for (number in choices.vals()) {
          Debug.print("Random: " # debug_show (number));
          let question = Vector.get(c.questions, number);
          Vector.add(questions, question);
        };

        return #ok(Vector.toArray(questions));
      };
      case (null) {
        return #err(#NotFound("Course not found"));
      };
    };
  };

  // Register a new user
  public shared ({ caller }) func registerUser(fullname : Text) : async Result<Text, ApiError> {
    let userId = Utils.hashText(fullname);
    let user = Map.get(members, thash, userId);
    let userP : ?Principal = null;

    if (not Principal.isAnonymous(caller)) {
      userP := ?caller;
    };

    switch (user) {
      case (?_) {
        return #err(#Other("User already registered"));
      };
      case (null) {
        let newUser = {
          id = userId;
          fullname = fullname;
          principal = userP;
          claimableTokens = 0;
          enrolledCourses = Vector.new<EnrolledCourse>();
        };
        Map.set(members, thash, caller, newUser);
        nextUserId := nextUserId + 1;
        return #ok("User registered successfully");
      };
    };
  };

  // Get user profile
  public query func getProfile(userId : Text) : async Result<SharedUser, ApiError> {
    let user = Map.get(members, thash, userId);
    switch (user) {
      case (?member) {
        let sharedUser = {
          id = member.id;
          fullname = member.fullname;
          principal = member.principal;
          claimableTokens = member.claimableTokens;
        };
        return #ok(sharedUser);
      };
      case (null) {
        return #err(#NotFound("User not found"));
      };
    };
  };

  // Enroll in a course
  public shared func enrollCourse(courseId : Text, userId : Text) : async Result<Text, ApiError> {
    let user = Map.get(members, thash, caller);
    switch (user) {
      case (?member) {
        let course = _getCourse(courseId);
        switch (course) {
          case (?c) {
            for (_course in Vector.vals(member.enrolledCourses)) {
              if (_course.id == c.id) {
                return #ok("Course already enrolled");
              };
            };

            // Create thread
            let headers : ?[Types.HttpHeader] = ?[
              {
                name = "Authorization";
                value = "Bearer " # API_KEY;
              },
              {
                name = "OpenAI-Beta";
                value = "assistants=v2";
              },
              {
                name = "x-forwarded-host";
                value = "api.openai.com";
              },
            ];

            let response = await Request.post(
              "https://idempotent-proxy-cf-worker.zensh.workers.dev/v1/threads",
              null,
              transform,
              headers,
            );

            if (response.status != 200) {
              return #err(#Other("Failed to create thread"));
            };

            var threadId = "";

            switch (response.body) {
              case (#Object(v)) {
                label findId for ((k, v) in v.vals()) {
                  if (k == "id") {
                    switch (v) {
                      case (#String(v)) {
                        threadId := v;
                        break findId;
                      };
                      case (_) {
                        return #err(#Other("Json parse failed"));
                      };
                    };
                  };
                };
              };
              case (_) {
                return #err(#Other("Json parse failed"));
              };
            };

            if (threadId == "") {
              return #err(#Other("Create thread failed"));
            };

            let messages = Vector.new<Message>();
            let enrolledCourse = {
              id = c.id;
              completed = false;
              threadId = threadId;
              messages = messages;
            };
            Vector.add(member.enrolledCourses, enrolledCourse);

            // Update course enrolled count
            let updatedCourse = {
              id = c.id;
              title = c.title;
              summary = c.summary;
              resources = c.resources;
              questions = c.questions;
            };
            Vector.put(courses, c.id, updatedCourse);
            return #ok("Course enrolled successfully");
          };
          case (null) {
            return #err(#NotFound("Course not found"));
          };
        };
      };
      case (null) {
        return #err(#NotFound("User not found"));
      };
    };
  };

  // Create a course
  public shared ({ caller }) func createCourse(title : Text, summary : Text) : async Result<Text, ApiError> {
    if (not _isAllowed(caller)) return #err(#Unauthorized);

    let resources = Vector.new<Resource>();
    let questions = Vector.new<Question>();
    let courseId = await Utils.uuid();
    let course = {
      id = courseId;
      title = title;
      summary = summary;
      resources = resources;
      questions = questions;
    };

    Map.set(courses, thash, courseId, course);
    #ok(courseId);
  };

  // Create new resource for course
  public shared ({ caller }) func createResource(courseId : Text, title : Text, url : Text, rType : ResourceType) : async Result<Text, ApiError> {
    if (not _isAllowed(caller)) return #err(#Unauthorized);
    let course = _getCourse(courseId);
    switch (course) {
      case (?c) {
        let resource = {
          id = await Utils.uuid();
          title = title;
          url = url;
          rType = rType;
        };
        Vector.add(c.resources, resource);
        let updatedCourse = {
          id = c.id;
          title = c.title;
          summary = c.summary;
          resources = c.resources;
          questions = c.questions;
        };
        Map.set(courses, thash, c.id, updatedCourse);
        return #ok("Resource created successfully");
      };
      case (null) {
        return #err(#NotFound("Course not found"));
      };
    };
  };

  // Remove resource from course
  public shared ({ caller }) func removeResource(courseId : Text, resourceId : Nat) : async Result<(), ApiError> {
    if (not _isAllowed(caller)) return #err(#Unauthorized);
    let course = _getCourse(courseId);
    switch (course) {
      case (?c) {
        let contains = Utils.vecContains(#resource(c.resources), resourceId);
        if (contains == false) {
          return #err(#NotFound("Resource not found"));
        };
        let newResources = Vector.new<Resource>();
        for (k in Vector.vals(c.resources)) {
          if (k.id != resourceId) {
            Vector.add(newResources, k);
          };
        };
        let updatedCourse = {
          id = c.id;
          title = c.title;
          summary = c.summary;
          resources = newResources;
          questions = c.questions;
        };
        Map.set(courses, thash, c.id, updatedCourse);
      };
      case (null) {
        return #err(#NotFound("Course not found"));
      };
    };
    #ok();
  };

  // Update course details
  public shared ({ caller }) func updateCourse(courseId : Text, title : Text, summary : Text) : async Result<Text, ApiError> {
    if (not _isAllowed(caller)) return #err(#Unauthorized);
    let course = _getCourse(courseId);
    switch (course) {
      case (?c) {
        let updatedCourse = {
          id = c.id;
          title = title;
          summary = summary;
          resources = c.resources;
          questions = c.questions;
        };
        Map.set(courses, thash, c.id, updatedCourse);
        return #ok("Course updated successfully");
      };
      case (null) {
        return #err(#NotFound("Course not found"));
      };
    };
  };

  // Add a question to a course
  public shared ({ caller }) func addQuestion(courseId : Text, data : Question) : async Result<Text, ApiError> {
    if (not _isAllowed(caller)) return #err(#Unauthorized);
    let course = _getCourse(courseId);
    switch (course) {
      case (?c) {
        let question = {
          id = c.nextQuestionId;
          options = data.options;
          correctOption = data.correctOption;
          description = data.description;
        };
        Vector.add(c.questions, question);
        let updatedCourse = {
          id = c.id;
          title = c.title;
          summary = c.summary;
          resources = c.resources;
          questions = c.questions;
        };
        Map.set(courses, thash, c.id, updatedCourse);
        return #ok("Question added successfully");
      };
      case (null) {
        return #err(#NotFound("Course not found"));
      };
    };
  };

  // Remove question from a course
  public shared ({ caller }) func removeQuestion(courseId : Text, questionId : Nat) : async Result<(), ApiError> {
    if (not _isAllowed(caller)) return #err(#Unauthorized);
    let course = _getCourse(courseId);
    switch (course) {
      case (?c) {
        let contains = Utils.vecContains(#question(c.questions), questionId);
        if (contains == false) {
          return #err(#NotFound("Question not found"));
        };
        let newQuestions = Vector.new<Question>();
        for (k in Vector.vals(c.questions)) {
          if (k.id != questionId) {
            Vector.add<Question>(newQuestions, k);
          };
        };
        let updatedCourse = {
          id = c.id;
          title = c.title;
          summary = c.summary;
          resources = c.resources;
          questions = newQuestions;
        };
        Map.set(courses, thash, c.id, updatedCourse);
      };
      case (null) {
        return #err("Course not found");
      };
    };
    #ok();
  };

  // TODO: Submit questions attempt
  public shared ({ caller }) func submitQuestionsAttempt(courseId : Text, answers : [SubmittedAnswer], userId : Text) : async Result<Text, ApiError> {
    let user = Map.get(members, thash, userId);
    switch (user) {
      case (?member) {
        let course = _getCourse(courseId);
        switch (course) {
          case (?c) {

            var enrolledCourse : ?EnrolledCourse = null;

            label findCourse for (_course in Vector.vals(member.enrolledCourses)) {
              if (_course.id == c.id) {
                enrolledCourse := ?_course;
                break findCourse;
              };
            };

            switch (enrolledCourse) {
              case (null) {
                return #err(#NotFound("Course not enrolled"));
              };
              case (?enrolledCourse) {

                let len = Vector.size(c.questions);
                if (len == 0) {
                  return #err(#Other("Course has no questions"));
                };
                if (Array.size(answers) > len) {
                  return #err(#Other("Number of answers is greater than the number of questions"));
                };

                var correctCount = 0;
                for (answer in answers.vals()) {
                  for (question in Vector.vals(c.questions)) {
                    if (question.id == answer.questionId) {
                      if (question.correctOption == answer.option) {
                        correctCount += 1;
                      };
                    };
                  };
                };

                if (correctCount != Array.size(answers)) {
                  return #err(#Other("You did not get all the questions, Try again"));
                };

                var enrolledCourseIndex = 0;
                label findCourse for (i in Iter.range(0, Vector.size(member.enrolledCourses))) {
                  if (Vector.get(member.enrolledCourses, i).id == c.id) {
                    enrolledCourseIndex := i;
                    break findCourse;
                  };
                };

                let previousValue = Vector.get(member.enrolledCourses, enrolledCourseIndex);
                if (previousValue.completed) {
                  return #err(#Other("You have already completed this course before"));
                };

                let icrc1Canister = try {
                  #ok(await Utils.createIcrcActor(icrc1TokenCanisterId_));
                } catch e #err(e);

                switch (icrc1Canister) {
                  case (#ok(icrc1Actor)) {
                    // Transfer tokens to user
                    // Make the icrc1 intercanister transfer call, catching if error'd:
                    let response : Result<ICRC1.TransferResult, Text> = try {
                      let decimal = 100000000;
                      #ok(await icrc1Actor.icrc1_transfer({ amount = 10 * decimal; created_at_time = null; from_subaccount = null; fee = null; memo = null; to = { owner = caller; subaccount = null } }));
                    } catch (e) {
                      #err(Error.message(e));
                    };

                    // Parse the results of the icrc1 intercansiter transfer call:
                    switch (response) {
                      case (#ok(transferResult)) {
                        switch (transferResult) {
                          case (#Ok _) {
                            // Updated enrolled course to completed
                            let updatedECourse : EnrolledCourse = {
                              id = enrolledCourse.id;
                              threadId = enrolledCourse.threadId;
                              completed = true;
                              messages = enrolledCourse.messages;
                            };
                            Vector.put(member.enrolledCourses, enrolledCourseIndex, updatedECourse);
                            // Update user object
                            Map.set(members, thash, caller, member);
                            return #ok("You have successfully completed the course");
                          };
                          case (#Err _) #err(
                            #Other("The icrc1 transfer call could not be completed as requested.")
                          );
                        };
                      };
                      case (#err(k)) {
                        #err(
                          #Other("The intercanister icrc1 transfer call caught an error: " # k)
                        );
                      };
                    };
                  };
                  case (#err(_)) {
                    #err(#Other("Internal transfer error"));
                  };
                };

              };
            };
          };
          case (null) {
            return #err(#NotFound("Course not found"));
          };
        };
      };
      case (null) {
        return #err(#NotFound("User not found"));
      };
    };
  };

  // Vector Database
  stable var userMemoryVectorsStorageStable : [(Principal, [Types.MemoryVector])] = [];
  var userMemoryVectorsStorage : HashMap.HashMap<Principal, [Types.MemoryVector]> = HashMap.HashMap(0, Principal.equal, Principal.hash);

  private func putUserMemoryVectors(user : Principal, memoryVectors : [Types.MemoryVector]) : Bool {
    userMemoryVectorsStorage.put(user, memoryVectors);
    return true;
  };

  private func getUserMemoryVectors(user : Principal) : ?[Types.MemoryVector] {
    switch (userMemoryVectorsStorage.get(user)) {
      case (null) { return null };
      case (?memoryVectors) { return ?memoryVectors };
    };
  };

  public shared ({ caller }) func store_user_chats_memory_vectors(memoryVectors : [Types.MemoryVector]) : async Types.MemoryVectorsStoredResult {
    // don't allow anonymous Principal
    if (Principal.isAnonymous(caller)) {
      return #Err(#Unauthorized);
    };

    let result = putUserMemoryVectors(caller, memoryVectors);

    return #Ok(result);
  };

  public shared query ({ caller }) func get_caller_memory_vectors() : async Types.MemoryVectorsResult {
    // don't allow anonymous Principal
    if (Principal.isAnonymous(caller)) {
      return #Err(#Unauthorized);
    };

    switch (getUserMemoryVectors(caller)) {
      case (null) { return #Err(#Unauthorized) };
      case (?memoryVectors) { return #Ok(memoryVectors) };
    };
  };

  public shared query ({ caller }) func check_caller_has_memory_vectors_entry() : async Types.MemoryVectorsCheckResult {
    // don't allow anonymous Principal
    if (Principal.isAnonymous(caller)) {
      return #Err(#Unauthorized);
    };

    switch (getUserMemoryVectors(caller)) {
      case (null) { return #Err(#Unauthorized) };
      case (?memoryVectors) { return #Ok(true) };
    };
  };

  // Email Signups from Website
  stable var emailSubscribersStorageStable : [(Text, Types.EmailSubscriber)] = [];
  var emailSubscribersStorage : HashMap.HashMap<Text, Types.EmailSubscriber> = HashMap.HashMap(0, Text.equal, Text.hash);

  // Add a user as new email subscriber
  private func putEmailSubscriber(emailSubscriber : Types.EmailSubscriber) : Text {
    emailSubscribersStorage.put(emailSubscriber.emailAddress, emailSubscriber);
    return emailSubscriber.emailAddress;
  };

  // Retrieve an email subscriber by email address
  private func getEmailSubscriber(emailAddress : Text) : ?Types.EmailSubscriber {
    let result = emailSubscribersStorage.get(emailAddress);
    return result;
  };

  // User can submit a form to sign up for email updates
  // For now, we only capture the email address provided by the user and on which page they submitted the form
  public func submit_signup_form(submittedSignUpForm : Types.SignUpFormInput) : async Text {
    switch (getEmailSubscriber(submittedSignUpForm.emailAddress)) {
      case null {
        // New subscriber
        let emailSubscriber : Types.EmailSubscriber = {
          emailAddress : Text = submittedSignUpForm.emailAddress;
          pageSubmittedFrom : Text = submittedSignUpForm.pageSubmittedFrom;
          subscribedAt : Nat64 = Nat64.fromNat(Int.abs(Time.now()));
        };
        let result = putEmailSubscriber(emailSubscriber);
        if (result != emailSubscriber.emailAddress) {
          return "There was an error signing up. Please try again.";
        };
        return "Successfully signed up!";
      };
      case _ { return "Already signed up!" };
    };
  };

  // Function for custodian to get all email subscribers
  public shared query ({ caller }) func get_email_subscribers() : async [(Text, Types.EmailSubscriber)] {
    // don't allow anonymous Principal
    if (Principal.isAnonymous(caller)) {
      return [];
    };
    // Only Principals registered as custodians can access this function
    if (List.some(custodians, func(custodian : Principal) : Bool { custodian == caller })) {
      return Iter.toArray(emailSubscribersStorage.entries());
    };
    return [];
  };

  // Function for custodian to delete an email subscriber
  public shared ({ caller }) func delete_email_subscriber(emailAddress : Text) : async Bool {
    // don't allow anonymous Principal
    if (Principal.isAnonymous(caller)) {
      return false;
    };
    // Only Principals registered as custodians can access this function
    if (List.some(custodians, func(custodian : Principal) : Bool { custodian == caller })) {
      emailSubscribersStorage.delete(emailAddress);
      return true;
    };
    return false;
  };

  // AI-for-education experiences (Knowledge Foundation hackathon)
  var aiForEducationExperiencesStable : [Types.EducationExperience] = [
    // Oxford entry
    {
      id = "oxford";
      title = "Oxford Hackathon Entry";
      creator = "Arjaan & Patrick";
      shortDescription = "This was the entry we put in at the Oxford hackathon";
      longDescription = "It was the first AI for education experience we created and it's the inspiration for more solutions to come (including this hackathon). It's based on the same approach DeVinci is taking: run the AI model on the user's device. It includes the UN anti-corruption resources as in-browser vector databases. As an extra, we built a first pipeline to easily create an on-chain LLM (on the Internet Computer).";
      note = "Give it a try and think about how to improve it :)";
      isStandaloneApp = true;
      standaloneAppUrl = ?"https://6tht4-syaaa-aaaai-acriq-cai.icp0.io/#/learn";
      experienceType = null;
      aiModelIdentifier = null;
      databaseToInclude = #None;
      databaseIdentifier = null;
    },
    // DeVinci
    {
      id = "devinci";
      title = "DeVinci AI Chat App";
      creator = "Nuno & Patrick";
      shortDescription = "This is the first end-to-end-decentralized AI chat app and the core of the codebase for this hackathon";
      longDescription = "DeVinci is the fully private, end-to-end-decentralized AI chat app served from the Internet Computer. AI models run directly on the user's device so no data needs to leave the device and you can even use it offline.";
      note = "Choose your favorite open-source Large Language Model and chat with it.";
      isStandaloneApp = true;
      standaloneAppUrl = ?"https://x6occ-biaaa-aaaai-acqzq-cai.icp0.io/";
      experienceType = null;
      aiModelIdentifier = null;
      databaseToInclude = #None;
      databaseIdentifier = null;
    },
  ];

  public shared query ({ caller }) func get_education_experiences() : async [Types.EducationExperience] {
    return aiForEducationExperiencesStable;
  };

  // Upgrade Hooks
  system func preupgrade() {
    userChatsStorageStable := Iter.toArray(userChatsStorage.entries());
    userSettingsStorageStable := Iter.toArray(userSettingsStorage.entries());
    chatsStorageStable := Iter.toArray(chatsStorage.entries());
    emailSubscribersStorageStable := Iter.toArray(emailSubscribersStorage.entries());
    userMemoryVectorsStorageStable := Iter.toArray(userMemoryVectorsStorage.entries());
  };

  system func postupgrade() {
    userChatsStorage := HashMap.fromIter(Iter.fromArray(userChatsStorageStable), userChatsStorageStable.size(), Principal.equal, Principal.hash);
    userChatsStorageStable := [];
    userSettingsStorage := HashMap.fromIter(Iter.fromArray(userSettingsStorageStable), userSettingsStorageStable.size(), Principal.equal, Principal.hash);
    userSettingsStorageStable := [];
    chatsStorage := HashMap.fromIter(Iter.fromArray(chatsStorageStable), chatsStorageStable.size(), Text.equal, Text.hash);
    chatsStorageStable := [];
    emailSubscribersStorage := HashMap.fromIter(Iter.fromArray(emailSubscribersStorageStable), emailSubscribersStorageStable.size(), Text.equal, Text.hash);
    emailSubscribersStorageStable := [];
    userMemoryVectorsStorage := HashMap.fromIter(Iter.fromArray(userMemoryVectorsStorageStable), userMemoryVectorsStorageStable.size(), Principal.equal, Principal.hash);
    userMemoryVectorsStorageStable := [];
  };
};
