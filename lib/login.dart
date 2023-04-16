import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:mota_engil_mobile/home.dart';
import 'package:mota_engil_mobile/utils/api_service.dart';
import 'package:mota_engil_mobile/utils/security_service.dart';
import 'package:mota_engil_mobile/utils/singleton.dart';
import 'package:mota_engil_mobile/widgets/custom_button.dart';
import 'package:mota_engil_mobile/widgets/custom_input.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginScreen();
  }
}

class _LoginScreen extends State<LoginScreen> {
  var singleton = Singleton();
  bool loading = false;

  final TextInputType text = TextInputType.text;

  final userController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return loginUI();
  }

  @override
  void initState() {
    super.initState();
    singleton.clear();
  }

  Widget loginUI() {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Stack(
        children: [
          Container(
            child: Image(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              repeat: ImageRepeat.repeat,
              image: AssetImage('assets/logo-background.png'),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(color: Color(0xCCFFFFFF)),
            child: Text(''),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 32.0),
                        child: Image.asset(
                          'assets/logo.jpg',
                          width: MediaQuery.of(context).size.width / 3 * 2,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                        child: CustomInput(
                          text: 'Usuario',
                          controller: userController,
                          textInputType: text,
                          dark: true,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
                        child: CustomInput(
                          text: 'Contraseña',
                          controller: passController,
                          textInputType: text,
                          dark: true,
                          obscureText: true,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16.0, 64.0, 16.0, 8.0),
                        child: CustomButton(
                          color: [Color(0xFFF9B023), Color(0xFFF9B023)],
                          radius: 8.0,
                          onTap: () async {
                            setState(() {
                              loading = true;
                            });

                            EasyLoading.show(
                              status: 'Cargando...',
                            );

                            // Simulate login
                            // await Future.delayed(const Duration(seconds: 3), (){});
                            // EasyLoading.dismiss();
                            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));

                            try {
                              http.Response apiResponse = await ApiService.post(
                                  '/auth/login', {
                                "user": userController.text.trim(),
                                "pass": passController.text.trim()
                              });

                              if (apiResponse.statusCode == 200) {
                                var data = jsonDecode(apiResponse.body);

                                if (data['msg'] == 'ok') {
                                  setToken(data["data"]["token"]);
                                  setId(data["data"]["user"]["id"]);
                                  setName(data["data"]["user"]["name"]);

                                  singleton.token = data["data"]["token"];
                                  singleton.id = data["data"]["user"]["id"];
                                  singleton.name = data["data"]["user"]["name"];

                                  setState(() {
                                    loading = false;
                                  });
                                  EasyLoading.dismiss();

                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              HomeScreen()));
                                } else {
                                  setState(() {
                                    loading = false;
                                  });
                                  EasyLoading.dismiss();
                                  EasyLoading.showError(
                                      "Usuario no válido. Revisa los datos ingresados y vuelve a intentarlo más tarde.");
                                }
                              } else {
                                setState(() {
                                  loading = false;
                                });
                                EasyLoading.dismiss();
                                EasyLoading.showError(
                                    "Usuario no válido. Revisa los datos ingresados y vuelve a intentarlo más tarde.");
                              }
                            } catch (e) {
                              setState(() {
                                loading = false;
                              });
                              EasyLoading.dismiss();
                              EasyLoading.showError(
                                  "Ocurrió un error inesperado.");
                            }
                          },
                          child: const Center(
                            child: Text(
                              'Ingresar',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xFF000000), fontSize: 18.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          loading
              ? Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Color(0x46000000),
                )
              : Text('')
        ],
      ),
    );
  }
}
