import 'dart:io';
import 'dart:convert';

import 'package:aeon_hrms/Data/Model/UserDetails.dart';
import 'package:aeon_hrms/Data/Repositories/UserDetails_repository.dart';
import 'package:aeon_hrms/Screens/Home/Customshape.dart';
import 'package:aeon_hrms/Screens/Home/home_screen.dart';
import 'package:aeon_hrms/Utility/MLImage.dart';
import 'package:aeon_hrms/Utility/shared_preferences_service.dart';
import 'package:aeon_hrms/constant.dart';
import 'package:aeon_hrms/firebase_messaging/notification_firebase.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _usermobileController = TextEditingController();
  final TextEditingController _userpasswordController = TextEditingController();
  bool isChecked = true;
  bool _isLoading = false;
  bool _obscurePassword = true;
  UserModel? userModel;
  //late UserDetails _user;
  Future<void> checkValidity(BuildContext context) async {
    String usermobile = _usermobileController.text;
    String userpassword = _userpasswordController.text;

    // Checking all TextFields.
    if (usermobile == '' || userpassword == '') {
      Flushbar(
        title: "Please enter User Id. & Password.",
        message: "all fields are required...",
        icon: Icon(Icons.info_outline, size: 28.0, color: Colors.blue[300]),
        duration: const Duration(seconds: 5),
      ).show(context);
    } else {
      login1();
    }
  }

  @override
  void initState() {
    firebaseNotification(context);
    // TODO: implement initState
    super.initState();
  }

  void login1() async {
    setState(() {
      _isLoading = true;
    });
    final String deviceName = await getDeviceInfo();

    final Map<String, dynamic> data = <String, dynamic>{
      'UserID': _usermobileController.text,
      'Password': _userpasswordController.text,
      'DEVICE_NAME': deviceName,
    };
    try {
      final dataRepository = Provider.of<UserDetailsRepository>(
        context,
        listen: false,
      );
      final http.Response response = await dataRepository.login(data);
      userModel = UserModel.fromJson(json.decode(response.body));
      if (response.statusCode == 200) {
        userModel = UserModel.fromJson(json.decode(response.body));

        savePref(
          true,
          userModel!.data.first.empCode.toString(),
          userModel!.data.first.empName.toString(),
          userModel!.data.first.mobileno.toString(),
          userModel!.data.first.emailId.toString(),
          userModel!.data.first.locCode.toString(),
          userModel!.data.first.longitude.toString(),
          userModel!.data.first.latitude.toString(),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const HomeScreen(),
          ),
        );
      } else {
        Flushbar(
          title: "Error.",
          message: "Invalid Credentials.",
          icon: Icon(Icons.info_outline, size: 28.0, color: Colors.blue[300]),
          duration: const Duration(seconds: 5),
        ).show(context);
        throw Exception('Failed');
      }
    } catch (e) {
      Flushbar(
        title: "Error.",
        message: "Invalid Credentials.",
        icon: Icon(Icons.info_outline, size: 28.0, color: Colors.blue[300]),
        duration: const Duration(seconds: 5),
      ).show(context);
      // throw Exception('Failed');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> savePref(
    bool isLogedin,
    String userEmpCode,
    String userEmpName,
    String userMobileno,
    String emailId,
    String loccode,
    String longitude,
    String latitude,
  ) async {
    //SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      SharedPref.setvisitingflag();
      SharedPref.setEmpCode(userEmpCode);
      SharedPref.setEmpName(userEmpName);
      SharedPref.setMobileNo(userMobileno);
      SharedPref.setEmailId(emailId);
      SharedPref.setLocCode(loccode);
      SharedPref.setLongitude(longitude);
      SharedPref.setLatitude(latitude);
    });
  }

  Future<String> getDeviceInfo() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String model = "";
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      model = androidInfo.model;
    } else if (Platform.isIOS) {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      model = androidInfo.model;
    }
    if (!mounted) model;
    return model;
  }

  @override
  void dispose() {
    _usermobileController.dispose();
    _userpasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 130,
        backgroundColor: Colors.white,
        // elevation: 0.0,
        flexibleSpace: ClipPath(
          clipper: Customshape(),
          child: Container(
            height: 240,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 171, 224, 129),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Image.asset(company_logo, height: 72, width: 32),
            ),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding = constraints.maxWidth > 600 ? 72.0 : 30.0;
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 15),
                Transform.translate(
                  offset: const Offset(0, -2),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    padding: const EdgeInsets.fromLTRB(28, 38, 28, 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 22,
                          offset: const Offset(0, 7),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Welcome Back',
                          style: kTextStyle.copyWith(
                            color: const Color(0xFF202458),
                            fontSize: 31,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Login to your account to continue',
                          style: kTextStyle.copyWith(
                            color: const Color(0xFF8990A8),
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 34),
                        _buildInput(
                          controller: _usermobileController,
                          hint: 'User Id',
                          icon: Icons.person_outline,
                          accent: const Color(0xFF7652E9),
                        ),
                        const SizedBox(height: 18),
                        _buildInput(
                          controller: _userpasswordController,
                          hint: 'Password',
                          icon: Icons.lock_outline,
                          accent: const Color(0xFFF03D85),
                          obscureText: _obscurePassword,
                          suffixIcon: IconButton(
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: const Color(0xFF36383D),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        // Row(
                        //   children: [
                        //     Switch.adaptive(
                        //       value: isChecked,
                        //       activeThumbColor: const Color(0xFF35C66A),
                        //       onChanged: (value) =>
                        //           setState(() => isChecked = value),
                        //     ),
                        //     Text(
                        //       'Save Me',
                        //       style: kTextStyle.copyWith(
                        //         color: const Color(0xFF202458),
                        //         fontSize: 16,
                        //         fontWeight: FontWeight.w600,
                        //       ),
                        //     ),
                        //     const Spacer(),
                        //     TextButton(
                        //       onPressed: () =>
                        //           const ForgotPassword().launch(context),
                        //       style: TextButton.styleFrom(
                        //         padding: EdgeInsets.zero,
                        //       ),
                        //       child: const Text(
                        //         'Forgot Password?',
                        //         style: TextStyle(
                        //           color: Color(0xFF2D70D9),
                        //           fontSize: 15,
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 58,
                          child: ElevatedButton.icon(
                            onPressed: _isLoading
                                ? null
                                : () => checkValidity(context),
                            icon: const Icon(Icons.login, size: 25),
                            label: Text(
                              _isLoading ? 'Loading...' : 'Login',
                              style: const TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(
                                255,
                                171,
                                224,
                                129,
                              ),
                              // backgroundColor: const Color(0xFF5688EE),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 29),
                        Row(
                          children: [
                            const Expanded(
                              child: Divider(color: Color(0xFF9EA3AE)),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Text(
                                'OR',
                                style: kTextStyle.copyWith(
                                  color: const Color(0xFF858B9E),
                                ),
                              ),
                            ),
                            const Expanded(
                              child: Divider(color: Color(0xFF9EA3AE)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 26),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 26,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF8E6),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.spa,
                                color: Color(0xFF378E43),
                                size: 48,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '“Empowering Agriculture\nThrough People”',
                                textAlign: TextAlign.center,
                                style: kTextStyle.copyWith(
                                  color: const Color(0xFF378E43),
                                  fontSize: 20,
                                  height: 1.25,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 110),
                Container(
                  width: double.infinity,
                  color: const Color(0xFF43B953),
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 20,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'AVAYAYAYA AGRISOLUTIONS PRIVATE LIMITED',
                        textAlign: TextAlign.center,
                        style: kTextStyle.copyWith(
                          color: const Color(0xFF202458),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        'The Spring CHS FLH/302, Ploat NO.4 Sector 20 Kalamboli Node, Panvel, Raigarh(MH) - 410218',
                        textAlign: TextAlign.center,
                        style: kTextStyle.copyWith(
                          color: const Color(0xFF315A47),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required Color accent,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: kTextStyle.copyWith(color: const Color(0xFF4D5267), fontSize: 18),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF8990A8), fontSize: 18),
        prefixIcon: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: accent.withValues(alpha: 0.12),
          ),
          child: Icon(icon, color: accent, size: 27),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 14,
        ),
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: BorderSide(color: const Color(0xFFD9DCE4), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: BorderSide(color: accent, width: 2),
        ),
      ),
    );
  }
}

class _HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(0, size.height - 48)
      ..quadraticBezierTo(
        size.width / 2,
        size.height + 12,
        size.width,
        size.height - 48,
      )
      ..lineTo(size.width, 0)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
