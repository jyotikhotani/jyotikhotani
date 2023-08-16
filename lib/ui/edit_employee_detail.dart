import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:user_list_app/models/user_model.dart';
import 'package:user_list_app/ui/common_widgets/screen_util_wrapper.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:user_list_app/ui/employee_list.dart';
import 'package:user_list_app/utils/constants.dart';
import 'package:user_list_app/utils/locator.dart';
import 'common_widgets/text_feilds.dart';
import 'package:intl/intl.dart';

class EditEmployeeDetailScreen extends StatefulWidget {
  UserModel userData;
  int index;
  EditEmployeeDetailScreen(this.userData, this.index, {super.key});

  @override
  State<EditEmployeeDetailScreen> createState() =>
      _EditEmployeeDetailScreenState();
}

class _EditEmployeeDetailScreenState extends State<EditEmployeeDetailScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController selectProfileController = TextEditingController();
  TextEditingController joiningDateController = TextEditingController();
  TextEditingController leavingDateController = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();
  List<String> profileList = [
    "Product Designer",
    "Flutter Developer",
    "QA Tester",
    "Product Owner"
  ];
  String? selectedValue;
  String? formattedDate;
  DateTime? pickedDate;
  String? formattedTime;
  String? formatTimeStr;
  bool autovalidation = false;

  void updateUserData(UserModel user, int index) {
    List<String> jsonDataList = [];
    if (localStorageService.getuserDataFromDisk != null) {
      jsonDataList = localStorageService.getuserDataFromDisk!;
      jsonDataList[index] = jsonEncode(user);
      localStorageService.saveUserDataToDisk(jsonDataList);
    }
  }

  @override
  void initState() {
    setData();
    super.initState();
  }

  setData() {
    usernameController.text = widget.userData.userName!;
    selectProfileController.text = widget.userData.userProfile!;
    joiningDateController.text = widget.userData.joiningTime!;
    leavingDateController.text = widget.userData.leavingTime!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Employee List"),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formGlobalKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: ScreenUtilWrapper.setResponsiveSize(30),
                ),
                BorderTextFeild(
                  controller: usernameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please Enter Name";
                    } else {
                      return null;
                    }
                  },
                  labelText: StringConst.enterName,
                  autovalidateMode: autovalidation
                      ? AutovalidateMode.always
                      : AutovalidateMode.disabled,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Image.asset(
                      "assets/icons/user_icon.png",
                      width: 30,
                      height: 30,
                    ),
                  ),
                ),
                SizedBox(
                  height: ScreenUtilWrapper.setResponsiveSize(15),
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    customButton: BorderTextFeild(
                      controller: selectProfileController,
                      labelText: StringConst.selectRole,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Image.asset(
                          "assets/icons/profile.png",
                          width: 30,
                          height: 30,
                        ),
                      ),
                      isenabled: false,
                      readonly: true,
                      autovalidateMode: autovalidation
                          ? AutovalidateMode.always
                          : AutovalidateMode.disabled,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Select Role";
                        } else {
                          return null;
                        }
                      },
                      suffixIcon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.blue,
                      ),
                    ),
                    hint: Text(
                      StringConst.selectRole,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    items: profileList
                        .map((item) => DropdownMenuItem(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ))
                        .toList(),
                    value: selectedValue,
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value;
                        selectProfileController.text = value!;
                      });
                    },
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0,
                        ),
                        //Border.all
                        borderRadius: BorderRadius.circular(12),
                      ),
                      maxHeight: 300,
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 50,
                    ),

                    //This to clear the search value when you close the menu
                    onMenuStateChange: (isOpen) {
                      if (!isOpen) {
                        selectProfileController.clear();
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: ScreenUtilWrapper.setResponsiveSize(30),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: BorderTextFeild(
                        focusNode: _focusNode,
                        readonly: true,
                        onTap: () async {
                          _focusNode.unfocus();
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2101));
                          if (pickedDate != null) {
                            this.pickedDate = pickedDate;
                            formattedDate =
                                DateFormat('dd/MM/yyyy').format(pickedDate);
                            joiningDateController.text = formattedDate!;

                            setState(() {});
                          }
                        },
                        autovalidateMode: autovalidation
                            ? AutovalidateMode.always
                            : AutovalidateMode.disabled,
                        labelText: StringConst.startDate,
                        controller: joiningDateController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please Select Date";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: ScreenUtilWrapper.setResponsiveSize(10),
                    ),
                    Expanded(
                      child: BorderTextFeild(
                        focusNode: _focusNode,
                        readonly: true,
                        onTap: () async {
                          _focusNode.unfocus();
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2101));
                          if (pickedDate != null) {
                            this.pickedDate = pickedDate;
                            formattedDate =
                                DateFormat('dd/MM/yyyy').format(pickedDate);
                            leavingDateController.text = formattedDate!;

                            setState(() {});
                          }
                        },
                        autovalidateMode: autovalidation
                            ? AutovalidateMode.always
                            : AutovalidateMode.disabled,
                        labelText: StringConst.startDate,
                        controller: leavingDateController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please Select Date";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  usernameController.clear();
                  selectProfileController.clear();
                  joiningDateController.clear();
                  leavingDateController.clear();
                  setState(() {});
                },
                child: SizedBox(
                  height: ScreenUtilWrapper.setResponsiveSize(30),
                  width: ScreenUtilWrapper.setResponsiveSize(70),
                  child: Container(
                    color: Colors.blue,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        "Cancel",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtilWrapper.setResponsiveSize(14)),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: () {
                  if (formGlobalKey.currentState!.validate()) {
                    UserModel userdata = UserModel(
                        id: "1",
                        userName: usernameController.text.toString(),
                        userProfile: selectProfileController.text.toString(),
                        joiningTime: joiningDateController.text,
                        leavingTime: leavingDateController.text);

                    updateUserData(userdata, widget.index);
                    usernameController.clear();
                    selectProfileController.clear();
                    joiningDateController.clear();
                    leavingDateController.clear();
                    setState(() {});

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EmployeeListScreen()),
                    );
                  }
                },
                child: SizedBox(
                  height: ScreenUtilWrapper.setResponsiveSize(30),
                  width: ScreenUtilWrapper.setResponsiveSize(70),
                  child: Container(
                    color: Colors.blue,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        "Save",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtilWrapper.setResponsiveSize(14)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
