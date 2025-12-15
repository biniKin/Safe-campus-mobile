// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:safe_campus/core/constants/images_string/images_string.dart';
// import 'package:safe_campus/core/constants/style/style.dart';
// import 'package:safe_campus/features/auth/presentation/bloc/login_bloc.dart';
// import 'package:safe_campus/features/auth/presentation/bloc/login_event.dart';
// import 'package:safe_campus/features/auth/presentation/bloc/login_state.dart';

// import 'dart:developer' as developer;

// class SignInPage extends StatefulWidget {
//   const SignInPage({super.key});

//   @override
//   State<SignInPage> createState() => _SignInPageState();
// }

// class _SignInPageState extends State<SignInPage> {
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController _studentIdController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   @override
//   void dispose() {
//     _studentIdController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<LoginBloc, LoginState>(
//       listener: (context, state) {
//         if (state is LoginFailure) {
//           Fluttertoast.showToast(msg: state.error);
//         } else if (state is LoginSuccess) {
//           developer.log('token: ${state.user.token}');
//           developer.log('userId: ${state.user.id}');
//           if (state.user.token.isEmpty) {
//             //Fluttertoast.showToast(msg: 'Token is empty');
//           } else {
//             //context.read<SocketBloc>().add(ConnectSocket(state.user.id, state.user.token));
//           }

//           Navigator.pushReplacementNamed(context, '/home');
//         }
//       },
//       builder: (context, state) {
//         if (state is LoginLoading) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }

//         return Scaffold(
//           body: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   Color.fromARGB(255, 192, 186, 222),
//                   Colors.grey.shade300,
//                   Colors.white,
//                 ],
//               ),
//             ),
//             child: SafeArea(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.symmetric(horizontal: 24),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       const SizedBox(height: 40),
//                       Image.asset(
//                         ImagesString.appLogo,
//                         alignment: AlignmentGeometry.center,
//                         height: 200,
//                         width: 200,
//                       ),
//                       Text(
//                         'Sign In',
//                         style: GoogleFonts.poppins(
//                           fontSize: 32,
//                           fontWeight: FontWeight.bold,
//                           color: const Color(0xFF333333),
//                         ),
//                       ),
//                       const SizedBox(height: 18),
//                       TextFormField(
//                         controller: _studentIdController,
//                         keyboardType: TextInputType.emailAddress,

//                         decoration: InputDecoration(
//                           border: Style.outlineBorderStyle,
//                           labelText: 'Email',
//                           prefixIcon: Icon(Icons.email),
//                         ),

//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return "Please enter your email";
//                           }
//                           if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//                             return 'Enter a valid email';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 20),
//                       TextFormField(
//                         controller: _passwordController,
//                         decoration: InputDecoration(
//                           border: Style.outlineBorderStyle,

//                           labelText: 'Password',
//                           prefixIcon: Icon(Icons.lock),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return "Please enter password";
//                           }
//                           return null;
//                         },
//                         obscureText: true,
//                       ),

//                       const SizedBox(height: 50),
//                       ElevatedButton(
//                         onPressed: () {
//                           if (_formKey.currentState!.validate()) {
//                             context.read<LoginBloc>().add(
//                               LoginSubmitted(
//                                 email: _studentIdController.text,
//                                 password: _passwordController.text,
//                               ),
//                             );
//                           }
//                         },
//                         style: ElevatedButton.styleFrom(
//                           minimumSize: const Size(double.infinity, 50),
//                           backgroundColor: const Color(0xFF65558F),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         child: Text(
//                           'Sign In',
//                           style: GoogleFonts.poppins(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w500,
//                             fontSize: 17,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Text("Don't have account?"),
//                           TextButton(
//                             onPressed:
//                                 () => Navigator.pushNamed(context, '/register'),
//                             child: const Text(
//                               'Register',
//                               style: TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
