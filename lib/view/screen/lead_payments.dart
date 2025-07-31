import 'package:flutter/material.dart';

import '../../constant/text_constant.dart';
import '../../custom_widget/text_field.dart';

class LeadPaymentsScreens extends StatefulWidget {
  const LeadPaymentsScreens({super.key});

  @override
  State<LeadPaymentsScreens> createState() => _LeadPaymentsScreensState();
}

class _LeadPaymentsScreensState extends State<LeadPaymentsScreens> {
  TextEditingController clientNameTextEditingController = TextEditingController();
  TextEditingController siteNameTextEditingController = TextEditingController();
  TextEditingController branchNameTextEditingController = TextEditingController();
  TextEditingController clientAddressTextEditingController = TextEditingController();
  TextEditingController contactNo1TextEditingController = TextEditingController();
  TextEditingController contactNo2TextEditingController = TextEditingController();
  TextEditingController contactNo3TextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController websiteTextEditingController = TextEditingController();
  TextEditingController clientGradeTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lead_payments),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(client_name),
              CustomTextField(
                hintText: client_name,
                keyboardType: TextInputType.text,
                controller: clientNameTextEditingController,
                textCapitalization: TextCapitalization.sentences,
              ),
              SizedBox(height: 8,),
              Text(site_name),
              CustomTextField(
                hintText: site_name,
                keyboardType: TextInputType.text,
                controller: siteNameTextEditingController,
                textCapitalization: TextCapitalization.sentences,
              ),
              SizedBox(height: 8,),
              Text(client_grade),
              CustomTextField(
                hintText: client_grade,
                keyboardType: TextInputType.text,
                controller: clientGradeTextEditingController,
                textCapitalization: TextCapitalization.sentences,
              ),
              SizedBox(height: 8,),
              Text(branch_name),
              CustomTextField(
                hintText: branch_name,
                keyboardType: TextInputType.text,
                controller: branchNameTextEditingController,
                textCapitalization: TextCapitalization.sentences,
              ),
              SizedBox(height: 8,),
              Text(contact_no1),
              CustomTextField(
                hintText: contact_no1,
                keyboardType: TextInputType.text,
                controller: contactNo1TextEditingController,
                textCapitalization: TextCapitalization.sentences,
              ),
              SizedBox(height: 8,),
              Text(contact_no2),
              CustomTextField(
                hintText: contact_no2,
                keyboardType: TextInputType.text,
                controller: contactNo2TextEditingController,
                textCapitalization: TextCapitalization.sentences,
              ),
              SizedBox(height: 8,),
              Text(contact_no3),
              CustomTextField(
                hintText: contact_no3,
                keyboardType: TextInputType.text,
                controller: contactNo3TextEditingController,
                textCapitalization: TextCapitalization.sentences,
              ),
              SizedBox(height: 8,),
              Text(email),
              CustomTextField(
                hintText: email,
                keyboardType: TextInputType.text,
                controller: emailTextEditingController,
                textCapitalization: TextCapitalization.sentences,
              ),
            ],
          ),
        ),
      ),

    );
  }
}
