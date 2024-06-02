import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'increment_votes_mutation.dart';

class ViewDogsSection extends StatelessWidget {
  final String readDogs = """
  query {
    links {
      id
      nombre
      raza
      edad
      foto
      votes {
        id
      }
      postedBy {
        username
      }
    }
  }
  """;

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(readDogs),
      ),
      builder: (QueryResult result, {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (result.hasException) {
          return Text(result.exception.toString());
        }

        if (result.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        final List<dynamic> dogs = result.data!['links'];

        return ListView.builder(
          itemCount: dogs.length,
          itemBuilder: (context, index) {
            final dog = dogs[index];
            return ListTile(
              leading: Image.network(dog['foto']),
              title: Text(dog['nombre']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${dog['raza']}, ${dog['edad']} años'),
                  Text('Posted by: ${dog['postedBy']['username']}'),
                  Row(
                    children: [
                      IncrementVotesMutation(
                        dogId: dog['id'].toString(),
                        onCompleted: () {
                          if (refetch != null) {
                            refetch();
                          }
                        },
                      ),
                      Text('${dog['votes'].length} votes'),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

