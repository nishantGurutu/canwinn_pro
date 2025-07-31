import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DailyTaskListWidget extends StatelessWidget {
  final List<TextEditingController> timeControllers;
  final List<TextEditingController> remarkControllers;
  final RxBool isLoading;
  final RxList<bool> checkboxList;
  final RxList<dynamic> taskList;
  final RxBool isSubmitting;
  final VoidCallback onSubmit;
  final Function(BuildContext, int) onAddRemark;
  final Function(int index, bool value) onCheckboxChanged;

  const DailyTaskListWidget({
    Key? key,
    required this.timeControllers,
    required this.remarkControllers,
    required this.isLoading,
    required this.checkboxList,
    required this.taskList,
    required this.isSubmitting,
    required this.onSubmit,
    required this.onAddRemark,
    required this.onCheckboxChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      width: double.infinity,
      height: 610,
      child: Obx(
        () => isLoading.value
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text(
                      'Daily Task List',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: taskList.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 13.0,
                                      spreadRadius: 2,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text('${index + 1}.'),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            taskList[index].taskName ?? '',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Obx(
                                          () => Checkbox(
                                            value: checkboxList[index],
                                            onChanged: (value) =>
                                                onCheckboxChanged(
                                                    index, value!),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 120,
                                          child: TextField(
                                            controller: timeControllers[index],
                                            readOnly: true,
                                            onTap: () async {
                                              TimeOfDay? pickedTime =
                                                  await showTimePicker(
                                                      context: context,
                                                      initialTime:
                                                          TimeOfDay.now());

                                              if (pickedTime != null) {
                                                final now = DateTime.now();
                                                final selectedTime = DateTime(
                                                  now.year,
                                                  now.month,
                                                  now.day,
                                                  pickedTime.hour,
                                                  pickedTime.minute,
                                                );
                                                String formattedTime =
                                                    DateFormat('hh:mm a')
                                                        .format(selectedTime);
                                                timeControllers[index].text =
                                                    formattedTime;
                                              }
                                            },
                                            decoration: InputDecoration(
                                              prefixIcon:
                                                  Icon(Icons.access_time),
                                              hintText: 'hh:mm a',
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        InkWell(
                                          onTap: () =>
                                              onAddRemark(context, index),
                                          child: Container(
                                            width: 180,
                                            height: 40,
                                            alignment: Alignment.center,
                                            color: Colors.grey.shade300,
                                            child: Text(
                                              remarkControllers[index]
                                                      .text
                                                      .isEmpty
                                                  ? "Add Remark"
                                                  : remarkControllers[index]
                                                      .text,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          );
                        },
                      ),
                    ),
                    Obx(
                      () => ElevatedButton(
                        onPressed: onSubmit,
                        child: isSubmitting.value
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(
                                      color: Colors.white),
                                  SizedBox(width: 8),
                                  Text('Loading...'),
                                ],
                              )
                            : Text('Submit'),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
