import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateDogSection extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController breedController = TextEditingController();
  final TextEditingController urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Dog'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('auth_token');
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: ageController,
              decoration: InputDecoration(labelText: 'Edad'),
            ),
            TextField(
              controller: breedController,
              decoration: InputDecoration(labelText: 'Raza'),
            ),
            TextField(
              controller: urlController,
              decoration: InputDecoration(labelText: 'Imagen'),
            ),
            SizedBox(height: 20),
            Mutation(
              options: MutationOptions(
                document: gql(r'''
                   mutation PostMutation(
                      $nombre: String!
                      $raza: String!
                      $edad: Int!
                      $foto: String!
                  ) {
                    createLink(nombre: $nombre, raza: $raza, edad: $edad, foto: $foto) {
                      id
                      nombre
                      raza
                      edad
                      foto
                    }
                  }
                '''),
                onCompleted: (dynamic resultData) {
                  print(resultData);
                },
                onError: (error) {
                  print(error);
                },
              ),
              builder: (RunMutation runMutation, QueryResult? result) {
                return ElevatedButton(
                  onPressed: () {
                    final String name = nameController.text;
                    final String ageText = ageController.text;
                    final String breed = breedController.text;
                    final String url = urlController.text;

                    if (name.isEmpty || ageText.isEmpty || breed.isEmpty || url.isEmpty) {
                      print("Please fill all fields");
                      return;
                    }

                    final int? age = int.tryParse(ageText);
                    if (age == null) {
                      print("Invalid age");
                      return;
                    }

                    print("Variables: name=$name, age=$age, breed=$breed, url=$url");

                    runMutation({
                      'nombre': nameController.text,
                      'edad': int.parse(ageController.text),
                      'raza': breedController.text,
                      'foto': urlController.text,
                    });
                  },
                  child: Text('Create Dog'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
