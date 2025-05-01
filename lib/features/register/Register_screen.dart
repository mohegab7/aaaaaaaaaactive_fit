import 'package:active_fit/features/login/login_screen.dart';
import 'package:active_fit/features/register/cubit.dart';
import 'package:active_fit/features/register/states.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  var namecontroll = TextEditingController();
  var phonecontroll = TextEditingController();
  var emailcontroll = TextEditingController();
  var passwordcontroll = TextEditingController();
  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => RegisterCuibt(),
        child: BlocConsumer<RegisterCuibt, RegisterStates>(
          builder: (context, state) {
            return Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Form(
                    key: formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.arrow_back_ios_new),
                            ),
                            const SizedBox(
                              width: 120,
                            ),
                            Text(
                              'Register',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        // Stack(
                        //   alignment: AlignmentDirectional.bottomCenter,
                        //   children: [
                        //     const SizedBox(
                        //       height: 5,
                        //     ),
                        //     Container(
                        //       decoration: BoxDecoration(
                        //         shape: BoxShape.circle,
                        //         color: Theme.of(context).scaffoldBackgroundColor,
                        //       ),
                        //       child: CircleAvatar(
                        //         radius: 65.0,
                        //         backgroundColor:
                        //             Theme.of(context).scaffoldBackgroundColor,
                        //         child: const CircleAvatar(
                        //           radius: 60.0,
                        //           backgroundImage: NetworkImage(
                        //               'https://plus.unsplash.com/premium_photo-1664474619075-644dd191935f?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8aW1hZ2V8ZW58MHx8MHx8fDA%3D'),
                        //         ),
                        //       ),
                        //     ),
                        //   Align(
                        //     alignment: const Alignment(0.2, 0),
                        //     child: Container(
                        //       width: 38,
                        //       height: 38,
                        //       decoration: BoxDecoration(
                        //         color: const Color(0xff35CC8C),
                        //         borderRadius: BorderRadius.circular(15),
                        //       ),
                        //       child: IconButton(
                        //           onPressed: () {},
                        //           icon: const Icon(Icons.camera_alt_outlined)),
                        //     ),
                        //   )
                        // ],
                        // ),
                        const SizedBox(
                          height: 20,
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
                              controller: namecontroll,
                              style: Theme.of(context).textTheme.titleLarge,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your Name';
                                }
                                return null;
                              },
                              // onFieldSubmitted: onSubmit,
                              // controller: controller,

                              keyboardType: TextInputType.text,

                              decoration: const InputDecoration(
                                labelText: 'Name',
                                prefixIcon: Icon(Icons.person_outline_sharp),
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
                              controller: emailcontroll,
                              style: Theme.of(context).textTheme.titleLarge,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your email';
                                }
                                return null;
                              },
                              // onFieldSubmitted: onSubmit,
                              // controller: controller,

                              keyboardType: TextInputType.emailAddress,

                              decoration: const InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email_outlined),
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
                                  return 'Please enter your phone';
                                }
                                return null;
                              },
                              // onFieldSubmitted: onSubmit,
                              controller: phonecontroll,
                              keyboardType: TextInputType.phone,
                              style: Theme.of(context).textTheme.titleLarge,
                              decoration: InputDecoration(
                                labelText: 'Phone',
                                prefixIcon: const Icon(Icons.phone),
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
                                  return 'Please enter your Password';
                                }
                                return null;
                              },
                              controller: passwordcontroll,
                              obscureText:
                                  RegisterCuibt.get(context).ispassword,
                              keyboardType: TextInputType.visiblePassword,
                              style: Theme.of(context).textTheme.titleLarge,
                              decoration: InputDecoration(
                                labelText: 'password',
                                prefixIcon: const Icon(Icons.lock_outline),
                                border: InputBorder.none,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    RegisterCuibt.get(context).changepassword();
                                  },
                                  icon: Icon(RegisterCuibt.get(context).suffix),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 90,
                        ),
                        ConditionalBuilder(
                          condition: state is! RegisterloadingState,
                          builder: (context) {
                            return Container(
                              width: 370,
                              height: 52,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  if (formkey.currentState!.validate()) {
                                    RegisterCuibt.get(context).userRegister(
                                      email: emailcontroll.text,
                                      password: passwordcontroll.text,
                                      name: namecontroll.text,
                                      phone: phonecontroll.text,
                                    );
                                    // Navigator.pushAndRemoveUntil(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => MainScreen(),
                                    //   ),
                                    //   (route) => false,
                                    // );
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
                                icon: const Icon(Icons.navigate_next_outlined),
                                label: Text('Register',
                                    style:
                                        Theme.of(context).textTheme.labelLarge),
                              ),
                            );
                          },
                          fallback: (context) => Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          listener: (context, state) {
            if (state is CreateUserSuccessState) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              );
            }
          },
        ));
    // return Scaffold();
  }
}
