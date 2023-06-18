import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hfc/controllers/signup_controller.dart';
import 'package:hfc/pages/home_page.dart';
import 'package:hfc/pages/loader.dart';

import 'package:hfc/pages/widget/Header_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../common/theme_helper.dart';
import '../models/user.dart';
import 'login_page.dart';
import '../reposiontrys/user_reposiontry.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RegistrationPageState();
  }
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.put(SignUpController());
  bool checkedValue = false;
  bool checkboxValue = false;
  bool passToggle = true;
  var manUrl = "./assets/images/man_icon.png";
  var womanUrl = "./assets/images/woman_icon.png";
  var urlImage = "./assets/images/man_icon.png";
  bool isUploudPic = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var womanNetworkUrl = "https://firebasestorage.googleapis.com/v0/b/hfc-app-b33ed.appspot.com/o/Users%20Profile%20Photos%2Fwoman_icon.png?alt=media&token=c39682fb-7cf1-44ac-980e-896075df71ea";
  var manNetworkUrl = "https://firebasestorage.googleapis.com/v0/b/hfc-app-b33ed.appspot.com/o/Users%20Profile%20Photos%2Fman_icon.png?alt=media&token=3570ba04-d05e-404e-b850-6343acb5b525"; 

  //image varibales:
  final ImagePicker picker = ImagePicker();
  var genderInit = 0;
  late File img;
  late String imageUrl;

  var credential;
  @override
  void dispose() {
    // TODO: implement dispose
      controller.clear();
  
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Stack(
        children: [
          const SizedBox(
            height: 150,
            child: HeaderWidget(150, false, Icons.person_add_alt_1_rounded),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(25, 50, 25, 10),
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            alignment: Alignment.center,
            child: Column(children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    //picture:
                    imageProfile(),
                    const SizedBox(height: 30),
                    //gender:
                    genderToggle(),
                    const SizedBox(height: 30),
                    //full name:
                    fullName(),
                    const SizedBox(height: 20),
                    //email:
                    email(),
                    const SizedBox(height: 20),
                    //phone number:
                    //phone(),
//                    const SizedBox(height: 20),
                    //password:
                    password(),
                    const SizedBox(height: 20),
                    //accept terms:
                    terms(context),
                    const SizedBox(height: 10.0),
                    //submit:
                    Container(
                        decoration: ThemeHelper().buttonBoxDecoration(context),
                        child: ElevatedButton(
                          style: ThemeHelper().buttonStyle(),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                            child: Text(
                              "Sign In".toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          onPressed: () async {
                            // Validate returns true if the form is valid, or false otherwise.
                            if (_formKey.currentState!.validate()) {
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Loader()));
                              signUpByEmailAndPassword();
                              FirebaseAuth.instance
                                  .authStateChanges()
                                  .listen((User? user) async {
                                if (user != null) {
                                 final user = await addUserDetails();
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage()));
                                }
                                else{
                                 print('User is currently signed out!');

                                  //    Navigator.pop(context);
                                  // Navigator.pushReplacement(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             RegistrationPage()));
                                
                                }
                              });
                            }
                          },
                        )),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          child: Text(
                            'Login now',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          },
                        ),
                      ],
                    )
                  ],
                ),
              )
            ]),
          ),
        ],
      )),
    );
  }

  // ElevatedButton googleButton(BuildContext context) {
  //   return ElevatedButton.icon(
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: Colors.white,
  //                   foregroundColor: Colors.black,
  //                   minimumSize: Size(double.infinity, 50),
  //                 ),
  //                 icon: FaIcon(FontAwesomeIcons.google,color: Colors.red,),
  //                 label: Text("Sign Up with Google"),
  //                 onPressed: (){
  //                   final provider = Provider.of<GoogleSignInProvider>(context,listen: false);
  //                   provider.googleLogin();
  //                 },
  //                );
  // }

  FormField<bool> terms(BuildContext context) {
    return FormField<bool>(
      builder: (state) {
        return Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                // Checkbox(
                //     value: checkboxValue,
                //     onChanged: (value) {
                //       setState(() {
                //         checkboxValue = value!;
                //         state.didChange(value);
                //       });
                //     }),
                Checkbox(
                  value: checkboxValue,
                  onChanged: (bool? value) {
                    setState(() {
                      checkboxValue = value!;
                    });
                  },
                ),
                Text(
                  "I accept all terms and conditions.",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                state.errorText ?? '',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Theme.of(context).errorColor,
                  fontSize: 12,
                ),
              ),
            )
          ],
        );
      },
      validator: (value) {
        if (!checkboxValue) {
          return 'You need to accept terms and conditions';
        } else {
          return null;
        }
      },
    );
  }

  TextFormField password() {
    return TextFormField(
      keyboardType: TextInputType.visiblePassword,
      obscureText: passToggle,
      validator: (value) {
        if (value!.isEmpty) {
          return "Enter password";
        }
        if (value.length < 6) {
          return "Password should be more then 6 characters";
        }
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        prefixIcon: const Icon(Icons.fingerprint_outlined),
        fillColor: Colors.white,
        filled: true,
        contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100.0),
            borderSide: const BorderSide(color: Colors.grey)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100.0),
            borderSide: BorderSide(color: Colors.grey.shade400)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100.0),
            borderSide: const BorderSide(color: Colors.red, width: 2.0)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100.0),
            borderSide: const BorderSide(color: Colors.red, width: 2.0)),
        suffixIcon: InkWell(
          onTap: () {
            setState(() {
              passToggle = !passToggle;
            });
          },
          child: Icon(passToggle
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined),
        ),
      ),
      controller: controller.password,
    );
  }

  Container phone() {
    return Container(
      decoration: ThemeHelper().inputBoxDecorationShaddow(),
      child: TextFormField(
        decoration: ThemeHelper().textInputDecoration("Mobile Number",
            "Enter your mobile number", Icon(Icons.phone_android)),
        keyboardType: TextInputType.phone,
        // onChanged: (val){
        //     setState(() => number = val   );
        //   },
        validator: (val) {
          if (val!.isEmpty) {
            return "Enter phone number";
          } else {
            bool emailValidator = RegExp(
                    r"^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$$")
                .hasMatch(val);
            if (!emailValidator) {
              return "Enter a valid phone number";
            }
          }
          return null;
        },
      ),
    );
  }

  Container email() {
    return Container(
      decoration: ThemeHelper().inputBoxDecorationShaddow(),
      child: TextFormField(
        decoration: ThemeHelper().textInputDecoration(
            "Email", "Enter your email", const Icon(Icons.email_outlined)),
        keyboardType: TextInputType.emailAddress,
        controller: controller.email,
        validator: (value) {
          if (value!.isEmpty) {
            return "Enter email";
          }
          bool emailValidator =
              RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(value);
          if (!emailValidator) {
            return "Enter Valid email";
          }
        },
      ),
    );
  }

  // Container lastName() {
  //   return Container(
  //     decoration: ThemeHelper().inputBoxDecorationShaddow(),
  //     child: TextFormField(
  //         decoration: ThemeHelper()
  //             .textInputDecoration("Last name", "Enter your last name"),
  //         controller: lastNameController,
  //         validator: (value) {
  //           if (value!.isEmpty) {
  //             return "Enter your last name";
  //           }
  //         }),
  //   );
  // }

  Container fullName() {
    return Container(
      decoration: ThemeHelper().inputBoxDecorationShaddow(),
      child: TextFormField(
          decoration: ThemeHelper().textInputDecoration(
              "Full name",
              "Enter your full name",
              Icon(genderInit == 0
                  ? Icons.face_outlined
                  : Icons.face_3_outlined)),
          controller: controller.fullname,
          validator: (value) {
            if (value!.isEmpty) {
              return "Enter your full name";
            }
          }),
    );
  }

  ToggleSwitch genderToggle() {
    return ToggleSwitch(
      minWidth: 170.0,
      initialLabelIndex: genderInit,
      cornerRadius: 20.0,
      activeFgColor: Colors.white,
      inactiveBgColor: Colors.grey,
      inactiveFgColor: Colors.white,
      totalSwitches: 2,
      labels: const ['Male', 'Female'],
      icons: const [FontAwesomeIcons.mars, FontAwesomeIcons.venus],
      activeBgColors: const [
        [Colors.blue],
        [Colors.pink]
      ],
      onToggle: (index) {
        print('switched to: $index');
        genderInit = index!;
        setState(() {
          if (!isUploudPic) {
            if (index == 0) {
              urlImage = manUrl;
            } else {
              urlImage = womanUrl;
            }
          }
        });
      },
    );
  }

  GestureDetector imageProfile() {
    return GestureDetector(
        child: Stack(children: [
      CircleAvatar(
        radius: 60,
        backgroundImage:
            isUploudPic ? Image.file(img).image : AssetImage(urlImage),
        backgroundColor: Colors.white,
      ),
      Container(
        padding: const EdgeInsets.fromLTRB(75, 75, 0, 0),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey, //<-- SEE HERE
          child: IconButton(
            icon: const Icon(
              Icons.add_a_photo_outlined,
              color: Colors.white,
            ),
            onPressed: uploadPic,
          ),
        ),
      ),
    ]));
  }

  //we can upload image from camera or from gallery based on parameter
  getImage(ImageSource source) async {
    final pickedFile =
        await ImagePicker().pickImage(source: source, imageQuality: 10);

    // Get the application folder directory
    final directory = await getExternalStorageDirectory();

    if (pickedFile != null) {
      if (directory != null) {
        if (directory != null) {
          img = (await File(pickedFile.path)
              .copy('${directory.path}/${pickedFile.name}'));
          isUploudPic = true;
        }
      }
    }
    setState(() {}); //update image
  }

