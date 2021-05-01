import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rewards_network_shared/models/client.dart';
import 'package:rewards_network_shared/models/auth_fields.dart';
import 'package:rewards_network_shared/models/client_state.dart';
import 'package:rewards_network_shared/models/response.dart';
import 'package:rewards_network_shared/services/auth_service.dart';
import 'package:rewards_network_shared/models/user_status.dart';
import 'package:rewardstender/Utils/Const.dart';

class FirebaseAuthService implements AuthService {
  FirebaseAuth auth;
  FirebaseDatabase database;

  FirebaseAuthService({@required this.auth, @required this.database});

  DatabaseReference get ref => database.reference();

  DatabaseReference userRef(String uid) =>
      ref.child('clerks').child(uid);

  bool get hasUid => auth?.currentUser?.uid == null ? false : true;

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
  Future<Response<UserState>> checkAuthStatus() async {
    try {
      //notSignedIn
      if (auth.currentUser == null) {
        return Response(
          data: UserState(
            status: UserStatus.signedOut,
          ),
        );
      } else {
        //signed in but how?

        final clientState = UserState(
            user: ClientAccount(
              name: auth.currentUser.displayName,
              email: auth.currentUser.email,
              uid: auth.currentUser.uid,
            ),
            status: UserStatus.signedInWeak);

        final isAnonymous = auth.currentUser.isAnonymous;
        final isVerified = auth.currentUser.emailVerified;

        if (isAnonymous) {
          return Response(
            data: clientState.copyWith(
              status: UserStatus.anon,
            ),
          );
        } else if (isVerified) {
          final databaseResponse = await userRef(clientState.user.uid).once();
          final _fetchedGuest = ClientAccount.fromMap(
            Map.from(databaseResponse.value),
          );


          return Response(
            data: UserState(
                user: _fetchedGuest,
                status: UserStatus.signedIn
            ),
          );
        } else {
          final databaseResponse = await userRef(clientState.user.uid).once();
          final _fetchedGuest = ClientAccount.fromMap(
            Map.from(databaseResponse.value),
          );
          return Response(
            data: UserState(
                user: _fetchedGuest,
                status: UserStatus.signedInWeak
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      return Response(
        data: UserState(status: UserStatus.signedOut),
        error: ResponseError('${e.message}'),
      );
    }
  }

  @override
  Future<Response<UserState>> signIn(AuthFields authFields) async {
    try {
      final result = await auth.signInWithEmailAndPassword(
          email: authFields.email, password: authFields.password);
      final verified = result.user.emailVerified;
      final snap = await userRef(result.user.uid).once();
      return Response(
        data: UserState(user:ClientAccount.fromMap(Map.from(snap.value),),
         status: verified ? UserStatus.signedIn : UserStatus.signedInWeak),
      );
    } on FirebaseException catch (e) {
      return Response(
        data: UserState(status: UserStatus.signedOut),
        error: ResponseError('${e.message}'),
      );
    }
  }

  @override
  Future<Response<UserState>> signOut() async {
    try {
      auth.signOut();
      return Response(data: UserState(status: UserStatus.signedOut));
    } on FirebaseAuthException catch (e) {
      return Response(
        data: UserState(status: authStatus()),
        error: ResponseError('${e.message}'),
      );
    }
  }

  @override
  Future<Response<UserState>> signInAnon() async {
    try {
      final anonResponse = await auth.signInAnonymously();
      return Response(
        data: UserState(user: _clientAccountFromUserCredential(anonResponse), status: UserStatus.anon),
      );
    } on FirebaseAuthException catch (e) {
      return Response(
        data: UserState(
          status: UserStatus.signedOut,
        ),
        error: ResponseError('${e.message}'),
      );
    }
  }

  @override
  Future<Response<UserState>> signUp(
      AuthFields authFields) async {
    try {
      final createUserResponse = await auth.createUserWithEmailAndPassword(
          email: authFields.email, password: authFields.password);

      final clientFromFirebaseAuth =  _clientAccountFromUserCredential(createUserResponse);
      final clientWithName = clientFromFirebaseAuth.copyWith(name: authFields.name);

      await _addUserToDatabase(clientWithName);

      final signedInClient = UserState(
        status: UserStatus.signedInWeak,
        user: clientWithName,
      );

      return Response(
        data: signedInClient,
      );
    } on FirebaseException catch (e) {
      return Response(
        data: UserState(status: authStatus()),
        error: ResponseError('${e.message}'),
      );
    }
  }

  @override
  Future<Response<UserState>> getUserObject(String uid) async {
    try {
      final clientResponse =
          await database.reference().child(Const.usersfield).child(uid).once();
      final user = ClientAccount.fromMap(Map.from(clientResponse.value));
      return Response(data: UserState(
        user: user
      ));
    } catch (e) {
      return Response(
        data: UserState(status: UserStatus.signedOut),
        error: ResponseError('$e'),
      );
    }
  }

  Future<void> _addUserToDatabase(ClientAccount guest) async {
    assert(guest.uid != null,
        'UI is necessary to store in the right palce in the database');
    await userRef(guest.uid).set(guest.toMap());
  }

  //sign into firebase without fetching user details from database
  Future<ClientAccount> _silentSignIn(AuthFields authFields) {
    auth.signInWithEmailAndPassword(
        email: authFields.email, password: authFields.password);
  }

  ClientAccount _clientAccountFromUserCredential(UserCredential credential){
    return ClientAccount(
      name: credential.user.displayName,
      uid: credential.user.uid,
      email: credential.user.uid,
      dateCreated: '${DateTime.now().millisecondsSinceEpoch}'
    );
  }
}
