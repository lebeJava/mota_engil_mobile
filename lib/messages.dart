import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:mota_engil_mobile/home.dart';
import 'package:mota_engil_mobile/loads_detail.dart';
import 'package:mota_engil_mobile/utils/api_service.dart';
import 'package:mota_engil_mobile/utils/security_service.dart';
import 'package:mota_engil_mobile/utils/singleton.dart';
import 'package:mota_engil_mobile/widgets/custom_button.dart';
import 'package:mota_engil_mobile/widgets/custom_input.dart';

class MessagesScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MessagesScreen();
  }
}

class _MessagesScreen extends State<MessagesScreen> {
  Singleton singleton = new Singleton();
  bool loading = false;

  final ME = 1;

  List messages = [];

  final ScrollController listScrollController = new ScrollController();

  final msgController = TextEditingController();

  final TextInputType text = TextInputType.text;

  final userController = TextEditingController();
  final passController = TextEditingController();

  init() {
    messages.add(
      {"id": 1, "name": singleton.name, "msg": "Hola", "iat": 1658601393},
    );

    messages.add(
      {
        "id": 2,
        "name": "Rafael Soto",
        "msg": "Estoy en camino",
        "iat": 1658601393
      },
    );

    messages.add({
      "id": 2,
      "name": "Andres Paredes",
      "msg": "Esperaré 5min",
      "iat": 1658601393
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return messagesUI();
  }

  @override
  void initState() {
    super.initState();
    if (listScrollController.hasClients) {
      final position = listScrollController.position.maxScrollExtent;
      listScrollController.jumpTo(position);
    }
    init();
  }

  Widget messagesUI() {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Color(0xFF006EB9),
        title: Text(
          'Chat',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: ListView.builder(
                      padding: EdgeInsets.all(16.0),
                      shrinkWrap: true,
                      controller: listScrollController,
                      itemCount: messages.length,
                      itemBuilder: (BuildContext context, int index) => Align(
                            alignment: messages[index]['id'] == ME
                                ? Alignment.topRight
                                : Alignment.topLeft,
                            child: Container(
                              padding: EdgeInsets.all(16.0),
                              margin: EdgeInsets.only(bottom: 16.0),
                              decoration: BoxDecoration(
                                  color: messages[index]['id'] == ME
                                      ? Color(0xFF006EB9)
                                      : Color(0xFFEFEFEF),
                                  border: Border.all(
                                    color: messages[index]['id'] == ME
                                        ? Color(0xFF006EB9)
                                        : Color(0xFFEFEFEF),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    messages[index]['name'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: messages[index]['id'] == ME
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                  Text(
                                    messages[index]['msg'],
                                    style: TextStyle(
                                        color: messages[index]['id'] == ME
                                            ? Colors.white
                                            : Colors.black),
                                  )
                                ],
                              ),
                            ),
                          )),
                ),
                Divider(
                  thickness: 1.5,
                  height: 1.5,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                  child: Wrap(
                    spacing: 16.0,
                    runSpacing: 16.0,
                    children: <Widget>[
                      InkWell(
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        onLongPress: () {
                          print('delete');
                        },
                        onTap: () {
                          setState(() {
                            messages.add(
                              {
                                "id": 1,
                                "name": singleton.name,
                                "msg": "Llego en 5min",
                                "iat": 1658601393
                              },
                            );

                            final position =
                                listScrollController.position.maxScrollExtent;
                            listScrollController.jumpTo(position);
                          });
                        },
                        child: Chip(
                          label: const Text(
                            'Llego en 5min',
                            style: TextStyle(color: Colors.white),
                          ),
                          elevation: 8,
                          backgroundColor: Color(0xFF006EB9),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                      InkWell(
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        onLongPress: () {
                          print('delete');
                        },
                        onTap: () {
                          setState(() {
                            messages.add(
                              {
                                "id": 1,
                                "name": singleton.name,
                                "msg": "En ruta",
                                "iat": 1658601393
                              },
                            );

                            final position =
                                listScrollController.position.maxScrollExtent;
                            listScrollController.jumpTo(position);
                          });
                        },
                        child: Chip(
                          label: const Text(
                            'En ruta',
                            style: TextStyle(color: Colors.white),
                          ),
                          elevation: 8,
                          backgroundColor: Color(0xFF006EB9),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                      InkWell(
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        onLongPress: () {
                          print('delete');
                        },
                        onTap: () {
                          setState(() {
                            messages.add(
                              {
                                "id": 1,
                                "name": singleton.name,
                                "msg": "En espera",
                                "iat": 1658601393
                              },
                            );

                            final position =
                                listScrollController.position.maxScrollExtent;
                            listScrollController.jumpTo(position);
                          });
                        },
                        child: Chip(
                          label: const Text(
                            'En espera',
                            style: TextStyle(color: Colors.white),
                          ),
                          elevation: 8,
                          backgroundColor: Color(0xFF006EB9),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Flexible(
                        child: CustomInput(
                          text: null,
                          controller: msgController,
                          textInputType: text,
                          dark: true,
                          placeholder: 'Escribe aquí...',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: FloatingActionButton(
                          heroTag: 'send',
                          onPressed: () async {
                            setState(() {
                              messages.add(
                                {
                                  "id": 1,
                                  "name": singleton.name,
                                  "msg": msgController.text.trim(),
                                  "iat": 1658601393
                                },
                              );

                              final position =
                                  listScrollController.position.maxScrollExtent;
                              listScrollController.jumpTo(position);

                              msgController.text = '';
                            });
                          },
                          backgroundColor: Color(0xFF006EB9),
                          child: Icon(
                            Icons.send,
                            size: 32.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
