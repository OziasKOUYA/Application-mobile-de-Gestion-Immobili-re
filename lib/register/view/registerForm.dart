
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../connexion/connexionUtils.dart';
import '../bloc/registerBloc.dart';
import '../models/Utilisateur.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final form = FormGroup({
    'profil': FormControl<String>(validators: [Validators.required]),
    'nom': FormControl<String>(validators: [Validators.required]),
    'prenom': FormControl<String>(validators: [Validators.required]),
    'username': FormControl<String>(validators: [Validators.required]),
    'email': FormControl<String>(validators: [Validators.required, Validators.email]),
    'telephone': FormControl<String>(validators: [Validators.required]),
    'password': FormControl<String>(
      validators: [
        Validators.required,
        Validators.pattern(RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$')),
      ],
    )
  });

  bool isClient = false;
  late TextEditingController phoneController;
  bool obscureText = true;
  bool isPhoneNumberValid = false;


  @override
  void initState() {
    super.initState();

    phoneController = TextEditingController(text: form.control('telephone').value);
    form.control('telephone').valueChanges.listen((value) {
      phoneController.text = value;
    });
  }

  void _onSubmit() async  {
    final isConnected =
    await InternetConnectivity.isConnected();
    if (isConnected) {
    if (form.valid && isPhoneNumberValid) {
      final profil = form.control('profil').value;
      final nom = form.control('nom').value;
      final prenom = form.control('prenom').value;
      final username = form.control('username').value;
      final email = form.control('email').value;
      final telephone = form.control('telephone').value;
      final password = form.control('password').value;

      if (profil == 'Client'){
        Utilisateur utilisateur = Utilisateur(
          nom: nom,
          prenom: prenom,
          username: username,
          email: email,
          telephone: telephone,
          password: password,

        );
        RegisterClientEvent event = RegisterClientEvent(utilisateur);
        BlocProvider.of<RegisterBloc>(context).add(event);
      } else {
        Utilisateur utilisateur = Utilisateur(
          nom: nom,
          prenom: prenom,
          username: username,
          email: email,
          telephone: telephone,
          password: password,

        );
        RegisterGerantEvent event = RegisterGerantEvent(utilisateur);
        BlocProvider.of<RegisterBloc>(context).add(event);
      }
    }}else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Pas de connexion Internet.'),
        duration: Duration(seconds: 3),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        /*shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),*/
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "S'inscrire",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
         /* Positioned.fill(
            top: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Theme.of(context).secondaryHeaderColor, Theme.of(context).primaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),*/
          Positioned.fill(
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Theme.of(context).primaryColor,Theme.of(context).secondaryHeaderColor, ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ReactiveForm(
                formGroup: form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      child: ReactiveDropdownField<String>(
                        formControlName: 'profil',
                        validationMessages: {'required': (error) => 'Champ requis.'},
                        decoration: InputDecoration(
                          labelText: 'Profil',
                        ),
                        items: ['Client', 'Gerant'].map((String profil) {
                          return DropdownMenuItem<String>(
                            value: profil,
                            child: Text(profil),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      child: ReactiveTextField(
                        formControlName: 'nom',
                        validationMessages: {'required': (error) => 'Champ requis.'},
                        decoration: InputDecoration(
                          labelText: 'Nom',
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      child: ReactiveTextField(
                        formControlName: 'prenom',
                        validationMessages: {'required': (error) => 'Champ requis.'},
                        decoration: InputDecoration(
                          labelText: 'Prénom',
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      child: ReactiveTextField(
                        formControlName: 'username',
                        validationMessages: {'required': (error) => 'Champ requis.'},
                        decoration: InputDecoration(
                          labelText: 'Nom d\'utilisateur',
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      child: ReactiveTextField(
                        formControlName: 'email',
                        validationMessages: {
                          'required': (error) => 'Champ requis.',
                          'email': (error) => 'Format de l\'email incorrect.',
                        },
                        decoration: InputDecoration(labelText: 'Email'),
                      ),

                    ),
                    SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      child: InternationalPhoneNumberInput(
                        onInputChanged: (PhoneNumber number) {
                          if (number.phoneNumber != null) {
                            form.control('telephone').value = number.phoneNumber!;
                          }
                        },
                        onInputValidated: (bool value) {
                          setState(() {
                            isPhoneNumberValid = value;
                          });
                          form.control('telephone').updateValueAndValidity();
                        },
                        selectorConfig: SelectorConfig(selectorType: PhoneInputSelectorType.BOTTOM_SHEET),
                        ignoreBlank: false,
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        errorMessage: "Veuillez entrer un numéro de téléphone valide",
                        selectorTextStyle: TextStyle(color: Colors.black),
                        initialValue: PhoneNumber(isoCode: 'TG'),
                        inputDecoration: InputDecoration(
                          hintText: 'Numéro de téléphone',
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      child: ReactiveTextField(
                        formControlName: 'password',
                        validationMessages: {
                          'required': (error) => 'Champ requis.',
                          'pattern': (error) =>
                          'Le mot de passe doit contenir au moins une minuscule, une majuscule, un chiffre et avoir au moins 8 caractères.',
                        },
                        decoration: InputDecoration(
                          labelText: 'Mot de passe',
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscureText ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                          ),
                        ),
                        obscureText: obscureText,
                      ),
                    ),

                    SizedBox(height: 16),
                    BlocConsumer<RegisterBloc, RegisterState>(
                      listener: (context, state) {
                        if (state is RegisterSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Inscription réussie')),
                          );
                          Navigator.of(context).pop();
                        } else if (state is RegisterFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.error)),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is RegisterLoading) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ElevatedButton(
                          onPressed: _onSubmit,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            // You can also customize the button's color, padding, etc. here.
                          ),
                          child: Text(
                            'Envoyer',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
