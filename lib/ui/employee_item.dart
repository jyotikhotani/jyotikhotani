import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_list_app/models/user_model.dart';
import 'package:user_list_app/ui/common_widgets/screen_util_wrapper.dart';
import 'package:user_list_app/ui/edit_employee_detail.dart';
import 'package:user_list_app/utils/colors.dart';
import 'package:user_list_app/utils/constants.dart';

class EmployeeItem extends StatelessWidget {
  UserModel empData;
  int index;

  EmployeeItem(this.empData, this.index, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                empData.userName!,
                style: TextStyle(
                    fontSize: 14,
                    color: textColor,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: ScreenUtilWrapper.setResponsiveSize(5),
              ),
              Text(
                empData.userProfile!,
                style: TextStyle(
                  fontSize: ScreenUtilWrapper.setResponsiveSize(12),
                  color: textgreyColor,
                ),
              ),
              SizedBox(
                height: ScreenUtilWrapper.setResponsiveSize(5),
              ),
              Text(
                "From ${empData.joiningTime}",
                style: TextStyle(
                  fontSize: ScreenUtilWrapper.setResponsiveSize(12),
                  color: textgreyColor,
                ),
              ),
              SizedBox(
                height: ScreenUtilWrapper.setResponsiveSize(15),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        EditEmployeeDetailScreen(empData, index)),
              );
            },
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: textgreyColor, width: 1)),
                padding: EdgeInsets.all(4.0),
                child: Icon(
                  Icons.edit,
                  color: green,
                  size: 20,
                )
                // Text(
                //   StringConst.edit,
                //   style: TextStyle(
                //       fontSize: ScreenUtilWrapper.setResponsiveSize(14),
                //       color: green),
                // ),
                ),
          ),
        )
      ],
    );
  }
}
