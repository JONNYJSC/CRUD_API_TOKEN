import 'package:flutter/material.dart';

import 'package:crud_api_token/src/utils/utils.dart';
import 'package:crud_api_token/src/models/persona_model.dart';

class HomePage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

    final Persona persData = ModalRoute.of(context).settings.arguments;
    if(persData != null) {
      persona = persData;
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Persona'),
      ),
      body: _crearListado(),
      floatingActionButton: _crearBoton(context),
    );
  }
    Widget _crearListado() {
    return FutureBuilder(
      future: personasProvider.cargarPersonas(),
      builder: (BuildContext context, AsyncSnapshot<List<Persona>> snapshot){
        if (snapshot.hasData) {
          final personas = snapshot.data;
          return ListView.builder(            
            itemCount: personas.length,
            itemBuilder: (context, i) => _crearItem(context, personas[i]),
          );
        } else {
          return Center(child:  CircularProgressIndicator());
        }
      },
    );
  }

    Widget _crearItem(BuildContext context, Persona persona) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: (direccion) {
        personasProvider.borrarPersona(persona.sId);
      },
      child: Card(
        child: Column(
          children: <Widget>[ 
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
                child: ListTile(
                  title: Text('${persona.name.first} ${persona.name.last}', style: styleFont),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(persona.pictures[0].url),
                  ),
                  onTap: () => Navigator.pushNamed(context, 'persona_page', arguments: persona),
              ),
            ),
          ],
        ),
      )
    );
  } 

  _crearBoton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.deepPurple,
      onPressed: () => Navigator.pushNamed(context, 'persona_page'),
    );
  }

}