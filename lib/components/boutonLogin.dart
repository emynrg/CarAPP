import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netcars/constantes/colors.dart';
import 'package:netcars/views/AcceuilPage.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BoutonLogin extends StatelessWidget {
  const BoutonLogin({Key? key}) : super(key: key);
final String keycloakUrl ='http://ec2-35-181-62-40.eu-west-3.compute.amazonaws.com:8080/realms/NetCars/protocol/openid-connect/auth?response_type=token&client_id=NetCars&redirect_uri=myapp://callback&state=RnJpIE9jdCAyMCAyMDIzIDEzOjQ3OjM2IEdNVCswMTAwIChoZXVyZSBub3JtYWxlIGTigJlFdXJvcGUgY2VudHJhbGUp&realm=NetCars&nonce=123456';
//final String keycloakUrl =
     // 'https://www.google.com';
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(keycloakUrl);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => KeycloakLoginWebView(url: keycloakUrl),
          ),
        );

      },
      child: Container(
        padding: const EdgeInsets.all(23).w,
        margin: const EdgeInsets.symmetric(horizontal: 40).h,
        decoration: BoxDecoration(
          color: mainGray,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            "Se connecter",
            style: TextStyle(
              fontFamily: 'PoppinsSemiBold',
              color: Colors.black,
              fontSize: 24.sp,
            ),
          ),
        ),
      ),
    );
  }
}

class KeycloakLoginWebView extends StatefulWidget {
  final String url;
  KeycloakLoginWebView({required this.url});

  @override
  _KeycloakLoginWebViewState createState() => _KeycloakLoginWebViewState();
}

class _KeycloakLoginWebViewState extends State<KeycloakLoginWebView> {
  final storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        navigationDelegate: (NavigationRequest request) async {
          if (request.url.startsWith('myapp://callback')) {
           
            Uri uri = Uri.parse(request.url);
            String? token = uri.fragment
                .split('&')
                .map((e) => MapEntry(e.split('=')[0], e.split('=')[1]))
                .firstWhere((element) => element.key == 'access_token',
                    orElse: () => MapEntry('', ''))
                .value;

           if (token != null && token.isNotEmpty) {
              await storage.write(key: 'auth_token', value: token);
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => AcceuilPage()));
            } else {
              // Gérer l'erreur ici - le token n'a pas été trouvé
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Erreur: Token non trouvé')),
              );
            }
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
        
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showToken(context),
        child: Icon(Icons.info),
      ),
    );
  }

  Future<void> _showToken(BuildContext context) async {
    String? token = await storage.read(key: 'auth_token');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Token'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Token: $token'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
