import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/Immeuble.dart'; // Make sure to import the correct path for your Immeuble model

class ImmeubleForm extends StatefulWidget {
  final Immeuble? initialImmeuble;
  final Function(Immeuble) onSubmit;
  ImmeubleForm({this.initialImmeuble, required this.onSubmit});

  @override
  _ImmeubleFormState createState() => _ImmeubleFormState();
}

class _ImmeubleFormState extends State<ImmeubleForm> {
  late int? id;
  late String? code;
  late String? description;
  late int? proprietaire;

  final TextEditingController codeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController proprietaireController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    id = widget.initialImmeuble?.id;
    code = widget.initialImmeuble?.code ?? '';
    codeController.text = code!;
    description = widget.initialImmeuble?.description ?? '';
    descriptionController.text = description!;
    proprietaire = widget.initialImmeuble?.proprietaire;
    proprietaireController.text = proprietaire.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Code'),
            controller: codeController,
            onChanged: (value) {
              code = value;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Description'),
            controller: descriptionController,
            onChanged: (value) {
              description = value;
            },
          ),
          ElevatedButton(
            child: Text('Envoyer'),
            onPressed: () {
              if (_formKey.currentState?.validate() == true) {
                widget.onSubmit(Immeuble(
                  id: id,
                  code: code,
                  description: description,
                  proprietaire: proprietaire,
                ));
              }
            },
          ),
        ],
      ),
    );
  }
}
