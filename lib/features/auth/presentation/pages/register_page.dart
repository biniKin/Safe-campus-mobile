// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:safe_campus/core/constants/images_string/images_string.dart';
// import 'package:safe_campus/core/constants/style/style.dart';
// import 'package:safe_campus/features/sos/presentation/bloc/register/register_bloc.dart';
// import 'package:safe_campus/features/sos/presentation/bloc/register/register_event.dart';
// import 'package:safe_campus/features/sos/presentation/bloc/register/register_state.dart';

// class RegisterPage extends StatefulWidget {
//   const RegisterPage({super.key});

//   @override
//   State<RegisterPage> createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _fullNameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _studentIdController = TextEditingController();
//   final _passwordController = TextEditingController();

//   @override
//   void dispose() {
//     _fullNameController.dispose();
//     _emailController.dispose();
//     _studentIdController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       context.read<RegisterBloc>().add(
//         RegisterSubmitted(
//           fullName: _fullNameController.text,
//           email: _emailController.text,
//           studentId: _studentIdController.text,
//           password: _passwordController.text,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<RegisterBloc, RegisterState>(
//       listener: (context, state) {
//         if (state is RegisterSuccess) {
//           Fluttertoast.showToast(msg: state.message);
//           Navigator.of(context).pushReplacementNamed('/signin');
//         } else if (state is RegisterFailure) {
//           Fluttertoast.showToast(msg: state.error);
//         }
//       },
//       builder: (context, state) {
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
//                     children: [
//                       const SizedBox(height: 20),
//                       Image.asset(
//                         ImagesString.appLogo,
//                         alignment: AlignmentGeometry.center,
//                         height: 200,
//                         width: 200,
//                       ),

//                       Text(
//                         'Create an account',
//                         style: GoogleFonts.poppins(
//                           fontSize: 32,
//                           fontWeight: FontWeight.bold,
//                           color: const Color(0xFF333333),
//                         ),
//                       ),

//                       const SizedBox(height: 40),
//                       TextFormField(
//                         controller: _fullNameController,
//                         decoration: InputDecoration(
//                           border: Style.outlineBorderStyle,
//                           labelText: 'Full name',
//                           prefixIcon: Icon(Icons.person),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your full name';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 20),
//                       TextFormField(
//                         controller: _emailController,
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
//                         controller: _studentIdController,
//                         decoration: InputDecoration(
//                           border: Style.outlineBorderStyle,
//                           labelText: 'Student ID',
//                           prefixIcon: Icon(Icons.badge),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return "Please enter your student ID";
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
//                         obscureText: true,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your password';
//                           }
//                           if (value.length < 6) {
//                             return 'Password must be at least 6 characters';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 20),
//                       ElevatedButton(
//                         onPressed:
//                             state is RegisterLoading ? null : _submitForm,
//                         style: ElevatedButton.styleFrom(
//                           minimumSize: const Size(double.infinity, 50),
//                           backgroundColor: Color(0xFF65558F),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         child:
//                             state is RegisterLoading
//                                 ? const CircularProgressIndicator(
//                                   color: Colors.white,
//                                 )
//                                 : Text(
//                                   'Register',
//                                   style: GoogleFonts.poppins(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: 17,
//                                   ),
//                                 ),
//                       ),
//                       const SizedBox(height: 12),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Text('Already have account?'),
//                           TextButton(
//                             onPressed:
//                                 () => Navigator.pushNamed(context, '/signin'),
//                             child: const Text(
//                               'Sign In',
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
