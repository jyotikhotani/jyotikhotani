import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:user_list_app/models/user_model.dart';
import 'package:user_list_app/ui/common_widgets/screen_util_wrapper.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:user_list_app/ui/employee_list.dart';
import 'package:user_list_app/utils/colors.dart';
import 'package:user_list_app/utils/common_methods.dart';
import 'package:user_list_app/utils/constants.dart';
import 'package:user_list_app/utils/locator.dart';
import 'common_widgets/text_feilds.dart';
import 'package:intl/intl.dart';

class AddEmployeScreen extends StatefulWidget {
  const AddEmployeScreen({super.key});

  @override
  State<AddEmployeScreen> createState() => _AddEmployeScreenState();
}

class _AddEmployeScreenState extends State<AddEmployeScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController selectProfileController = TextEditingController();
  TextEditingController joiningDateController = TextEditingController();
  TextEditingController leavingDateController = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();
  bool isTodaySelected = false;
  bool isNextMondaySelected = false;
  bool isNextTuesdaySelected = false;
  bool isAfterWeekSelected = false;
  DateTime joiningDate = DateTime.now();

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
  List<UserModel> userDataList = [];
  DateTime selectedDate = DateTime.now();
  String SelectDateStr = "";

  void _addUserData(UserModel user) {
    userDataList.add(user);
    List<String> jsonDataList = [];
    if (localStorageService.getuserDataFromDisk != null) {
      jsonDataList = localStorageService.getuserDataFromDisk!;
      jsonDataList.add(jsonEncode(user));
      localStorageService.saveUserDataToDisk(jsonDataList);
    }

    setState(() {});
  }

  _showCustomDatePicker(BuildContext context, bool isJoiningDate) async {
    String dateTimenowStr =
        DateFormat('yyyy-MM-dd HH:mm:ss.SSS\'Z\'').format(DateTime.now());

    SelectDateStr = CommonMethods.convertDateTimetoMM_dd_yyy(dateTimenowStr);
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateInsideDialog) {
          return Dialog(
            insetPadding:
                EdgeInsets.all(ScreenUtilWrapper.setResponsiveSize(16)),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
            child: Padding(
              padding: EdgeInsets.all(ScreenUtilWrapper.setResponsiveSize(7)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              setStateInsideDialog(() {
                                isTodaySelected = true;
                                setStateInsideDialog(() {
                                  selectedDate = DateTime.now();
                                  String dateTimenowStr =
                                      DateFormat('yyyy-MM-dd HH:mm:ss.SSS\'Z\'')
                                          .format(selectedDate);

                                  SelectDateStr =
                                      CommonMethods.convertDateTimetoMM_dd_yyy(
                                          dateTimenowStr);
                                });
                              });
                            },
                            style: ButtonStyle(
                                elevation: MaterialStateProperty.all(
                                  0.0,
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.blue)),
                            child: Text(StringConst.today)),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: ElevatedButton(
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(
                                0.0,
                              ),
                              backgroundColor: MaterialStateProperty.all(
                                lightBlueColor,
                              ),
                            ),
                            onPressed: () {
                              isNextMondaySelected = true;
                              setStateInsideDialog(() {
                                _selectNextWeekday(DateTime.monday);
                              });
                            },
                            child: Text(
                              StringConst.nextMonday,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.blue),
                            )),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              isNextTuesdaySelected = true;

                              setStateInsideDialog(() {
                                _selectNextWeekday(DateTime.tuesday);
                              });
                            },
                            style: ButtonStyle(
                                elevation: MaterialStateProperty.all(
                                  0.0,
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.blue)),
                            child: Text(StringConst.nextTuesDay)),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  lightBlueColor,
                                ),
                                elevation: MaterialStateProperty.all(
                                  0.0,
                                )),
                            onPressed: () {
                              isAfterWeekSelected = true;
                              setStateInsideDialog(() {
                                selectedDate =
                                    selectedDate.add(Duration(days: 7));
                                SelectDateStr =
                                    CommonMethods.convertDateTimetoMM_dd_yyy(
                                        selectedDate.toString());
                              });
                            },
                            child: Text(
                              StringConst.nextWeek,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.blue),
                            )),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  TableCalendar(
                    firstDay: DateTime(DateTime.now().year - 10),
                    lastDay: DateTime(DateTime.now().year + 10),
                    focusedDay: selectedDate,
                    headerStyle: HeaderStyle(
                        formatButtonVisible: false, titleCentered: true),
                    availableGestures: AvailableGestures.all,
                    selectedDayPredicate: (day) {
                      return isSameDay(day, selectedDate);
                    },
                    onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
                      setStateInsideDialog(() {
                        selectedDate = selectedDay;
                        SelectDateStr =
                            CommonMethods.convertDateTimetoMM_dd_yyy(
                                selectedDate.toString());
                      });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/icons/calender.png",
                              width: 30,
                              height: 30,
                            ),
                            Text(SelectDateStr)
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  lightBlueColor,
                                ),
                                elevation: MaterialStateProperty.all(
                                  0.3,
                                )),
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text(
                              StringConst.cancel,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.blue),
                            ),
                          ),
                          SizedBox(width: 20),
                          ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.blue,
                                ),
                                elevation: MaterialStateProperty.all(
                                  0.3,
                                )),
                            onPressed: () {
                              Navigator.of(context).pop(selectedDate);
                              if (isJoiningDate) {
                                joiningDate = selectedDate;
                                if (!selectedDate.toString().contains("Z")) {
                                  String dateTimenowStr =
                                      DateFormat('yyyy-MM-dd HH:mm:ss.SSS\'Z\'')
                                          .format(DateTime.now());
                                  joiningDateController.text =
                                      CommonMethods.convertDateTimetoMM_dd_yyy(
                                          dateTimenowStr.toString());
                                }
                              } else {
                                if (selectedDate.isAfter(joiningDate)) {
                                  leavingDateController.text =
                                      CommonMethods.convertDateTimetoMM_dd_yyy(
                                          selectedDate.toString());
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(StringConst
                                              .selectJoinindateAfterLeavingDate)));
                                }
                              }
                            },
                            child: Text('Save'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  void _selectNextWeekday(int weekday) {
    int daysUntilNextWeekday =
        weekday - int.parse(selectedDate.weekday.toString());
    if (daysUntilNextWeekday <= 0) daysUntilNextWeekday += 7;
    selectedDate = selectedDate.add(Duration(days: daysUntilNextWeekday));
    SelectDateStr =
        CommonMethods.convertDateTimetoMM_dd_yyy(selectedDate.toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Employee Details"),
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
                        _showCustomDatePicker(context, true);
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
                        _showCustomDatePicker(context, false);
                      },
                      autovalidateMode: autovalidation
                          ? AutovalidateMode.always
                          : AutovalidateMode.disabled,
                      labelText: StringConst.noDate,
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
                  _addUserData(userdata);
                  usernameController.clear();
                  selectProfileController.clear();
                  joiningDateController.clear();
                  leavingDateController.clear();

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
      ),
    );
  }
}
