import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/text_field.dart';

class NewContact extends StatefulWidget {
  const NewContact({super.key});

  @override
  State<NewContact> createState() => _NewContactState();
}

class _NewContactState extends State<NewContact> {
  final TextEditingController prefixTextEditingControlelr =
      TextEditingController();
  final TextEditingController firstNameTextEditingControlelr =
      TextEditingController();
  final TextEditingController lastNameTextEditingControlelr =
      TextEditingController();
  final TextEditingController titleTextEditingControlelr =
      TextEditingController();
  final TextEditingController emailTextEditingControlelr =
      TextEditingController();
  final TextEditingController phoneTextEditingControlelr =
      TextEditingController();
  final TextEditingController homePhoneTextEditingControlelr =
      TextEditingController();
  final TextEditingController mobilePhoneTextEditingControlelr =
      TextEditingController();
  final TextEditingController otherPhoneTextEditingControlelr =
      TextEditingController();
  final TextEditingController assistancePhoneTextEditingControlelr =
      TextEditingController();
  final TextEditingController assistantNameTextEditingControlelr =
      TextEditingController();
  final TextEditingController faxTextEditingControlelr =
      TextEditingController();
  final TextEditingController linkedInTextEditingControlelr =
      TextEditingController();
  final TextEditingController facebookTextEditingControlelr =
      TextEditingController();
  final TextEditingController twitterTextEditingControlelr =
      TextEditingController();
  final TextEditingController mailingAddressTextEditingControlelr =
      TextEditingController();
  final TextEditingController mailingCityTextEditingControlelr =
      TextEditingController();
  final TextEditingController mailingStateTextEditingControlelr =
      TextEditingController();
  final TextEditingController mailingPostalCodeTextEditingControlelr =
      TextEditingController();
  final TextEditingController dueDateTextEditingControlelr =
      TextEditingController();
  final TextEditingController dueDate2TextEditingControlelr =
      TextEditingController();
  final TextEditingController descriptionTextEditingControlelr =
      TextEditingController();
  final TextEditingController tagListTextEditingControlelr =
      TextEditingController();
  final TextEditingController permissionTextEditingControlelr =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: SvgPicture.asset('assets/images/svg/back_arrow.svg'),
        ),
        title: Text(
          newContact,
          style: TextStyle(
              color: textColor, fontSize: 21, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: whiteColor,
      body: Container(
        color: backgroundColor,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(12.r)),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nameAndOccupation,
                          style: rubikBold,
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          "$name*",
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          hintText: prefix,
                          keyboardType: TextInputType.emailAddress,
                          controller: prefixTextEditingControlelr,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          firstName,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          hintText: firstName,
                          keyboardType: TextInputType.emailAddress,
                          controller: firstNameTextEditingControlelr,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          lastName,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          hintText: lastName,
                          keyboardType: TextInputType.emailAddress,
                          controller: lastNameTextEditingControlelr,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          "$title*",
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          hintText: title,
                          keyboardType: TextInputType.emailAddress,
                          controller: titleTextEditingControlelr,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(12.r)),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contactDetail,
                          style: rubikBold,
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          email,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          hintText: email,
                          keyboardType: TextInputType.emailAddress,
                          controller: emailTextEditingControlelr,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          phone,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          hintText: phone,
                          keyboardType: TextInputType.emailAddress,
                          controller: phoneTextEditingControlelr,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          homePhone,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          hintText: homePhone,
                          keyboardType: TextInputType.emailAddress,
                          controller: homePhoneTextEditingControlelr,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          mobilePhone,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          hintText: mobilePhone,
                          keyboardType: TextInputType.emailAddress,
                          controller: mobilePhoneTextEditingControlelr,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          otherPhone,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          hintText: otherPhone,
                          keyboardType: TextInputType.emailAddress,
                          controller: otherPhoneTextEditingControlelr,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          assistantPhone,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          hintText: assistantPhone,
                          keyboardType: TextInputType.emailAddress,
                          controller: assistancePhoneTextEditingControlelr,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          assistantName,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          hintText: assistantName,
                          keyboardType: TextInputType.emailAddress,
                          controller: assistantNameTextEditingControlelr,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          fax,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          hintText: fax,
                          keyboardType: TextInputType.emailAddress,
                          controller: faxTextEditingControlelr,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          linkedin,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          hintText: linkedin,
                          keyboardType: TextInputType.emailAddress,
                          controller: linkedInTextEditingControlelr,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          facebook,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          hintText: facebook,
                          keyboardType: TextInputType.emailAddress,
                          controller: facebookTextEditingControlelr,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          twitter,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          hintText: twitter,
                          keyboardType: TextInputType.emailAddress,
                          controller: twitterTextEditingControlelr,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(12.r)),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          addressInfo,
                          style: rubikBold,
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          mailingAddress,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          hintText: mailingAddress,
                          keyboardType: TextInputType.emailAddress,
                          controller: mailingAddressTextEditingControlelr,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          mailingCity,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          hintText: mailingCity,
                          keyboardType: TextInputType.emailAddress,
                          controller: mailingCityTextEditingControlelr,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          mailingState,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          hintText: mailingState,
                          keyboardType: TextInputType.emailAddress,
                          controller: mailingStateTextEditingControlelr,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          mailingPostalCode,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          hintText: mailingPostalCode,
                          keyboardType: TextInputType.emailAddress,
                          controller: mailingPostalCodeTextEditingControlelr,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          mailingCountry,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          hintText: mailingCountry,
                          keyboardType: TextInputType.emailAddress,
                          controller: mailingPostalCodeTextEditingControlelr,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(12.r)),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dateToRemember,
                          style: rubikBold,
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          dueDate,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          hintText: dateFormate,
                          keyboardType: TextInputType.emailAddress,
                          controller: dueDateTextEditingControlelr,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          dueDate,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          hintText: dateFormate,
                          keyboardType: TextInputType.emailAddress,
                          controller: dueDate2TextEditingControlelr,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(12.r)),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          descriptionInfo,
                          style: rubikBold,
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          description,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          hintText: description,
                          keyboardType: TextInputType.emailAddress,
                          controller: descriptionTextEditingControlelr,
                          textCapitalization: TextCapitalization.sentences,
                          maxLine: 4,
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(12.r)),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tagInfo,
                          style: rubikBold,
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          tagList,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          hintText: tagList,
                          keyboardType: TextInputType.emailAddress,
                          controller: tagListTextEditingControlelr,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(12.r)),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          permission,
                          style: rubikBold,
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          tagList,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          hintText: tagList,
                          keyboardType: TextInputType.emailAddress,
                          controller: permissionTextEditingControlelr,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                CustomButton(
                  onPressed: () {
                    Get.back();
                  },
                  text: Text(submit),
                  width: double.infinity,
                  color: primaryColor,
                  height: 45.h,
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
