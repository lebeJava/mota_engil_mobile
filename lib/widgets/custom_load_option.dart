import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mota_engil_mobile/utils/singleton.dart';
import 'package:mota_engil_mobile/widgets/custom_button.dart';
import 'package:mota_engil_mobile/widgets/custom_input.dart';

var singleton = new Singleton();

Widget CustomLoadOption(
    context,
    int optionsIndex,
    int index,
    String name,
    String type,
    String value,
    String timestamp,
    List<String>? select,
    TextEditingController textController,
    TextInputType text,
    bool isEnable,
    bool isLastItem,
    checkOptionsDone) {
  switch (type) {
    case 'timestamp':
      return Container(
        padding: EdgeInsets.only(left: 16.0, right: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0, 32.0, 0, 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style:
                          TextStyle(fontSize: 24, overflow: TextOverflow.clip),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Text(
                    singleton.loadsOptions[optionsIndex]["options"][index]
                                ['value']
                            .toString()
                            .isNotEmpty
                        ? singleton.loadsOptions[optionsIndex]["options"][index]
                            ['value']
                        : timestamp,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            CustomButton(
              color: [Color(0xFF006EB9), Color(0xFF006EB9)],
              radius: 8.0,
              enable: isEnable,
              onTap: () async {
                String temp = timestamp;
                singleton.loadsOptions[optionsIndex]["options"][index]
                    ['value'] = temp;

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Color(0xFFF9B023),
                      content: Container(
                        color: Color(0xFFF9B023),
                        height: 300.0, // Change as per your requirement
                        width: 150.0, // Change as per your requirement
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Se ha marcado:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24.0),
                              textAlign: TextAlign.center,
                            ),
                            CustomButton(
                              color: [Color(0xFF006EB9), Color(0xFF006EB9)],
                              radius: 8.0,
                              onTap: () async {
                                singleton.loadsOptions[optionsIndex]["options"]
                                    [index]['value'] = '';
                                Navigator.pop(context);
                              },
                              child: const Center(
                                child: Text(
                                  'Revertir (5)',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color(0xFFFFFFFF), fontSize: 18.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );

                await delay(5);

                if (singleton.loadsOptions[optionsIndex]["options"][index]
                        ['value']
                    .toString()
                    .isNotEmpty) {
                  checkOptionsDone(optionsIndex);
                  Navigator.pop(context);
                }
              },
              child: const Center(
                child: Text(
                  'Marcar',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 18.0),
                ),
              ),
            ),
            isLastItem
                ? Text('')
                : const Padding(
                    padding: EdgeInsets.only(
                      top: 16.0,
                    ),
                    child: Divider(color: Colors.black),
                  ),
          ],
        ),
      );

    case 'select':
      return Container(
        padding: EdgeInsets.only(left: 16.0, right: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 24),
                    textAlign: TextAlign.start,
                  ),
                  InkWell(
                    onTap: () {
                      value.isNotEmpty
                          ? null
                          : showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Material'),
                                  content: Container(
                                    height:
                                        300.0, // Change as per your requirement
                                    width:
                                        300.0, // Change as per your requirement
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: select!.length,
                                      itemBuilder:
                                          (BuildContext context, int i) {
                                        return ListTile(
                                          title: InkWell(
                                            onTap: () async {
                                              String temp = select[i];
                                              singleton.loadsOptions[
                                                      optionsIndex]["options"]
                                                  [index]['value'] = temp;

                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    backgroundColor:
                                                        Color(0xFFF9B023),
                                                    content: Container(
                                                      color: Color(0xFFF9B023),
                                                      height:
                                                          300.0, // Change as per your requirement
                                                      width:
                                                          150.0, // Change as per your requirement
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Text(
                                                            'Se ha seleccionado:',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Text(
                                                            temp,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 24.0),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          CustomButton(
                                                            color: [
                                                              Color(0xFF006EB9),
                                                              Color(0xFF006EB9)
                                                            ],
                                                            radius: 8.0,
                                                            onTap: () async {
                                                              singleton.loadsOptions[
                                                                          optionsIndex]
                                                                      [
                                                                      "options"][index]
                                                                  [
                                                                  'value'] = '';
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Center(
                                                              child: Text(
                                                                'Revertir (5)',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        0xFFFFFFFF),
                                                                    fontSize:
                                                                        18.0),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );

                                              await delay(5);

                                              if (singleton
                                                  .loadsOptions[optionsIndex]
                                                      ["options"][index]
                                                      ['value']
                                                  .toString()
                                                  .isNotEmpty) {
                                                checkOptionsDone(optionsIndex);
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.all(16.0),
                                              child: Text(
                                                select[i],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              });
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(16.0, 16.0, 0, 16.0),
                      child: Text(
                        value.isEmpty ? 'Seleccionar >' : value,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            isLastItem
                ? Text('')
                : const Padding(
                    padding: EdgeInsets.only(
                      top: 16.0,
                    ),
                    child: Divider(color: Colors.black),
                  ),
          ],
        ),
      );

    case 'string':
      return Container(
        padding: EdgeInsets.only(left: 16.0, right: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0, 32.0, 0, 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 24),
                    textAlign: TextAlign.start,
                  ),
                  InkWell(
                    onTap: () {
                      value.isNotEmpty
                          ? null
                          : showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                textController.text = "";
                                return AlertDialog(
                                  title: Text('Indicar'),
                                  content: Container(
                                    height:
                                        150.0, // Change as per your requirement
                                    width:
                                        300.0, // Change as per your requirement
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomInput(
                                          text: '',
                                          controller: textController,
                                          textInputType: text,
                                          dark: true,
                                        ),
                                        CustomButton(
                                          color: [
                                            Color(0xFF006EB9),
                                            Color(0xFF006EB9)
                                          ],
                                          radius: 8.0,
                                          enable: isEnable,
                                          onTap: () {
                                            singleton.loadsOptions[optionsIndex]
                                                        ["options"][index]
                                                    ['value'] =
                                                textController.text.trim();

                                            checkOptionsDone(optionsIndex);
                                            Navigator.pop(context);
                                          },
                                          child: const Center(
                                            child: Text(
                                              'Guardar',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Color(0xFFFFFFFF),
                                                  fontSize: 18.0),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                    },
                    child: Text(
                      value.isEmpty ? 'Indicar >' : value,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ),
            isLastItem
                ? Text('')
                : const Padding(
                    padding: EdgeInsets.only(
                      top: 16.0,
                    ),
                    child: Divider(color: Colors.black),
                  ),
          ],
        ),
      );

    default:
      return Text('');
  }
}

delay(time) {
  return Future.delayed(Duration(seconds: time), () {});
}

/*
return Container(
    padding: EdgeInsets.only(left: 16.0, right: 16.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 32.0, 0, 16.0),
          child: Text(
            name,
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.start,
          ),
        ),
        CustomButton(
          color: [Color(0xFF006EB9), Color(0xFF006EB9)],
          radius: 8.0,
          enable: isEnable,
          onTap: action,
          child: const Center(
            child: Text(
              'Iniciar',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 18.0),
            ),
          ),
        ),
        isLastItem
            ? Text('')
            : const Padding(
                padding: EdgeInsets.only(
                  top: 16.0,
                ),
                child: Divider(color: Colors.black),
              ),
      ],
    ),
  );

 */