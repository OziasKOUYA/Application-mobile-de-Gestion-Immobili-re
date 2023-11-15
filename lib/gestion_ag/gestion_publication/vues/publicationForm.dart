import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../gestion_immeuble/bloc/immeubleBloc.dart';
import '../../gestion_immeuble/models/Immeuble.dart';
import '../models/Publication.dart';
import 'package:image_picker/image_picker.dart';

class PublicationForm extends StatefulWidget {
  final Function(Publication, File?) onSubmit;
  PublicationForm({required this.onSubmit});

  @override
  _PublicationFormState createState() => _PublicationFormState();
}

class _PublicationFormState extends State<PublicationForm> {
  late String contenu;
  Immeuble? selectedImmeuble;
  File? image;

  final TextEditingController contenuController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _selectImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // Wrap the entire content with SingleChildScrollView
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Contenu',
                border: OutlineInputBorder(),
              ),
              controller: contenuController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer le contenu de la publication';
                }
                return null;
              },
              onChanged: (value) {
                contenu = value;
              },
            ),
            SizedBox(height: 20),
            Column(
              children: [
                InkWell(
                  onTap: () => _selectImage(ImageSource.gallery),
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: image != null
                        ? Image.file(
                      image!,
                      fit: BoxFit.cover,
                    )
                        : Icon(Icons.add_a_photo),
                  ),
                ),
                SizedBox(height: 10),
                Text('Sélectionner une image de l\'immeuble'),
              ],
            ),
            SizedBox(height: 16.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
              child: BlocBuilder<ImmeubleBloc, ImmeubleState>(
                builder: (context, state) {
                  if (state is ImmeubleLoadSuccess) {
                    final immeubles = state.immeubles;
                    return DropdownButtonFormField<Immeuble>(
                      decoration: InputDecoration.collapsed(
                          hintText: 'Sélectionnez un immeuble'),
                      value: selectedImmeuble,
                      onChanged: (Immeuble? immeuble) {
                        setState(() {
                          selectedImmeuble = immeuble;
                        });
                      },
                      items: immeubles.map<DropdownMenuItem<Immeuble>>(
                            (immeuble) => DropdownMenuItem<Immeuble>(
                          value: immeuble,
                          child: Text('Code: ${immeuble.code}'),
                        ),
                      ).toList(),
                    );
                  }
                  return Container();
                },
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 12.0),
              ),
              child: Text('Publier', style: TextStyle(fontSize: 16.0)),
              onPressed: () {
                if (_formKey.currentState?.validate() == true &&
                    selectedImmeuble != null) {
                  widget.onSubmit(
                    Publication(
                      contenu: contenu,
                      image: image?.path,
                      immeuble: selectedImmeuble?.id,
                    ),
                    image,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
