import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:user_list_app/models/user_model.dart';
import 'package:user_list_app/ui/add_emplyee.dart';
import 'package:user_list_app/ui/common_widgets/screen_util_wrapper.dart';
import 'package:user_list_app/ui/employee_item.dart';
import 'package:user_list_app/utils/colors.dart';
import 'package:user_list_app/utils/locator.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  List<Map<String, dynamic>> empMap = [];
  List<UserModel> empList = [];
  // List<UserModel> previousEmpList = [];
  // List<UserModel> currentEmpList = [];
  @override
  void initState() {
    getDataFromLocalStorage();
    super.initState();
  }

  getDataFromLocalStorage() async {
    if (localStorageService.getuserDataFromDisk != null) {
      final employeeDetail = localStorageService.getuserDataFromDisk;
      for (var item in employeeDetail!) {
        empMap.add(jsonDecode(item));
      }
      empList = empMap
          .map((emp) => UserModel(
              id: emp['id'],
              userName: emp['userName'],
              userProfile: emp['userProfile'],
              joiningTime: emp["joiningTime"],
              leavingTime: emp["leavingTime"]))
          .toList();
      print(empList);
    }
  }

  void deleteUserData(int index) {
    empList.removeAt(index);
    List<String> jsonDataList =
        empList.map((user) => jsonEncode(user)).toList();
    localStorageService.saveUserDataToDisk(jsonDataList);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Employee List"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            empList.isNotEmpty
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Current employees",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: ScreenUtilWrapper.setResponsiveSize(14),
                          color: Colors.blue),
                    ),
                  )
                : Container(),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: empList.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: empList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Dismissible(
                            direction: DismissDirection.endToStart,
                            key: UniqueKey(),
                            onDismissed: (direction) {
                              deleteUserData(index);

                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(" user deleted")));
                            },
                            background: Container(
                              color: Colors.red,
                              padding: EdgeInsets.only(
                                  right:
                                      ScreenUtilWrapper.setResponsiveSize(15)),
                              alignment: Alignment.centerRight,
                              child: const Icon(
                                Icons.delete,
                                color: white,
                                size: 25,
                              ),
                            ),
                            child: EmployeeItem(empList[index], index));
                      })
                  : Center(
                      child: SizedBox(
                          height: 200,
                          width: 200,
                          child:
                              Image.asset("assets/images/no_record_found.png")),
                    ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: greyLightColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    "Swipe left to delete",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: textgreyColor,
                        fontSize: ScreenUtilWrapper.setResponsiveSize(12)),
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddEmployeScreen()),
                    );
                  },
                  child: Container(
                    height: ScreenUtilWrapper.setResponsiveSize(50),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(
                            ScreenUtilWrapper.setResponsiveSize(4))),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Center(
                        child: Text(
                          "+",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtilWrapper.setResponsiveSize(24),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
