import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../connexion/bloc/connexionBloc.dart';
import '../../../connexion/connexionUtils.dart';
import '../bloc/publicationBloc.dart';
import '../models/PublicationRes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';


class PublicationClientPage extends StatefulWidget {
  final int id;

  const PublicationClientPage({Key? key, required this.id}) : super(key: key);

  @override
  _PublicationClientPageState createState() => _PublicationClientPageState();
}

class _PublicationClientPageState extends State<PublicationClientPage> {
  @override
  void initState() {
    super.initState();
    context.read<PublicationBloc>().add(LoadPublications(id: widget.id));
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acceuil'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      body: BlocConsumer<ConnectionBloc, ConnexionState>(
        listener: (context, connexionState) {
          if (connexionState is ConnectionFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Pas de connexion Internet.'),
              duration: Duration(seconds: 3),
            ));
          }
        },
        builder: (context, connexionState) {
          Utf8Codec utf8codec = Utf8Codec();
          if (connexionState is ConnectionSuccessState) {
            return BlocBuilder<PublicationBloc, PublicationState>(
              builder: (context, state) {
                if (state is PublicationOperationFailure) {
                  return SizedBox.shrink();
                }
                if (state is PublicationLoadInProgress) {
                  return Center(child: CircularProgressIndicator());
                }

                if (state is PublicationLoadSuccess) {
                  final publications = state.publications.reversed.toList();

                  return Column(
                    children: [
                      Expanded(
                        child: Scrollbar(
                          thumbVisibility: false,
                          child: RefreshIndicator(
                            onRefresh: () async {
                              final isConnected = await InternetConnectivity.isConnected();
                              if (isConnected) {
                                context.read<PublicationBloc>().add(
                                    LoadPublications(id: widget.id)
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text('Pas de connexion Internet.'),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              }
                            },
                            child: ListView.builder(
                              padding: EdgeInsets.all(16.0),
                              itemCount: publications.length,
                              itemBuilder: (context, index) {
                                final PublicationRes publication = publications[index];
                                final owner = publication.immeuble?.proprietaire;

                                return Card(
                                  elevation: 2.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  margin: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              child: Text('${owner!.prenom?[0].toUpperCase()}${owner!.nom?[0].toUpperCase()}'),
                                            ),
                                            SizedBox(width: 8.0),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('${owner?.telephone}', style: TextStyle(fontWeight: FontWeight.bold)),
                                                Text('${owner?.nom} ${owner?.prenom}', style: TextStyle(color: Colors.grey)),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8.0),
                                        Text(
                                          DateFormat('dd MMM yyyy').format(publication.datePublication!),
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        if (publication.image != null)
                                          CachedNetworkImage(
                                            imageUrl: "${publication.image}",
                                            progressIndicatorBuilder: (context, url, downloadProgress) =>
                                                CircularProgressIndicator(value: downloadProgress.progress),
                                            errorWidget: (context, url, error) => Icon(Icons.error),
                                            fit: BoxFit.cover,
                                          ),
                                        SizedBox(height: 8.0),
                                        Text(utf8codec.decode('${publication.contenu}'.codeUnits), style: TextStyle(fontSize: 18.0)),
                                        SizedBox(height: 8.0),
                                        Text(utf8codec.decode('${publication.immeuble?.description ?? 'N/A'}'.codeUnits), style: TextStyle(color: Colors.blue)),
                                        SizedBox(height: 8.0),
                                        Divider(),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            /*IconButton(
                                              icon: Icon(Icons.delete),
                                              onPressed: () {
                                                _deletePublication(publication.id);
                                              },
                                            ),*/

                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }

                return Center(child: Text("Il n'y a pas de données."));
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
