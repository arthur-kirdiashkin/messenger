import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:messenger/common/constants.dart';
import 'package:messenger/features/auth/data/models/chat.dart';
import 'package:messenger/features/auth/data/models/hive_user.dart';
import 'package:messenger/features/auth/data/models/message.dart';
import 'package:messenger/features/auth/data/repository/database_repository.dart';
import 'package:messenger/features/auth/data/repository/hive_repository.dart';
import 'package:messenger/features/auth/data/repository/supabase_repository.dart';
import 'package:messenger/features/auth/presentation/blocs/auth_bloc/authentication_bloc.dart';
import 'package:messenger/features/auth/presentation/blocs/auth_bloc/authentication_event.dart';
import 'package:messenger/features/auth/presentation/blocs/auth_bloc/authentication_state.dart';
import 'package:messenger/features/auth/presentation/blocs/chat_bloc/chat_bloc.dart';
import 'package:messenger/features/auth/presentation/pages/home_page.dart';
import 'package:messenger/features/auth/presentation/pages/welcome_page.dart';
import 'package:messenger/features/form-validation/form_bloc/form_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Supabase.initialize(
    url: SUPABASE_URL,
    anonKey: SUPABASE_API_KEY,
  );
  Hive.registerAdapter<HiveUser>(HiveUserAdapter());
  Hive.registerAdapter<Message>(MessageAdapter());
  Hive.registerAdapter<Chat>(ChatAdapter());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => HiveRepositoryImpl()),
        RepositoryProvider(create: (context) => SupabaseRepositoryImpl()),
        RepositoryProvider(
            create: (context) => SupabaseDatabaseRepositoryImpl()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => ChatBloc(
                  supabaseDatabaseRepository:
                      SupabaseDatabaseRepositoryImpl())),
          BlocProvider(
              create: (context) => AuthenticationBloc(
                    supabaseRepository: SupabaseRepositoryImpl(),
                    supabaseDatabaseRepository:
                        SupabaseDatabaseRepositoryImpl(),
                    hiveRepository: HiveRepositoryImpl(),
                  )..add(AuthenticationStarted())),
          BlocProvider(
            create: (context) => FormBloc(
              hiveRepository: HiveRepositoryImpl(),
              supabaseDatabaseRepository: SupabaseDatabaseRepositoryImpl(),
              supabaseRepository: SupabaseRepositoryImpl(),
            ),
          )
        ],
        child: MaterialApp(
          theme: ThemeData(
              scaffoldBackgroundColor: Color.fromRGBO(41, 47, 63, 1),
              appBarTheme: AppBarTheme(
                  backgroundColor: Color.fromRGBO(41, 47, 63, 1),
                  iconTheme: IconThemeData(color: Colors.white))),
          home: Scaffold(
            body: MultiBlocListener(
              listeners: [
                BlocListener<AuthenticationBloc, AuthenticationState>(
                  listener: (context, state) {
                    if (state.authenticationStatus ==
                        AuthenticationStatus.success) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => HomePage()),
                        (Route<dynamic> route) => false,
                      );
                    }
                  },
                ),
                BlocListener<AuthenticationBloc, AuthenticationState>(
                  listener: (context, state) {
                    if (state.authenticationStatus ==
                        AuthenticationStatus.notSucess) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => WelcomePage()),
                        (Route<dynamic> route) => false,
                      );
                    }
                  },
                )
              ],
              child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  if (state.authenticationStatus ==
                      AuthenticationStatus.loading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
