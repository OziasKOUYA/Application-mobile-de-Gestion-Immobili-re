import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../connexion/bloc/connexionBloc.dart';
import '../../../connexion/connexionUtils.dart';
import '../bloc/immeubleBloc.dart';
import '../models/Immeuble.dart';
import 'immeubleForm.dart';

class ImmeublePage extends StatefulWidget {
  final int id;

  const ImmeublePage({Key? key, required this.id}) : super(key: key);

  @override
  _ImmeublePageState createState() => _ImmeublePageState();
}

class _ImmeublePageState extends State<ImmeublePage> {
  final TextEditingController _searchController = TextEditingController();
  bool _searching = false;
  List<Immeuble> _filteredImmeubles = [];

  @override
  void initState() {
    super.initState();
    context.read<ImmeubleBloc>().add(LoadImmeubles(id: widget.id));
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _searching = true;
    });
  }

  void _showAddImmeubleDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ajouter un Immeuble'),
          content: ImmeubleForm(onSubmit: (Immeuble immeuble) async {
            final isConnected = await InternetConnectivity.isConnected();
            if (isConnected) {
              context.read<ImmeubleBloc>().add(AddImmeuble(widget.id, immeuble));
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red,
                content: Text('Pas de connexion Internet.'),
                duration: Duration(seconds: 3),
              ));
            }
          }),
        );
      },
    );
  }
  void _showUpdateImmeubleDialog(Immeuble immeuble) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Modifier un Immeuble'),
          content: ImmeubleForm(
            initialImmeuble: immeuble,
            onSubmit: (Immeuble updatedImmeuble) async {
              final isConnected = await InternetConnectivity.isConnected();
              if (isConnected) {
                context
                    .read<ImmeubleBloc>()
                    .add(UpdateImmeuble(widget.id, updatedImmeuble));
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('Pas de connexion Internet.'),
                  duration: Duration(seconds: 3),
                ));
              }
            },
          ),
        );
      },
    );
  }

  void _deleteImmeuble(int? idImmeuble) async {
    final isConnected = await InternetConnectivity.isConnected();
    if (isConnected) {
      context.read<ImmeubleBloc>().add(DeleteImmeuble(widget.id, idImmeuble!));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text('Pas de connexion Internet.'),
        duration: Duration(seconds: 3),
      ));
    }
  }
  void _showDetailsBottomSheet(Immeuble immeuble) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text('ID'),
                  subtitle: Text('${immeuble.id ?? 'N/A'}'),
                ),
                ListTile(
                  title: Text('Code'),
                  subtitle: Text(immeuble.code ?? 'N/A'),
                ),
                ListTile(
                  title: Text('Description'),
                  subtitle: Text(immeuble.description ?? 'N/A'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Immeubles'),
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
          if (connexionState is ConnectionSuccessState) {
            return BlocBuilder<ImmeubleBloc, ImmeubleState>(
              builder: (context, state) {
                if (state is ImmeubleOperationFailure) {
                  return SizedBox.shrink();
                }
                if (state is ImmeubleLoadInProgress) {
                  return Center(child: CircularProgressIndicator());
                }

                if (state is ImmeubleLoadSuccess) {
                  final immeubles = state.immeubles.reversed.toList();
                  final searchQuery = _searchController.text.toLowerCase();
                  _filteredImmeubles = immeubles.where((immeuble) {
                    final codeMatches = immeuble.code != null &&
                        immeuble.code!.toLowerCase().contains(searchQuery);
                    final descriptionMatches = immeuble.description != null &&
                        immeuble.description!.toLowerCase().contains(searchQuery);
                    return codeMatches || descriptionMatches;
                  }).toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  labelText: 'Rechercher',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                                  prefixIcon: Icon(Icons.search, color:Theme.of(context).secondaryHeaderColor),
                                  suffixIcon: _searchController.text.isNotEmpty
                                      ? IconButton(
                                    icon: Icon(Icons.clear, color:Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        _searchController.clear();
                                        _searching = false;
                                      });
                                    },
                                  )
                                      : null,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Scrollbar(
                          thumbVisibility: false,
                          child: RefreshIndicator(
                            onRefresh: () async {
                              final isConnected = await InternetConnectivity.isConnected();
                              if (isConnected) {
                                context.read<ImmeubleBloc>().add(
                                    LoadImmeubles(id: widget.id)
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
                              itemCount: _searching
                                  ? _filteredImmeubles.length
                                  : immeubles.length,
                              itemBuilder: (context, index) {
                                final Immeuble immeuble = _searching
                                    ? _filteredImmeubles[index]
                                    : immeubles[index];

                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  elevation: 2.0,
                                  child: ListTile(
                                    leading: Icon(Icons.description_outlined,
                                        color: Theme.of(context).secondaryHeaderColor),
                                    title: Text('Code: ${immeuble.code}'),
                                    subtitle: Text(
                                        'Description: ${immeuble.description ?? 'N/A'}'
                                    ),
                                    onTap: () {
                                      _showDetailsBottomSheet(immeuble);
                                    },
                                    onLongPress: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              ListTile(
                                                leading: Icon(Icons.edit),
                                                title: Text('Modifier'),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  _showUpdateImmeubleDialog(immeuble);
                                                },
                                              ),
                                              ListTile(
                                                leading: Icon(Icons.delete),
                                                title: Text('Supprimer'),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  _deleteImmeuble(immeuble.id);
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
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
      floatingActionButton: FloatingActionButton(
        heroTag: "fab78",
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        onPressed: _showAddImmeubleDialog,
      ),
    );
  }
}
