import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roomiesMobile/presentation/themes/primary_theme/primary-theme.dart';
import 'business_logic/authentication/authentication.dart';
import 'package:roomiesMobile/presentation/landing/house_loading.dart';
import 'presentation/login/login_page.dart';
import 'presentation/splash_page.dart';

class App extends StatelessWidget {
  final AuthenticationRepository authenticationRepository;
  const App({
    Key key,
    @required this.authenticationRepository,
  })  : assert(authenticationRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
        value: authenticationRepository,
        child: BlocProvider(
              create: (BuildContext context) => AuthenticationBloc(
              authenticationRepository: authenticationRepository,
            ),
          child: AppView(),
        ));
  }
}
class AppView extends StatefulWidget {
  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: PrimaryTheme.primaryTheme,
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>( //Keeps track of the state and shows the home page when authenticated
          listener: (context, state) {
            switch (state.status) {
             
              case AuthenticationStatus.authenticated:
                  
                    _navigator.pushAndRemoveUntil<void>(
                     HouseLoading.route(),
                    (route) => false,
                    );
                    break;

              case AuthenticationStatus.unauthenticated:
                _navigator.pushAndRemoveUntil<void>(
                  LoginPage.route(),
                  (route) => false,
                );

                break;

              default:
              _navigator.pushAndRemoveUntil<void>(
                  LoginPage.route(),
                  (route) => false);
                break;
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
