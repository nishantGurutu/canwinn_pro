import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/companyControlelr.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/text_field.dart';
import 'package:task_management/view/widgets/custom_dropdawn.dart';

class AddCompany extends StatefulWidget {
  const AddCompany({super.key});

  @override
  State<AddCompany> createState() => _AddCompanyState();
}

class _AddCompanyState extends State<AddCompany> {
  final TextEditingController orgNameTextEditingController =
      TextEditingController();
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController phoneTextEditingController =
      TextEditingController();
  final TextEditingController phone2TextEditingController =
      TextEditingController();
  final TextEditingController faxTextEditingController =
      TextEditingController();
  final TextEditingController websiteTextEditingController =
      TextEditingController();
  final TextEditingController ratingsTextEditingController =
      TextEditingController();
  final TextEditingController ownerTextEditingController =
      TextEditingController();
  final TextEditingController tagTextEditingController =
      TextEditingController();
  final TextEditingController dealsTextEditingController =
      TextEditingController();
  final TextEditingController sourceTextEditingController =
      TextEditingController();
  final TextEditingController industryTextEditingController =
      TextEditingController();
  final TextEditingController contactTextEditingController =
      TextEditingController();
  final TextEditingController currencyTextEditingController =
      TextEditingController();
  final TextEditingController languageTextEditingController =
      TextEditingController();
  final TextEditingController describeTextEditingController =
      TextEditingController();

  // Address field
  final TextEditingController streetAddressTextEditingController =
      TextEditingController();
  final TextEditingController cityTextEditingController =
      TextEditingController();
  final TextEditingController stateTextEditingController =
      TextEditingController();
  final TextEditingController postalCodeTextEditingController =
      TextEditingController();

  // Address field
  final TextEditingController facebookTextEditingController =
      TextEditingController();
  final TextEditingController skypeTextEditingController =
      TextEditingController();
  final TextEditingController linkedinTextEditingController =
      TextEditingController();
  final TextEditingController twitterTextEditingController =
      TextEditingController();
  final TextEditingController whatsappTextEditingController =
      TextEditingController();
  final TextEditingController instagramTextEditingController =
      TextEditingController();

