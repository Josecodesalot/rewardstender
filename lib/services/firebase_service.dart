import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rewards_network_shared/models/clerk.dart';
import 'package:rewards_network_shared/models/auth_fields.dart';
import 'package:rewards_network_shared/models/client_state.dart';
import 'package:rewards_network_shared/models/response.dart';
import 'package:rewards_network_shared/models/user_type.dart';
import 'package:rewards_network_shared/services/auth_service.dart';
import 'package:rewards_network_shared/models/user_status.dart';
import 'package:rewardstender/Utils/Const.dart';


class FirebaseAuthService implements AuthService<ClerkAccount>{
  FirebaseAuth auth;
  FirebaseDatabase database;

  FirebaseAuthService({@required this.auth, @required this.database});

  DatabaseReference get ref => database.reference();

  DatabaseReference userRef(String uid) => ref.child(Const.usersfield).child(uid);

  bool get hasUid => auth?.currentUser?.uid == null ? false : true;

  static const UserType expectedUserType = UserType.clerk;

  UserStatus authStatus() {
    if (hasUid) {
      if (auth.currentUser.isAnonymous) {
        return UserStatus.anon;
      }
      if (auth.currentUser.emailVerified) {
        return UserStatus.signedInWeak;
      }
    }
    return UserStatus.signedOut;
  }

  @override
  Future<Response<UserState<ClerkAccount>>> checkAuthStatus() async {
    try {
      //notSignedIn
      if (auth.currentUser == null) {
        return Response<UserState<ClerkAccount>>(
          data: UserState<ClerkAccount>(
            status: UserStatus.signedOut,
          ),
        );
      } else {
        //signed in but how?

        final clientState = UserState<ClerkAccount>(
            user: ClerkAccount(
              name: auth.currentUser.displayName,
              email: auth.currentUser.email,
              uid: auth.currentUser.uid,
            ),
            status: UserStatus.signedInWeak);

        final isAnonymous = auth.currentUser.isAnonymous;
        final isVerified = auth.currentUser.emailVerified;

        if (isAnonymous) {
          return Response<UserState<ClerkAccount>>(
            data: clientState.copyWith(
              status: UserStatus.anon,
            ),
          );
        } else if (isVerified) {
          final databaseResponse = await userRef(clientState.user.uid).once();

          final clerk = ClerkAccount.fromMap(Map.from(databaseResponse.value));
          if (clerk.userType != expectedUserType) {
            throw(WrongAccountException(clerk.userType));
          }

          return Response<UserState<ClerkAccount>>(
            data: UserState(user: clerk, status: UserStatus.signedIn),
          );
        } else {
          final databaseResponse = await userRef(clientState.user.uid).once();
          final _fetchedGuest = ClerkAccount.fromMap(
            Map.from(databaseResponse.value),
          );
          return Response<UserState<ClerkAccount>>(
            data:
                UserState<ClerkAccount>(user: _fetchedGuest, status: UserStatus.signedInWeak),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      return Response<UserState<ClerkAccount>>(
        data: UserState<ClerkAccount>(status: UserStatus.signedOut),
        error: ResponseError('${e.message}'),
      );
    } on WrongAccountException catch(e){
      return Response<UserState<ClerkAccount>>(
          data: UserState<ClerkAccount>(
            status: UserStatus.signedOut,
            user: ClerkAccount(),
          ),
          error: ResponseError(e.message),
      );
    }
  }

  @override
  Future<Response<UserState<ClerkAccount>>> signIn(AuthFields authFields) async {
    try {
      final result = await auth.signInWithEmailAndPassword(
          email: authFields.email, password: authFields.password);
      final verified = result.user.emailVerified;
      final snap = await userRef(result.user.uid).once();
      final user = ClerkAccount.fromMap(
        Map.from(snap.value),
      );

      final userState = UserState<ClerkAccount>(user: user);
      if (userState.user.userType != expectedUserType) {
        throw(WrongAccountException(userState.user.userType));
      }

      return Response<UserState<ClerkAccount>>(
        data: userState.copyWith(
            status: verified ? UserStatus.signedIn : UserStatus.signedInWeak),
      );
    } on FirebaseException catch (e) {
      return Response<UserState<ClerkAccount>>(
        data: UserState<ClerkAccount>(status: UserStatus.signedOut),
        error: ResponseError('${e.message}'),
      );
    } on WrongAccountException catch(e){
      return Response<UserState<ClerkAccount>>(
        data: UserState<ClerkAccount>(
          status: UserStatus.signedOut,
          user: ClerkAccount(),
        ),
        error: ResponseError(e.message),
      );
    }
  }

  @override
  Future<Response<UserState<ClerkAccount>>> signOut() async {
    try {
      auth.signOut();
      return Response<UserState<ClerkAccount>>(data: UserState(status: UserStatus.signedOut));
    } on FirebaseAuthException catch (e) {
      return Response<UserState<ClerkAccount>>(
        data: UserState(status: authStatus()),
        error: ResponseError('${e.message}'),
      );
    }
  }

  @override
  Future<Response<UserState<ClerkAccount>>> signInAnon() async {
    try {
      final anonResponse = await auth.signInAnonymously();
      return Response<UserState<ClerkAccount>>(
        data: UserState(
            user: _clientAccountFromUserCredential(anonResponse),
            status: UserStatus.anon),
      );
    } on FirebaseAuthException catch (e) {
      return Response<UserState<ClerkAccount>>(
        data: UserState(
          status: UserStatus.signedOut,
        ),
        error: ResponseError('${e.message}'),
      );
    }
  }

  @override
  Future<Response<UserState<ClerkAccount>>> signUp(AuthFields authFields) async {
    try {
      final createUserResponse = await auth.createUserWithEmailAndPassword(
          email: authFields.email, password: authFields.password);

      final clientFromFirebaseAuth =
          _clientAccountFromUserCredential(createUserResponse);
      final clientWithName =
          clientFromFirebaseAuth.copyWith(name: authFields.name);

      await _addUserToDatabase(clientWithName);

      final signedInClient = UserState(
        status: UserStatus.signedInWeak,
        user: clientWithName,
      );

      return Response<UserState<ClerkAccount>>(
        data: signedInClient,
      );
    } on FirebaseException catch (e) {
      return Response<UserState<ClerkAccount>>(
        data: UserState(status: authStatus()),
        error: ResponseError('${e.message}'),
      );
    }
  }

  @override
  Future<Response<UserState<ClerkAccount>>> getUserObject(String uid) async {
    try {
      final clientResponse =
          await database.reference().child(Const.usersfield).child(uid).once();
      final user = ClerkAccount.fromMap(Map.from(clientResponse.value));
      return Response(data: UserState<ClerkAccount>(user: user));
    } catch (e) {
      return Response(
        data: UserState<ClerkAccount>(status: UserStatus.signedOut),
        error: ResponseError('$e'),
      );
    }
  }

  Future<void> _addUserToDatabase(ClerkAccount guest) async {
    assert(guest.uid != null,
        'UI is necessary to store in the right palce in the database');
    await userRef(guest.uid).set(guest.toMap());
  }

  //sign into firebase without fetching user details from database
  Future<ClerkAccount> _silentSignIn(AuthFields authFields) {
    auth.signInWithEmailAndPassword(
        email: authFields.email, password: authFields.password);
  }

  ClerkAccount _clientAccountFromUserCredential(UserCredential credential) {
    return ClerkAccount(
        name: credential.user.displayName,
        uid: credential.user.uid,
        email: credential.user.uid,
        dateCreated: '${DateTime.now().millisecondsSinceEpoch}');
  }


}
