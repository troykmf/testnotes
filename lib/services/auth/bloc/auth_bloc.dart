import 'package:bloc/bloc.dart';
import 'package:testnotes/services/auth/auth_provider.dart';
import 'package:testnotes/services/auth/bloc/auth_event.dart';
import 'package:testnotes/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // the AuthBloc need a super or rather an initial state which is what is stored
  // inside the super
  AuthBloc(AuthProvider provider) : super(const AuthStateLoading()) {
    // the job inside here is to handle various events that was described in the AuthEvent
    // initialize
    on<AuthEventInitialize>(
      (event, emit) async {
        await provider
            .initialize(); // we await since initialize is a future<void> function
        // after initializing, we need to get the current user
        final user = provider.currentUser;
        // the first 'if' is that if the user is null then emit a state of loggedOut or
        // rather the state of the user is lpggedOut. That is, if there is no user then
        // the user is loggedOut atm
        if (user == null) {
          emit(const AuthStateLoggedOut(null));
          // the second 'if' is that if the user is not emailVerified then the user needs verification
        } else if (!user.isEmailVerified) {
          emit(const AuthStateNeedsVerification());
        } else {
          emit(AuthStateLoggedIn(user));
        }
      },
    );

    // log in
    on<AuthEventLogin>(
      /// basically what the code below says is that before logIn, there is an initial
      /// state called AuthStateLoading and when its done loading, we got the email and
      /// password from the AuthEventLogin. Then we used a try and catch block, that is
      /// it should await login command from firebase using both the email and password,
      /// if its able to connect then it should emit the state AuthStateLogin with the user
      /// else it should catch whatever exception that was thrown
      (event, emit) async {
        // emit(const AuthStateLoading());
        final email = event.email;
        final password = event.password;
        try {
          final user = await provider.logIn(
            email: email,
            password: password,
          );
          emit(AuthStateLoggedIn(user));
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(e));
        }
      },
    );
    // log out
    on<AuthEventLogout>(
      (event, emit) async {
        try {
          emit(const AuthStateLoading()); // can never throw an exception
          await provider.logOut();
          emit(const AuthStateLoggedOut(null));
        } on Exception catch (e) {
          emit(AuthStateLogOutFailure(e));
        }
      },
    );
  }
}
