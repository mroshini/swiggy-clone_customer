//import 'package:flutter/foundation.dart';
//import 'package:foodstar/src/core/service/authservice.dart';
//
//enum AuthState {
//  busy,
//  idle,
//  onBoard,
//  initial,
//  authenticated,
//  unauthenticated,
//}
//
//class AuthProvider extends ChangeNotifier {
//  AuthService _authService;
//  AuthState _authState = AuthState.initial;
//  bool isUserExists = false;
//  var sharedPreferences;
//
//  AuthState get authState => _authState;
//
//  set setAuthState(AuthState authState) {
//    _authState = authState;
//    notifyListeners();
//  }
//
//  AuthProvider({@required AuthService authService}) {
//    this._authService = authService;
//  }
//
//  setupInitialScreen() async {
//    var token = await _authService.getAuthToken();
//    _authState =
//        (token == null) ? AuthState.unauthenticated : AuthState.authenticated;
//    notifyListeners();
//  }
//}
