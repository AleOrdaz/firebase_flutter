import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter/add.dart';
import 'package:firebase_flutter/auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _firebaseAuthService = AuthService();

  final usuario = TextEditingController();
  final password = TextEditingController();

  late bool _validateU = false;
  late bool _validateP = false;
  bool _passwordVisible = false;

  //Declarando el focusNode
  FocusNode _focusEmail =FocusNode();

  @override
  void initState() {
    //escuchando cambios de foco
    _focusEmail.addListener(() {

      if (_focusEmail.hasFocus){
        print("tiene el foco");
      } else {
        print("perdió el foco");
      }

    },);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size =  MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.only(
                left: size.width * 0.05,
                top: size.height * 0.2,
                right: size.width * 0.05,
              ),
              child:  Container(
                width: size.width * 0.85,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.black54,
                ),
                padding: const EdgeInsets.only(left: 25, right: 25, top: 80, bottom: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text(
                            'Iniciar Sesión',
                            style: TextStyle(
                              fontSize: 34,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 50,),
                    const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text(
                            'Usuario:',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                    TextFormField(
                      controller: usuario,
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            width: 1,
                            style: BorderStyle.none,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.person),
                        errorText: _validateU ?
                        'Debe de escribir su usuario' : null,
                        contentPadding: const EdgeInsets.only(
                          top: 10.0, bottom: 10.0, left: 15.0, right: 15.0,
                        ),
                      ),
                      style: const TextStyle(height: 1.5,),
                      onChanged: (text) {
                        setState((){
                          print("un cambio $text");
                          _validateU = false;
                          //_validateU = validarEmail();
                          if(text.trim().isNotEmpty) {
                            _validateU = false;
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 20,),
                    const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text(
                            'Contraseña:',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                    TextFormField(
                      controller: password,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: _passwordVisible ?
                          const Icon(Icons.visibility) :
                          const Icon(Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.password_outlined),
                        errorText: _validateP ?
                        'Debe de escribir su contraseña' : null,
                        contentPadding: const EdgeInsets.only(
                          top: 10.0, bottom: 10.0, left: 15.0, right: 15.0,
                        ),
                      ),
                      style: const TextStyle(height: 1.5,),
                      onChanged: (text) {
                        setState((){
                          if(text.trim().isNotEmpty) {
                            _validateP = false;
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 30,),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        fixedSize: Size(
                          MediaQuery.of(context).size.width * 0.8,
                          MediaQuery.of(context).size.height > 600 ? 45 : 40,
                        ),
                      ),
                      onPressed: () async {
                        _firebaseAuthService.createUserWithEmailAndPassword(usuario.text,  password.text).then((User? user) {
                          if (user != null) {
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> Add()));
                          } else {
                            _showErrorDialog('Ocurrió un error durante la creación de la cuenta');
                          }
                        });
                      },
                      child: const Text(
                        'Registrarse',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        fixedSize: Size(
                          MediaQuery.of(context).size.width * 0.8,
                          MediaQuery.of(context).size.height > 600 ? 45 : 40,
                        ),
                      ),
                      onPressed: () async {
                        subir();
                        /*final message = await AuthService().login(
                          email: usuario.text,
                          password: password.text,
                        );
                        if (message!.contains('Success')) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const Add(),
                            ),
                          );
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(message),
                          ),
                        );*/
                      },
                      child: const Text(
                        'Iniciar Sesión',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  void subir() {
    // Create a storage reference from our app
    final storageRef = FirebaseStorage.instance.ref();

    // Create a reference to "mountains.jpg"
    final mountainsRef = storageRef.child("majo.jpeg");

    // Create a reference to 'images/mountains.jpg'
    final mountainImagesRef = storageRef.child("images/majo.jpeg");

    // While the file names are the same, the references point to different files
    assert(mountainsRef.name == mountainImagesRef.name);
    assert(mountainsRef.fullPath != mountainImagesRef.fullPath);
  }
}