  final CompanyController companyController = Get.put(CompanyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
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
          addCompany,
          style: TextStyle(
              color: textColor, fontSize: 21, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: backgroundColor,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              children: [
                SizedBox(height: 15.h),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
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
                          orgName,
                          style: rubikBold,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          orgName,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          hintText: orgName,
                          keyboardType: TextInputType.emailAddress,
                          controller: orgNameTextEditingController,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          email,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          hintText: enterYourEmail,
                          keyboardType: TextInputType.emailAddress,
                          controller: emailTextEditingController,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          phone,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          hintText: enterYourPhone,
                          keyboardType: TextInputType.emailAddress,
                          controller: phoneTextEditingController,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          phone2,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          hintText: enterYourPhone2,
                          keyboardType: TextInputType.emailAddress,
                          controller: emailTextEditingController,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          fax,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          hintText: enterYourFax,
                          keyboardType: TextInputType.emailAddress,
                          controller: emailTextEditingController,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          website,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          hintText: enterYourUrl,
                          keyboardType: TextInputType.emailAddress,
                          controller: websiteTextEditingController,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          rating,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          hintText: enterYourRating,
                          keyboardType: TextInputType.emailAddress,
                          controller: ratingsTextEditingController,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          owner,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomDropdown<String>(
                          items: companyController.owner,
                          itemLabel: (item) => item,
                          onChanged: (value) {},
                          hintText: selectOwner,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          tag,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          hintText: enterYourTag,
                          keyboardType: TextInputType.emailAddress,
                          controller: tagTextEditingController,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          deals,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomDropdown<String>(
                          items: companyController.deals,
                          itemLabel: (item) => item,
                          onChanged: (value) {},
                          hintText: selectDeals,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          source,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomDropdown<String>(
                          items: companyController.source,
                          itemLabel: (item) => item,
                          onChanged: (value) {},
                          hintText: selectSource,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          industry,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomDropdown<String>(
                          items: companyController.industry,
                          itemLabel: (item) => item,
                          onChanged: (value) {},
                          hintText: selectIndustry,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          contact,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomDropdown<String>(
                          items: companyController.contact,
                          itemLabel: (item) => item,
                          onChanged: (value) {},
                          hintText: selectContact,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          currency,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          hintText: enterYourCurrency,
                          keyboardType: TextInputType.emailAddress,
                          controller: currencyTextEditingController,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          language,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomDropdown<String>(
                          items: companyController.language,
                          itemLabel: (item) => item,
                          onChanged: (value) {},
                          hintText: selectLanguage,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          description,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          hintText: enterYourDescription,
                          keyboardType: TextInputType.emailAddress,
                          controller: describeTextEditingController,
                          textCapitalization: TextCapitalization.sentences,
                          maxLine: 4,
                        ),
                        SizedBox(height: 5.h),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
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
                        SizedBox(height: 10.h),
                        Text(
                          streetAddress,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          hintText: streetAddress,
                          keyboardType: TextInputType.emailAddress,
                          controller: streetAddressTextEditingController,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          city,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          hintText: enterYourCity,
                          keyboardType: TextInputType.emailAddress,
                          controller: cityTextEditingController,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          state,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          hintText: enterYourState,
                          keyboardType: TextInputType.emailAddress,
                          controller: stateTextEditingController,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          country,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomDropdown<String>(
                          items: companyController.country,
                          itemLabel: (item) => item,
                          onChanged: (value) {},
                          hintText: selectCountry,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          postalCode,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          hintText: enterYourZipcode,
                          keyboardType: TextInputType.emailAddress,
                          controller: postalCodeTextEditingController,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
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
                          socialProfile,
                          style: rubikBold,
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
                          controller: facebookTextEditingController,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          skype,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          hintText: skype,
                          keyboardType: TextInputType.emailAddress,
                          controller: skypeTextEditingController,
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
                          controller: linkedinTextEditingController,
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
                          controller: twitterTextEditingController,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          whatsapp,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          hintText: whatsapp,
                          keyboardType: TextInputType.emailAddress,
                          controller: whatsappTextEditingController,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          instagram,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        CustomTextField(
                          hintText: instagram,
                          keyboardType: TextInputType.emailAddress,
                          controller: instagramTextEditingController,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
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
                          access,
                          style: rubikBold,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          visibility,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 15.w,
                                  child: Obx(
                                    () => Radio(
                                      value: 'public',
                                      groupValue:
                                          companyController.isPublic.value,
                                      onChanged: (value) {
                                        companyController.isPublic.value =
                                            value!;
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  "Public",
                                  style: robotoRegular,
                                )
                              ],
                            ),
                            SizedBox(width: 15.w),
                            Row(
                              children: [
                                SizedBox(
                                  width: 15.w,
                                  child: Obx(
                                    () => Radio(
                                      value: 'private',
                                      groupValue:
                                          companyController.isPublic.value,
                                      onChanged: (value) {
                                        companyController.isPublic.value =
                                            value!;
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  "Private",
                                  style: robotoRegular,
                                )
                              ],
                            ),
                            SizedBox(width: 15.w),
                            Row(
                              children: [
                                SizedBox(
                                  width: 15.w,
                                  child: Obx(
                                    () => Radio(
                                      value: 'select_people',
                                      groupValue:
                                          companyController.isPublic.value,
                                      onChanged: (value) {
                                        companyController.isPublic.value =
                                            value!;
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  "Select People",
                                  style: robotoRegular,
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          status,
                          style: rubikRegular,
                        ),
                        SizedBox(height: 5.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 15.w,
                                  child: Obx(
                                    () => Radio(
                                      value: 'active',
                                      groupValue:
                                          companyController.isActive.value,
                                      onChanged: (value) {
                                        companyController.isActive.value =
                                            value!;
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  "Active",
                                  style: robotoRegular,
                                )
                              ],
                            ),
                            SizedBox(width: 15.w),
                            Row(
                              children: [
                                SizedBox(
                                  width: 15.w,
                                  child: Obx(
                                    () => Radio(
                                      value: 'inactive',
                                      groupValue:
                                          companyController.isActive.value,
                                      onChanged: (value) {
                                        companyController.isActive.value =
                                            value!;
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  "Inactive",
                                  style: robotoRegular,
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                CustomButton(
                  onPressed: () {},
                  text: Text(
                    submit,
                    style: TextStyle(color: whiteColor),
                  ),
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
