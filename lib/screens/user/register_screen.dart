import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../api/system_api.dart';
import '../../bloc/settings/settings_cubit.dart';
import '../../bloc/settings_cubit.dart';
import '../../localizations/localizations.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late SettingsCubit settings;
  String name = "";
  String phone = "";
  String mail = "";
  String passwd = "";
  List<String> warnings = [];
  bool loading = false;

  showWarnings() {
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
              .map((e) => Container(
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
                  ))
              .toList(),
        ),
      ),
    );
  }

  register() async {
    setState(() {
      loading = true;
    });

    List<String> msgs = [];
    if (mail.trim().isEmpty) {
      msgs.add("mail_required");
    }
    if (passwd.trim().length < 6) {
      msgs.add("passwd_length");
    }

    final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(mail);

    if (!emailValid) {
      msgs.add("email_format");
    }

    if (name.trim().isEmpty) {
      msgs.add("name_required");
    }

    if (phone.trim().isEmpty) {
      msgs.add("phone_required");
    }

    if (msgs.isEmpty) {
      final api = SystemApi();
      final result = await api.register(
        email: mail.trim(),
        name: name.trim(),
        password: passwd.trim(),
        phone: phone.trim(),
      );
      final result2 = result.data;
      print(result2);
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
        setState(() {
          warnings = [
            AppLocalizations.of(context).getTranslate('register_failed')
          ];
        });
        showWarnings();
      }
    }

    if (msgs.isNotEmpty) {
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
        backgroundColor: Colors.black, // App bar rengi siyah
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/backgraun.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: loading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    SizedBox(height: 24),
                    TextField(
                      onChanged: (value) => setState(() {
                        mail = value;
                      }),
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)
                            .getTranslate('mail'), // Hint text ekledik
                        filled: true,
                        fillColor: Colors.white, // Arka plan rengi beyaz
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none, // Kenarlık yok
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      onChanged: (value) => setState(() {
                        name = value;
                      }),
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)
                            .getTranslate('name'), // Hint text ekledik
                        filled: true,
                        fillColor: Colors.white, // Arka plan rengi beyaz
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none, // Kenarlık yok
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      onChanged: (value) => setState(() {
                        phone = value;
                      }),
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)
                            .getTranslate('phone'), // Hint text ekledik
                        filled: true,
                        fillColor: Colors.white, // Arka plan rengi beyaz
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none, // Kenarlık yok
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      obscureText: true,
                      onChanged: (value) => setState(() {
                        passwd = value;
                      }),
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)
                            .getTranslate('passwd'), // Hint text ekledik
                        filled: true,
                        fillColor: Colors.white, // Arka plan rengi beyaz
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none, // Kenarlık yok
                        ),
                      ),
                    ),
                    SizedBox(height: 18),
                    ElevatedButton(
                      onPressed: () => register(),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red, // Buton rengi kırmızı
                      ),
                      child: Text(AppLocalizations.of(context)
                          .getTranslate('register')),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
