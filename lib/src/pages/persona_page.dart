import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:crud_api_token/src/models/persona_model.dart';
import 'package:crud_api_token/src/providers/persona_provider.dart';

class PersonaPage extends StatefulWidget {
  @override
  _PersonaPageState createState() => _PersonaPageState();
}

class _PersonaPageState extends State<PersonaPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final personasProvider = new PersonasProvider();

  Persona persona = new Persona();
  bool _guardando = false;
  File foto;

  @override
  Widget build(BuildContext context) {
    final Persona persData = ModalRoute.of(context).settings.arguments;
    if (persData != null) {
      persona = persData;
    } else {
      persona = new Persona();
      persona.name = new Name();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Persona Datos'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _seleccionarFoto,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _tomarFoto,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _mostrarFoto2(),
                _crearFirst(),
                _crearLast(),
                _crearGender(),
                _crearEmail(),
                _crearPhone(),
                _crearBoton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearFirst() {
    return TextFormField(
      initialValue: persona.name.first,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'First'),
      onSaved: (value) => persona.name.first = value,
      validator: (value) {
        if (value.length < 4) {
          return 'Ingrese el first';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearLast() {
    return TextFormField(
      initialValue: persona.name.last,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Last'),
      onSaved: (value) => persona.name.last = value,
      validator: (value) {
        if (value.length < 4) {
          return 'Ingrese el last';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearGender() {
    return TextFormField(
      initialValue: persona.gender,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Gender'),
      onSaved: (value) => persona.gender = value,
      validator: (value) {
        if (value.length < 4) {
          return 'Ingrese el Gender';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearEmail() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      initialValue: persona.email,
      decoration: InputDecoration(labelText: 'Email'),
      onSaved: (value) => persona.email = value,
      validator: (value) {
        if (value.length < 4) {
          return 'Ingrese el Email';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearPhone() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      initialValue: persona.cellphone,
      decoration: InputDecoration(labelText: 'Cellphone'),
      onSaved: (value) => persona.cellphone = value,
      validator: (value) {
        if (value.length < 4) {
          return 'Ingrese el cellphone';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearBoton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: Colors.deepPurple,
      textColor: Colors.white,
      label: Text('Guardar'),
      icon: Icon(Icons.save),
      onPressed: (_guardando) ? null : _submit,
    );
  }

  void _submit() async {
    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();

    if (foto != null) {
      persona.pictures[0].url = await personasProvider.getUploadImg(foto);
    }

    if (persona.sId == null) {
      personasProvider.crearPersona(persona);
    } else {
      personasProvider.editarPersona(persona);
    }
    Navigator.pop(context);
  }

  Widget _mostrarFoto2() {
    final noImg = Image(
      image: AssetImage(foto?.path ?? 'assets/no-image.png'),
      height: 300.0,
      fit: BoxFit.cover,
    );
    if (persona.pictures != null) {
      return FadeInImage(
        image: NetworkImage(persona.pictures[0].url),
        placeholder: AssetImage('assets/jar-loading.gif'),
        height: 300.0,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else {
      return (foto == null)
          ? noImg
          : Image.file(foto, height: 300.0, fit: BoxFit.cover);
    }
  }

  _seleccionarFoto() async {
    _procesarImagen(ImageSource.gallery);
  }

  _tomarFoto() async {
    _procesarImagen(ImageSource.camera);
  }

  _procesarImagen(ImageSource origen) async {
    foto = await ImagePicker.pickImage(source: origen);
    if (foto != null) {
      persona.pictures = null;
    }
    setState(() {});
  }
}
