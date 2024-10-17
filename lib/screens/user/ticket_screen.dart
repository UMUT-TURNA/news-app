import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:news/bloc/settings_cubit.dart';
import '../../api/system_api.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({Key? key}) : super(key: key);

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  final SystemApi _api = SystemApi();
  late final SettingsCubit settings;

  @override
  void initState() {
    super.initState();
    settings = context.read<SettingsCubit>();
  }

  @override
  Widget build(BuildContext context) {
    String token = settings.state.userInfo[3];
    String title = '';
    String message = '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Destek Talebi',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Konu',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                title = value;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Mesajınız',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                message = value;
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _api.addTicket(token, title, message);
                GoRouter.of(context).go('/ticketList');
              },
              child: Text('Gönder'),
            ),
          ],
        ),
      ),
    );
  }
}
