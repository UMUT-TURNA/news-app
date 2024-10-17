import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../api/system_api.dart';
import '../../bloc/settings/settings_cubit.dart';
import '../../bloc/settings_cubit.dart';
import '../../localizations/localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late SettingsCubit settings;
  String mail = '';
  String passwd = '';
  List<String> warnings = [];
  bool loading = false;

  void showWarnings() {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(AppLocalizations.of(context).getTranslate('warning')),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context).getTranslate('close')),
          ),
        ],
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: warnings
              .map(
                (e) => Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    AppLocalizations.of(context).getTranslate(e),
                    textAlign: TextAlign.start,
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Future<void> login() async {
    setState(() {
      loading = true;
    });

    List<String> msgs = [];
    if (mail.trim().isEmpty) {
      msgs.add('mail_required');
    }
    if (passwd.trim().length < 6) {
      msgs.add('passwd_length');
    }

    final bool emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(mail);

    if (!emailValid) {
      msgs.add('email_format');
    }

    if (msgs.isEmpty) {
      final api = SystemApi();
      final result = await api.login(email: mail, password: passwd);
      final result2 = result.data;
      if (result2["success"] == true) {
        List<String> data = [
          result2['name'],
          result2['email'],
          result2['phone'] ?? 'Boş',
          result2['token'],
        ];
        settings.userLogin(data);
        GoRouter.of(context).replace('/home');
      } else {
        warnings = [
          AppLocalizations.of(context).getTranslate('invalid_credentials'),
        ];
        setState(() {});
        showWarnings();
      }
    } else {
      showWarnings();
    }

    setState(() {
      warnings = msgs;
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    settings = context.read<SettingsCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/backgraun.jpg'), 
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context).getTranslate('login'),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    onChanged: (value) => setState(() {
                      mail = value;
                    }),
                    decoration: InputDecoration(
                      labelText:
                          AppLocalizations.of(context).getTranslate('mail'),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    onChanged: (value) => setState(() {
                      passwd = value;
                    }),
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText:
                          AppLocalizations.of(context).getTranslate('passwd'),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => login(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Text(
                        AppLocalizations.of(context).getTranslate('login'),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
