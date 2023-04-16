import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mota_engil_mobile/login.dart';
import 'package:mota_engil_mobile/sender.dart';
import 'package:mota_engil_mobile/updater.dart';
import 'package:mota_engil_mobile/utils/security_service.dart';
import 'package:mota_engil_mobile/utils/singleton.dart';

Widget DrawerMenu(context, String name) {
  return Drawer(
    // Add a ListView to the drawer. This ensures the user can scroll
    // through the options in the drawer if there isn't enough vertical
    // space to fit everything.
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Center(
            child: Text(
              name,
              style: TextStyle(color: Colors.white, fontSize: 32.0),
            ),
          ),
        ),
        ListTile(
          title: const Text('Enviar datos'),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => SenderScreen()));
          },
        ),
        ListTile(
          title: const Text('Actualizar'),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => UpdaterScreen()));
          },
        ),
        ListTile(
          title: const Text('Cerrar sesión'),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Cerrar Sesión"),
                  content: Text("¿Desea cerrar sesión?"),
                  actions: [
                    TextButton(
                      child: Text("Cancelar"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: Text("Cerrar Sesión"),
                      onPressed: () async {
                        await removeId();
                        await removeName();
                        await removeToken();

                        Navigator.pop(context);

                        Navigator.pop(context);

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    LoginScreen()));

                        /**/
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    ),
  );
}
