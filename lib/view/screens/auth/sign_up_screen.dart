import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:country_code_picker/country_code.dart';
import 'package:flutter/services.dart';
import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/data/model/body/signup_body.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_button.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';
import 'package:sixam_mart/view/base/custom_text_field.dart';
import 'package:sixam_mart/view/base/footer_view.dart';
import 'package:sixam_mart/view/base/menu_drawer.dart';
import 'package:sixam_mart/view/base/web_menu_bar.dart';
import 'package:sixam_mart/view/screens/auth/widget/code_picker_widget.dart';
import 'package:sixam_mart/view/screens/auth/widget/condition_check_box.dart';
import 'package:sixam_mart/view/screens/auth/widget/guest_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_number/phone_number.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _referCodeFocus = FocusNode();
  bool otpVerified = false;
  bool _isValid = GetPlatform.isWeb ? true : false;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _referCodeController = TextEditingController();
  String _countryDialCode;

  @override
  void initState() {
    super.initState();

    _countryDialCode = CountryCode.fromCountryCode(
            Get.find<SplashController>().configModel.country)
        .dialCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? WebMenuBar() : null,
      endDrawer: MenuDrawer(),
      body: SafeArea(
          child: Scrollbar(
        child: SingleChildScrollView(
          padding: ResponsiveHelper.isDesktop(context)
              ? EdgeInsets.zero
              : EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          physics: BouncingScrollPhysics(),
          child: FooterView(
            child: Center(
              child: Container(
                width: context.width > 700 ? 700 : context.width,
                padding: context.width > 700
                    ? EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT)
                    : null,
                margin: context.width > 700
                    ? EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT)
                    : null,
                decoration: context.width > 700
                    ? BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius:
                            BorderRadius.circular(Dimensions.RADIUS_SMALL),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey[Get.isDarkMode ? 700 : 300],
                              blurRadius: 5,
                              spreadRadius: 1)
                        ],
                      )
                    : null,
                child: GetBuilder<AuthController>(builder: (authController) {
                  return Column(children: [
                    Image.asset(Images.logo, width: 200),

                    Text('sign_up'.tr.toUpperCase(),
                        style: robotoBlack.copyWith(fontSize: 30)),
                    SizedBox(height: 50),

                    Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.RADIUS_SMALL),
                        color: Theme.of(context).cardColor,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey[Get.isDarkMode ? 800 : 200],
                              spreadRadius: 1,
                              blurRadius: 5)
                        ],
                      ),
                      child: Column(children: [
                        CustomTextField(
                          hintText: 'first_name'.tr,
                          controller: _firstNameController,
                          focusNode: _firstNameFocus,
                          nextFocus: _lastNameFocus,
                          inputType: TextInputType.name,
                          capitalization: TextCapitalization.words,
                          prefixIcon: Images.user,
                          divider: true,
                        ),
                        CustomTextField(
                          hintText: 'last_name'.tr,
                          controller: _lastNameController,
                          focusNode: _lastNameFocus,
                          nextFocus: _emailFocus,
                          inputType: TextInputType.name,
                          capitalization: TextCapitalization.words,
                          prefixIcon: Images.user,
                          divider: true,
                        ),
                        CustomTextField(
                          hintText: 'email'.tr,
                          controller: _emailController,
                          focusNode: _emailFocus,
                          nextFocus: _phoneFocus,
                          inputType: TextInputType.emailAddress,
                          prefixIcon: Images.mail,
                          divider: true,
                        ),
                        Row(children: [
                          CodePickerWidget(
                            onChanged: (CountryCode countryCode) {
                              _countryDialCode = countryCode.dialCode;
                            },
                            initialSelection: CountryCode.fromCountryCode(
                                    Get.find<SplashController>()
                                        .configModel
                                        .country)
                                .code,
                            favorite: [
                              CountryCode.fromCountryCode(
                                      Get.find<SplashController>()
                                          .configModel
                                          .country)
                                  .code
                            ],
                            showDropDownButton: true,
                            padding: EdgeInsets.zero,
                            showFlagMain: true,
                            dialogBackgroundColor: Theme.of(context).cardColor,
                            textStyle: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                              color:
                                  Theme.of(context).textTheme.bodyText1.color,
                            ),
                          ),
                          Expanded(
                              child: AbsorbPointer(
                            absorbing: otpVerified,
                            child: CustomTextField(
                              hintText: 'Mobile Number',
                              controller: _phoneController,
                              focusNode: _phoneFocus,
                              nextFocus: _passwordFocus,
                              inputType: TextInputType.phone,
                              divider: false,
                            ),
                          )),
                        ]),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_LARGE),
                            child: Divider(height: 1)),
                        CustomTextField(
                          hintText: 'password'.tr,
                          controller: _passwordController,
                          focusNode: _passwordFocus,
                          nextFocus: _confirmPasswordFocus,
                          inputType: TextInputType.visiblePassword,
                          prefixIcon: Images.lock,
                          isPassword: true,
                          divider: true,
                        ),
                        CustomTextField(
                          hintText: 'confirm_password'.tr,
                          controller: _confirmPasswordController,
                          focusNode: _confirmPasswordFocus,
                          nextFocus: Get.find<SplashController>()
                                      .configModel
                                      .refEarningStatus ==
                                  1
                              ? _referCodeFocus
                              : null,
                          inputAction: Get.find<SplashController>()
                                      .configModel
                                      .refEarningStatus ==
                                  1
                              ? TextInputAction.next
                              : TextInputAction.done,
                          inputType: TextInputType.visiblePassword,
                          prefixIcon: Images.lock,
                          isPassword: true,
                          onSubmit: (text) =>
                              (GetPlatform.isWeb && authController.acceptTerms)
                                  ? _register(authController, _countryDialCode)
                                  : null,
                        ),
                        (Get.find<SplashController>()
                                    .configModel
                                    .refEarningStatus ==
                                1)
                            ? CustomTextField(
                                hintText: 'refer_code'.tr,
                                controller: _referCodeController,
                                focusNode: _referCodeFocus,
                                inputAction: TextInputAction.done,
                                inputType: TextInputType.text,
                                capitalization: TextCapitalization.words,
                                prefixIcon: Images.refer_code,
                                divider: false,
                                prefixSize: 14,
                              )
                            : SizedBox(),
                      ]),
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                    ConditionCheckBox(authController: authController),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                    !authController.isLoading
                        ? Row(children: [
                            Expanded(
                                child: CustomButton(
                              buttonText: 'sign_in'.tr,
                              transparent: true,
                              onPressed: () => Get.toNamed(
                                  RouteHelper.getSignInRoute(
                                      RouteHelper.signUp)),
                            )),
                            Expanded(
                                child: CustomButton(
                              buttonText: otpVerified
                                  ? 'sign_up'.tr.toUpperCase()
                                  : "Verify OTP",
                              onPressed: authController.acceptTerms
                                  ? () => _register(
                                      authController, _countryDialCode)
                                  : null,
                            )),
                          ])
                        : Center(child: CircularProgressIndicator()),
                    SizedBox(height: 30),

                    // SocialLoginWidget(),

                    GuestButton(),
                  ]);
                }),
              ),
            ),
          ),
        ),
      )),
    );
  }

  void onLoading(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
              child: CircularProgressIndicator(color: Color(0xff181862)));
        });
  }

  void _register(AuthController authController, String countryCode) async {
    String _number = _phoneController.text.trim();
    String _numberWithCountryCode = countryCode + _number;

    if (_phoneController.text.length < 10) {
      showCustomSnackBar('invalid_phone_number'.tr);
      return;
    }

    if (!GetPlatform.isWeb && otpVerified == false) {
      try {
        onLoading(context);
        PhoneNumber phoneNumber =
            await PhoneNumberUtil().parse(_numberWithCountryCode);
        _numberWithCountryCode =
            '+' + phoneNumber.countryCode + phoneNumber.nationalNumber;
        _isValid = true;
        if (_isValid) {
          String phNo = phoneNumber.e164.toString();
          verifyPhone(phNo.toString(), authController);
          return;
        }
      } catch (e) {}
    }

    String _firstName = _firstNameController.text.trim();
    String _lastName = _lastNameController.text.trim();
    String _email = _emailController.text.trim();

    String _password = _passwordController.text.trim();
    String _confirmPassword = _confirmPasswordController.text.trim();
    String _referCode = _referCodeController.text.trim();
    if (!_isValid) {
      showCustomSnackBar('invalid_phone_number'.tr);
      return;
    }

    if (_firstName.isEmpty) {
      showCustomSnackBar('enter_your_first_name'.tr);
    } else if (_lastName.isEmpty) {
      showCustomSnackBar('enter_your_last_name'.tr);
    } else if (_email.isEmpty) {
      showCustomSnackBar('enter_email_address'.tr);
    } else if (!GetUtils.isEmail(_email)) {
      showCustomSnackBar('enter_a_valid_email_address'.tr);
    } else if (_number.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    } else if (!_isValid) {
      showCustomSnackBar('invalid_phone_number'.tr);
    } else if (_password.isEmpty) {
      showCustomSnackBar('enter_password'.tr);
    } else if (_password.length < 6) {
      showCustomSnackBar('password_should_be'.tr);
    } else if (_password != _confirmPassword) {
      showCustomSnackBar('confirm_password_does_not_matched'.tr);
    } else if (_referCode.isNotEmpty && _referCode.length != 10) {
      showCustomSnackBar('invalid_refer_code'.tr);
    } else {
      SignUpBody signUpBody = SignUpBody(
        fName: _firstName,
        lName: _lastName,
        email: _email,
        phone: _numberWithCountryCode,
        password: _password,
        refCode: _referCode,
      );
      authController.registration(signUpBody).then((status) async {
        if (status.isSuccess) {
          if (Get.find<SplashController>().configModel.customerVerification) {
            List<int> _encoded = utf8.encode(_password);
            String _data = base64Encode(_encoded);
            Get.toNamed(RouteHelper.getVerificationRoute(_numberWithCountryCode,
                status.message, RouteHelper.signUp, _data));
          } else {
            Get.toNamed(RouteHelper.getAccessLocationRoute(RouteHelper.signUp));
          }
        } else {
          showCustomSnackBar(status.message);
        }
      });
    }
  }

  _displayTextInputDialog(BuildContext context, String verID, String number) {
    TextEditingController textController = TextEditingController();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () async => false,
              child: StatefulBuilder(builder: (context, setState1) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(4.0)), //this right here
                  child: Container(
                    height: 300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppBar(
                          backgroundColor: Color(0xff181862),
                          automaticallyImplyLeading: false,
                          title: Text("Enter OTP"),
                          actions: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Get.back();
                              },
                            )
                          ],
                        ),
                        Text(
                          "\nEnter the OTP received in\n$number",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 17),
                        ),
                        Expanded(
                          child: OtpTextField(
                            numberOfFields: 6,
                            borderColor: Color(0xFF512DA8),
                            //set to true to show as box or false to show as dash
                            showFieldAsBox: true,
                            //runs when a code is typed in
                            onCodeChanged: (String code) {
                              //handle validation or checks here
                            },
                            //runs when every textfield is filled
                            onSubmit: (String verificationCode) {
                              signInWithSmsCode(verificationCode, verID);
                            }, // end onSubmit
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  backgroundColor: Colors.red),
                              onPressed: () => Get.back(),
                              child: new Text('Cancel'),
                            ),
                            SizedBox(width: 10),
                            TextButton(
                              style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  backgroundColor: Colors.black),
                              onPressed: () {},
                              child: new Text('Submit'),
                            ),
                            SizedBox(width: 20),
                          ],
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                );
              }));
        });
  }

  String smsOTP;
  String verificationId;
  String errorMessage = '';
  FirebaseAuth _auth = FirebaseAuth.instance;
  AuthController _authController;
  Future<void> verifyPhone(phoneNo, AuthController authController) async {
    _authController = authController;
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      Get.back();
      showCustomSnackBar('OTP Sent Successfully');
      _displayTextInputDialog(context, verId, phoneNo);

      // signInWithSmsCode("000001", verId);
    };
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNo, // PHONE NUMBER TO SEND OTP
        codeAutoRetrievalTimeout: (String verId) {
          //Starts the phone number verification process for the given phone number.
          //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
          this.verificationId = verId;
        },
        codeSent:
            smsOTPSent, // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
        timeout: const Duration(seconds: 20),
        verificationCompleted: (AuthCredential phoneAuthCredential) {
          print(phoneAuthCredential);
        },
        verificationFailed: (exceptio) {
          print('${exceptio.message}');
        },
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> signInWithSmsCode(String smsCode, String verCode) async {
    final AuthCredential authCredential = PhoneAuthProvider.credential(
      smsCode: smsCode,
      verificationId: verCode,
    );
    try {
      await _auth.signInWithCredential(authCredential);
      FocusScope.of(context).nextFocus();
      Get.back();
      setState(() {
        otpVerified = true;
      });
      showCustomSnackBar('OTP Verified Successfully');
      _register(_authController, _countryDialCode);
      // showCustomSnackBar(
      //     'Please enter your Phone Number and Password to SIGN IN');
    } on PlatformException catch (e) {
      showCustomSnackBar('Something went wrong. Please try again later');
      throw Exception(e);
    } on FirebaseAuthException {
      showCustomSnackBar('Please Check the OTP');
    }
  }
}
