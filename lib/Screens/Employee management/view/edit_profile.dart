import 'package:aeon_hrms/Screens/Employee%20management/controller/employee_controller.dart';
import 'package:aeon_hrms/Screens/Employee%20management/view/employee_card_screen.dart';
import 'package:aeon_hrms/Utility/MLString.dart';
import 'package:aeon_hrms/Utility/api_constants.dart';
import 'package:aeon_hrms/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:aeon_hrms/Screens/Employee%20management/model/employeeDetailsModel.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String gender = 'Male';

  final EmployeeController employeeController = Get.put(EmployeeController());

  @override
  void initState() {
    super.initState();
    employeeController.getEmployeeDetails();
  }

  List<EmpType> employeeData = [];
  bool isLoading = false;
  Future<void> getdata() async {
    setState(() {
      isLoading = true;
    });
    await employeeController.getEmployeeDetails();

    setState(() {
      isLoading = false;
    });
  }

  DropdownButton<String> getGender() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String gender in genderList) {
      var item = DropdownMenuItem(value: gender, child: Text(gender));
      dropDownItems.add(item);
    }
    return DropdownButton(
      items: dropDownItems,
      value: gender,
      onChanged: (value) {
        setState(() {
          gender = value!;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: kMainColor,
      appBar: AppBar(
        backgroundColor: kMainColor,
        elevation: 0.0,
        titleSpacing: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Profile',
          maxLines: 2,
          style: kTextStyle.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: GetBuilder(
          builder: (EmployeeController controller) {
            final employee = controller.employeeDetailsModel?.data?.firstOrNull;
            return controller.isempDetailsLoading == true
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20.0),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20.0),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                          ),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 20.0),
                            GestureDetector(
                              onTap: () async {
                                await controller.getImage(
                                  context,
                                  ImageSource.camera,
                                );
                              },
                              child: FutureBuilder<PickedFile>(
                                builder: (context, snap) {
                                  if (controller.pickedFile != null) {
                                    return ClipOval(
                                      child: Image.file(
                                        controller.pickedFile!,
                                        width: 90,
                                        height: 90,
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  }
                                  return Container(
                                    height: 90,
                                    width: 90,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 0.1,
                                        color: const Color.fromARGB(
                                          255,
                                          201,
                                          57,
                                          226,
                                        ),
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(50),
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.network(
                                        controller
                                                        .employeeDetailsModel
                                                        ?.data
                                                        ?.isNotEmpty ==
                                                    true &&
                                                controller
                                                        .employeeDetailsModel
                                                        ?.data
                                                        ?.first
                                                        .emPPICT !=
                                                    null &&
                                                controller
                                                        .employeeDetailsModel
                                                        ?.data
                                                        ?.first
                                                        .emPPICT !=
                                                    ""
                                            ? '${ApiConstant.imageUrl}/${IMAGES}/${controller.employeeDetailsModel?.data?.first.emPPICT}'
                                            : '${ApiConstant.imageUrl}/${IMAGES}/blankHuman.jpg',
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Image.asset(
                                                'images/blankHuman.jpg',
                                                fit: BoxFit.cover,
                                              );
                                            },
                                      ),
                                    ),
                                  );
                                },
                                future: null,
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            AppTextField(
                              textFieldType: TextFieldType.NAME,
                              decoration: InputDecoration(
                                labelText: 'Employee Code',
                                hintText:
                                    '${controller.employeeDetailsModel?.data?.first.emPCODE}',
                                enabled: false,
                                labelStyle: kTextStyle,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                border: const OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            AppTextField(
                              textFieldType: TextFieldType.NAME,
                              decoration: InputDecoration(
                                labelText: 'Employee Name',
                                hintText:
                                    '${controller.employeeDetailsModel?.data?.first.emPNAME}',
                                labelStyle: kTextStyle,
                                enabled: false,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                border: const OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            AppTextField(
                              textFieldType: TextFieldType.EMAIL,
                              decoration: InputDecoration(
                                labelText: 'Email Id',
                                enabled: false,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                hintText:
                                    '${controller.employeeDetailsModel?.data?.first.emailid}',
                                labelStyle: kTextStyle,
                                border: const OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            AppTextField(
                              textFieldType: TextFieldType.PHONE,
                              //controller: TextEditingController(),
                              decoration: InputDecoration(
                                labelText: 'Mobile No',
                                hintText:
                                    '${controller.employeeDetailsModel?.data?.first.mobileno}',
                                enabled: false,
                                labelStyle: kTextStyle,
                                border: const OutlineInputBorder(),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            AppTextField(
                              textFieldType: TextFieldType.USERNAME,
                              decoration: InputDecoration(
                                labelText: 'Department',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                hintText:
                                    '${controller.employeeDetailsModel?.data?.first.depTNAME}',
                                enabled: false,
                                labelStyle: kTextStyle,
                                border: const OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            AppTextField(
                              textFieldType: TextFieldType.USERNAME,
                              decoration: InputDecoration(
                                labelText: 'Designation',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                hintText:
                                    '${controller.employeeDetailsModel?.data?.first.dsGNAME}',
                                enabled: false,
                                labelStyle: kTextStyle,
                                border: const OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                          ],
                        ),
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }
}
