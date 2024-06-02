import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class IncrementVotesMutation extends StatelessWidget {
  final String dogId;
  final VoidCallback onCompleted;

  IncrementVotesMutation({required this.dogId, required this.onCompleted});

  @override
  Widget build(BuildContext context) {
    return Mutation(
      options: MutationOptions(
        document: gql(r'''
          mutation VoteMutation($linkId: Int!) {
            createVote(linkId: $linkId) {
              link{
                id
                nombre
                raza
                edad
                foto
                votes {
                  id
                  user{
                    id
                 }
                }
              }
              user{
                id
              }
            }
          }
        '''),
        onCompleted: (dynamic resultData) {
          onCompleted();
        },
        onError: (error) {
          print("Error: $error");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("An error occurred")),
          );
        },
      ),
      builder: (RunMutation runMutation, QueryResult? result) {
        return IconButton(
          icon: Icon(Icons.thumb_up),
          onPressed: () {
            runMutation({'linkId': int.parse(dogId)});
          },
        );
      },
    );
  }
}