//create user
  signUpByEmailAndPassword() async {
    try {
      credential = await _auth.createUserWithEmailAndPassword(
          email: controller.email.text.trim(),
          password: controller.password.text.trim());
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
    }
    print(credential);
  }

  //show popup dialog
  uploadPic() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.image_outlined),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.camera_alt_outlined),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  }

  //add user details:
  Future addUserDetails() async {
    imageUrl = urlImage;
    if (isUploudPic) {
      var ref;
      ref = FirebaseStorage.instance
          .ref()
          .child("Users Profile Photos")
          .child(_auth.currentUser!.uid);
      await ref.putFile(img);
      // await Future.delayed(const Duration(seconds: 10), () {});
      imageUrl = await ref.getDownloadURL();
    }
    final user = UserModel(
        email: controller.email.text.trim().toLowerCase(),
        fullName: controller.fullname.text.trim(),
        urlImage: genderInit == 0 ? manNetworkUrl : womanNetworkUrl,
        gender: genderInit == 0 ? "male" : "female",
        password: controller.password.text.trim(),
        fillDetails: false,
        conversation:[],
        dailyCalories: 0.0,
        diary: {},
        weight: 0,
        height: 0,
        purpose: "",
        activity_level: ""
        );

    final rep = UserReposiontry();
    await rep.createUser(user);
  }
}
