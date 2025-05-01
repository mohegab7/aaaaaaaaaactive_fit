import 'package:active_fit/core/presentation/main_screen.dart';
import 'package:active_fit/features/login/cubit.dart';
import 'package:active_fit/features/login/states.dart';
import 'package:active_fit/features/register/Register_screen.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  var formkey = GlobalKey<FormState>();
  var emailcontroll = TextEditingController();
  var passwordcontroll = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    // return Scaffold();
    return BlocProvider(
        create: (BuildContext context) => LoginCuibt(),
        child: BlocConsumer<LoginCuibt, LoginStates>(
          builder: (context, state) {
            return Scaffold(
              body: SingleChildScrollView(
                child: Form(
                  key: formkey,
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20.0,
                        ),
                        const SizedBox(
                          width: 120,
                        ),
                        Center(
                          child: Text(
                            'LOGIN',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                       Center(
                         child: Image.asset('assets/icon/active_banner_top.png',height: 200,
                         width: 200
                         ,),
                       ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                10.0,
                              ),
                              border: Border.all(
                                width: 2,
                                color: const Color(0xff49D199),
                              ),
                            ),
                            child: TextFormField(
                              controller: emailcontroll,
                              style: Theme.of(context).textTheme.titleLarge,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return '     Please enter your email    ';
                                }
                                return null;
                              },
                              // onFieldSubmitted: onSubmit,
                              // controller: controller,

                              keyboardType: TextInputType.emailAddress,

                              decoration: InputDecoration(
                                labelStyle:
                                    Theme.of(context).textTheme.titleLarge,
                                labelText: 'Email',
                                prefixIcon: const Icon(Icons.email_outlined),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                10.0,
                              ),
                              border: Border.all(
                                width: 2,
                                color: const Color(0xff49D199),
                              ),
                            ),
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return '     Please enter your Password';
                                }
                                return null;
                              },
                              onFieldSubmitted: (value) {
                                if (formkey.currentState!.validate()) {
                                  LoginCuibt.get(context).userLogin(
                                    email: emailcontroll.text,
                                    password: passwordcontroll.text,
                                  );
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MainScreen(),
                                    ),
                                    (route) => false,
                                  );
                                }
                              },
                              controller: passwordcontroll,
                              obscureText: LoginCuibt.get(context).ispassword,
                              keyboardType: TextInputType.visiblePassword,
                              style: Theme.of(context).textTheme.titleLarge,
                              decoration: InputDecoration(
                                labelStyle:
                                    Theme.of(context).textTheme.titleLarge,
                                labelText: 'password',
                                prefixIcon: const Icon(Icons.lock_outline),
                                border: InputBorder.none,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    LoginCuibt.get(context).changepassword();
                                  },
                                  icon: Icon(LoginCuibt.get(context).suffix),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   height: 30,
                        // ),

                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15),
                          child: ConditionalBuilder(
                            condition: true,
                            builder: (BuildContext context) {
                              return Container(
                                width: 370,
                                height: 52,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    if (formkey.currentState!.validate()) {
                                      LoginCuibt.get(context).userLogin(
                                        email: emailcontroll.text,
                                        password: passwordcontroll.text,
                                      );

                                      //   Navigator.pushAndRemoveUntil(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //       builder: (context) => MainScreen(),
                                      //     ),
                                      //     (route) => false,
                                      //   );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                  ).copyWith(
                                      elevation:
                                          ButtonStyleButton.allOrNull(0.0)),
                                  icon:
                                      const Icon(Icons.navigate_next_outlined),
                                  label: Text('Login',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge),
                                ),
                              );
                            },
                            fallback: (Context) =>
                                Center(child: CircularProgressIndicator()),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 15),
                            child: Container(
                              width: 370,
                              height: 52,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RegisterScreen()),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                  ).copyWith(
                                      elevation:
                                          ButtonStyleButton.allOrNull(0.0)),
                                  icon:
                                      const Icon(Icons.navigate_next_outlined),
                                  label: Text('Register',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge)),
                            )),

                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // IconButton(
                            //   icon: FaIcon(
                            //     FontAwesomeIcons.facebook,
                            //     color: Colors.blue,
                            //     size: 40,
                            //   ),
                            //   onPressed: () {
                            //   LoginCuibt.get(context).loginwithfacbook();
                            //   },
                            // ),
                            const SizedBox(
                              width: 20,
                            ),
                            IconButton(
                                onPressed: () {LoginCuibt.get(context).signInWithGoogle();},
                                icon: const FaIcon(FontAwesomeIcons.google,
                                    size: 35)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          listener: (context, state) {
            if (state is LoginErrorState) {
              Fluttertoast.showToast(
                msg: 'error email or password',
                backgroundColor: Colors.red,
                fontSize: 20,
                toastLength: Toast.LENGTH_LONG,
                timeInSecForIosWeb: 5,
                textColor: Colors.white,
                gravity: ToastGravity.BOTTOM,
              );
            }
            if (state is LoginSuccessState) {
              // CacheHelper.saveData(key: 'uId', value: state).then((value) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => MainScreen(),
                ),
                (route) => false,
              );
            }
              // );
            // }
            
            if (state is LoginWithGoogleSuccessState) {
              // CacheHelper.saveData(key: 'uId', value: state).then((value) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => MainScreen(),
                ),
                (route) => false,
              );
            }
            // );
            // }
          },
        ));
  }
}
// CacheHelper.saveData(key: 'uId', value: state).then((value) {
            //   Navigator.pushAndRemoveUntil(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => MainScreen(),
            //     ),
            //     (route) => false,
            //   );
            // }
