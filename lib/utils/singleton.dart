class Singleton {
  bool reloadMap = false;
  String localDir = '', url = '', token = '', id = '', name = '';
  int trips = 0;
  int loadSelectedIndex = 0;

  // tipo: hora inmutable, texto, opcion multiple,
  List loads = [
    {"id": 1, "name": "Carguío", "isEnable": true},
    {"id": 2, "name": "Inicio Conducción", "isEnable": true},
    {"id": 3, "name": "Fin Conducción", "isEnable": true},
    {"id": 4, "name": "Descarga", "isEnable": true},
    {"id": 5, "name": "Retorno", "isEnable": true}
  ];

  List loadsOptions = [
    {
      "loadId": 1,
      "options": [
        {
          "id": 1,
          "name": "Material de Carga",
          "type": "select",
          "source": "material",
          "value": ""
        },
        {
          "id": 2,
          "name": "Hora Inicio de Carguío",
          "type": "timestamp",
          "value": ""
        },
        {
          "id": 3,
          "name": "Hora Fin de Carguío",
          "type": "timestamp",
          "value": ""
        },
      ]
    },
    {
      "loadId": 2,
      "options": [
        {"id": 4, "name": "Tramo", "type": "string", "value": ""},
        {"id": 5, "name": "Km. Inicio", "type": "string", "value": ""},
        {
          "id": 6,
          "name": "Hora Inicio de Conducción",
          "type": "timestamp",
          "value": ""
        },
      ]
    },
    {
      "loadId": 3,
      "options": [
        {"id": 7, "name": "Tramo", "type": "string", "value": ""},
        {"id": 8, "name": "Km. Fin", "type": "string", "value": ""},
        {
          "id": 9,
          "name": "Hora Fin de Conducción",
          "type": "timestamp",
          "value": ""
        },
      ]
    },
    {
      "loadId": 4,
      "options": [
        {
          "id": 10,
          "name": "Hora Inicio de Descarga",
          "type": "timestamp",
          "value": ""
        },
        {
          "id": 11,
          "name": "Hora Fin de Descarga",
          "type": "timestamp",
          "value": ""
        },
      ]
    },
    {
      "loadId": 5,
      "options": [
        {
          "id": 12,
          "name": "Hora Inicio de Retorno",
          "type": "timestamp",
          "value": ""
        },
        {
          "id": 13,
          "name": "Hora Fin de Retorno",
          "type": "timestamp",
          "value": ""
        },
      ]
    },
  ];

  List loadsOriginal = [
    {"id": 1, "name": "Carguío", "isEnable": true},
    {"id": 2, "name": "Inicio Conducción", "isEnable": true},
    {"id": 3, "name": "Fin Conducción", "isEnable": true},
    {"id": 4, "name": "Descarga", "isEnable": true},
    {"id": 5, "name": "Retorno", "isEnable": true}
  ];

  List loadsOptionsOriginal = [
    {
      "loadId": 1,
      "options": [
        {
          "id": 1,
          "name": "Material de Carga",
          "type": "select",
          "source": "material",
          "value": ""
        },
        {
          "id": 2,
          "name": "Hora Inicio de Carguío",
          "type": "timestamp",
          "value": ""
        },
        {
          "id": 3,
          "name": "Hora Fin de Carguío",
          "type": "timestamp",
          "value": ""
        },
      ]
    },
    {
      "loadId": 2,
      "options": [
        {"id": 4, "name": "Tramo", "type": "string", "value": ""},
        {"id": 5, "name": "Km. Inicio", "type": "string", "value": ""},
        {
          "id": 6,
          "name": "Hora Inicio de Conducción",
          "type": "timestamp",
          "value": ""
        },
      ]
    },
    {
      "loadId": 3,
      "options": [
        {"id": 7, "name": "Tramo", "type": "string", "value": ""},
        {"id": 8, "name": "Km. Fin", "type": "string", "value": ""},
        {
          "id": 9,
          "name": "Hora Fin de Conducción",
          "type": "timestamp",
          "value": ""
        },
      ]
    },
    {
      "loadId": 4,
      "options": [
        {
          "id": 10,
          "name": "Hora Inicio de Descarga",
          "type": "timestamp",
          "value": ""
        },
        {
          "id": 11,
          "name": "Hora Fin de Descarga",
          "type": "timestamp",
          "value": ""
        },
      ]
    },
    {
      "loadId": 5,
      "options": [
        {
          "id": 12,
          "name": "Hora Inicio de Retorno",
          "type": "timestamp",
          "value": ""
        },
        {
          "id": 13,
          "name": "Hora Fin de Retorno",
          "type": "timestamp",
          "value": ""
        },
      ]
    },
  ];

  var messages = [];
  bool areMessagesRequesting = false;

  static final Singleton _singleton = Singleton._internal();

  factory Singleton() {
    return _singleton;
  }

  clear() {
    reloadMap = false;
    url = '';
    token = '';
    id = '';
    name = '';
    messages.clear();
    areMessagesRequesting = false;
    trips = 0;
    loadSelectedIndex = 0;
  }

  Singleton._internal();
}
