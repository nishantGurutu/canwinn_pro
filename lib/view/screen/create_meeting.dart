import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateMeeting extends StatefulWidget {
  const CreateMeeting({super.key});

  @override
  State<CreateMeeting> createState() => _CreateMeetingState();
}

class _CreateMeetingState extends State<CreateMeeting> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController venueController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController alertTimeController = TextEditingController();

  List<String> departments = [
    'Other',
    'Account & Finance',
    'IT',
    'Design & Digital',
  ];

  List<String> selectedDepartments = [];

  InputDecoration inputDecoration(String label, {Widget? icon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  void _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        dateController.text = DateFormat.yMd().format(picked);
      });
    }
  }

  void _pickTime(TextEditingController controller) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      controller.text = picked.format(context);
    }
  }

  Color getChipColor(String label) {
    switch (label) {
      case 'Other':
        return Colors.green;
      case 'Account & Finance':
        return Colors.purple;
      case 'IT':
        return Colors.orange;
      case 'Design & Digital':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Meeting'),
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Meeting Title
            TextField(
              controller: titleController,
              decoration: inputDecoration("Meeting Title"),
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              decoration: inputDecoration("Select person"),
              items: ['Alice', 'Bob', 'Charlie']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) {},
            ),
            const SizedBox(height: 16),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration: inputDecoration("Select Department"),
                  onChanged: (value) {},
                  onSubmitted: (value) {
                    if (departments.contains(value) &&
                        !selectedDepartments.contains(value)) {
                      setState(() => selectedDepartments.add(value));
                    }
                  },
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: selectedDepartments.map((dep) {
                    return Chip(
                      backgroundColor: getChipColor(dep),
                      label: Text(
                        dep,
                        style: const TextStyle(color: Colors.white),
                      ),
                      deleteIcon: const Icon(Icons.close, color: Colors.white),
                      onDeleted: () {
                        setState(() => selectedDepartments.remove(dep));
                      },
                    );
                  }).toList(),
                )
              ],
            ),
            const SizedBox(height: 16),

            // Meeting Venue
            TextField(
              controller: venueController,
              decoration: inputDecoration("Meeting Venue"),
            ),
            const SizedBox(height: 16),

            // Meeting Link Dropdown (dummy)
            DropdownButtonFormField<String>(
              decoration: inputDecoration("Meeting Link"),
              items: ['Zoom', 'Google Meet', 'Teams']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) {},
            ),
            const SizedBox(height: 16),

            // Meeting Date
            TextField(
              controller: dateController,
              readOnly: true,
              onTap: _pickDate,
              decoration: inputDecoration(
                "Meeting Date",
                icon: const Icon(Icons.calendar_today),
              ),
            ),
            const SizedBox(height: 16),

            // Start and End Time
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: startTimeController,
                    readOnly: true,
                    onTap: () => _pickTime(startTimeController),
                    decoration: inputDecoration(
                      "Start Time",
                      icon: const Icon(Icons.access_time),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: endTimeController,
                    readOnly: true,
                    onTap: () => _pickTime(endTimeController),
                    decoration: inputDecoration(
                      "End Time",
                      icon: const Icon(Icons.access_time),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Alert Time & Type
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: alertTimeController,
                    decoration: inputDecoration("Alert Time"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: inputDecoration("Select type"),
                    items: ['One Time', 'Repeat Daily']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Create Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF273BAA), // Blue as in screenshot
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Handle create action
                },
                child: const Text(
                  "Create",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
