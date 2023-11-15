import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_immobiliere/gestion_ag/gestion_immeuble/vues/immeubleVue.dart';
import 'package:gestion_immobiliere/gestion_ag/gestion_publication/vues/publicationVue.dart';
import '../../authentification/blocs/authenticationBloc.dart';
import '../../connexion/connexionUtils.dart';
import '../../register/bloc/registerBloc.dart';

class HomeGerant extends StatefulWidget {
  const HomeGerant({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const HomeGerant());
  }

  @override
  _HomeGerantState createState() => _HomeGerantState();
}

class _HomeGerantState extends State<HomeGerant> {
  int currentIndex = 0;

  @override

  Widget build(BuildContext context) {
    final id = (context.select((AuthenticationBloc bloc) => bloc.state.user.idUser)) as int;

    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, blocState) {
        if (blocState is GetGerantSuccess) {
          final utilisateur = blocState.utilisateur;

          return Scaffold(
            appBar: AppBar(
              title: const Text('GESTION IMMOBILIERE'),
              centerTitle: true,
              elevation: 0,
            ),
            drawer: Drawer(
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        UserAccountsDrawerHeader(
                          accountName: Text(utilisateur.username!),
                          accountEmail: Text(utilisateur.email!),
                          currentAccountPicture:CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Text(
                              '${utilisateur.nom?[0].toUpperCase()}${utilisateur.prenom?[0].toUpperCase()}',
                              style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ListTile(
                            leading: Icon(Icons.description,
                                color: Theme.of(context).primaryColor),
                            title: Text('Publications'),
                            onTap: () {
                              setState(() {
                                currentIndex = 0;
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ListTile(
                            leading: Icon(Icons.business,
                                color: Theme.of(context).primaryColor),
                            title: Text('Immmeubles'),
                            onTap: () {
                              setState(() {
                                currentIndex = 1;
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ),

                      ],
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: ListTile(
                        leading: Icon(Icons.logout, color: Colors.red),
                        title: Text('Déconnexion'),
                        onTap: () async {
                          final isConnected = await InternetConnectivity.isConnected();
                          if (isConnected) {
                            context
                                .read<AuthenticationBloc>()
                                .add(AuthenticationLogoutRequested(context));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Pas de connexion Internet.'),
                              duration: Duration(seconds: 3),
                            ));
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: IndexedStack(
                index: currentIndex,
                children: <Widget>[
                  PublicationPage(id: id),
                 ImmeublePage(id:id),


                ],
              ),
            ),
          );
        }

        // Handle other states if needed
        return Container(); // Placeholder for other states
      },
    );
  }
}
