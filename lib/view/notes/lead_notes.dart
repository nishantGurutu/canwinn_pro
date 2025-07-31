import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/controller/lead_controller.dart';
import 'package:task_management/controller/notes_controller.dart';

import '../widgets/image_screen.dart';
import '../widgets/pdf_screen.dart';

class EditorController extends GetxController {
  final quill.QuillController quillController = quill.QuillController.basic();
  var selectedFont = Rxn<String>();
  var selectedFontSize = Rxn<String>();
  var selectedColor = Rx<Color>(
    Color(0xFFFDF1D4),
  );
  var selectedHexColor = ''.obs;
  var selectedBackgroundColor = Rx<Color>(Colors.transparent);

  void changeFont(String font) {
    selectedFont.value = font;
    quillController.formatSelection(quill.Attribute.fromKeyValue('font', font));
  }

  void changeFontSize(String size) {
    selectedFontSize.value = size;
    quillController.formatSelection(quill.Attribute.fromKeyValue('size', size));
  }

  void changeColor(Color color) {
    selectedColor.value = color;
    final hexColor =
        '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
    selectedHexColor.value = hexColor;
    print('selcted kajd98ud93 3idj39u ${selectedColor.value}');
    quillController
        .formatSelection(quill.Attribute.fromKeyValue('color', hexColor));
  }

  void changeBackgroundColor(Color color) {
    selectedBackgroundColor.value = color;
    final hexColor =
        '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
    quillController
        .formatSelection(quill.Attribute.fromKeyValue('background', hexColor));
  }
}

class LeadNoteEditorScreen extends StatefulWidget {
  final int leadId;
  const LeadNoteEditorScreen({super.key, required this.leadId});

  @override
  State<LeadNoteEditorScreen> createState() => _LeadNoteEditorScreenState();
}

class _LeadNoteEditorScreenState extends State<LeadNoteEditorScreen> {
  final EditorController editorController = Get.put(EditorController());
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _titleController = TextEditingController();

  final List<String> fonts = [
    'arial',
    'serif',
    'monospace',
    'courier',
    'calibri',
    'verdana',
    'times-new-roman',
    'tahoma',
    'impact',
    'georgia',
    'comic-sans-ms',
    'lucida-console',
    'garamond',
    'palatino',
    'bookman',
    'candara',
    'optima',
    'corbel',
    'segoe-ui',
    'franklin-gothic',
    'helvetica',
    'futura',
    'gill-sans',
    'century-gothic',
    'rockwell',
    'raleway',
    'opensans',
    'montserrat',
    'roboto',
    'noto-sans',
    'ubuntu',
    'oxygen'
  ];

  final List<String> fontSizes = List.generate(30, (i) => "${8 + i}px");

  final List<Color> customColors = [
    Color(0xFFFDF1D4),
    Colors.brown.shade100,
    Colors.black,
    Colors.white,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.teal,
    Colors.cyan,
    Colors.lime,
    Colors.indigo,
    Colors.brown,
    Colors.grey,
    Colors.amber,
    Colors.deepOrange,
    Colors.deepPurple,
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.blueGrey,
    Colors.red.shade100,
    Colors.red.shade200,
    Colors.red.shade300,
    Colors.green.shade100,
    Colors.green.shade200,
    Colors.green.shade300,
    Colors.blue.shade100,
    Colors.blue.shade200,
    Colors.blue.shade300,
    Colors.pink.shade100,
    Colors.pink.shade200,
    Colors.pink.shade300,
    Colors.orange.shade100,
    Colors.orange.shade200,
    Colors.orange.shade300,
    Colors.purple.shade100,
    Colors.purple.shade200,
    Colors.purple.shade300,
    Colors.teal.shade100,
    Colors.teal.shade200,
    Colors.teal.shade300,
    Colors.indigo.shade100,
    Colors.indigo.shade200,
    Colors.indigo.shade300,
    Colors.brown.shade100,
    Colors.brown.shade200,
    Colors.brown.shade300,
    Colors.grey.shade100,
  ];
  final LeadController leadController = Get.find();

  @override
  void initState() {
    editorController.changeColor(Color(0xFF000000));
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    leadController.profilePicPath.value = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text("Notes", style: TextStyle(color: Colors.black)),
        actions: [
          TextButton(
            onPressed: () async {
              if (_titleController.text.isNotEmpty) {
                if (leadController.isLeadNoteAdding.value == false) {
                  var sj78 = jsonEncode(editorController
                      .quillController.document
                      .toDelta()
                      .toJson());
                  print('ksjhd8u9 iue984u984 $sj78');
                  await leadController.addLeadNote(
                    _titleController.text,
                    jsonEncode(editorController.quillController.document
                        .toDelta()
                        .toJson()),
                    editorController.selectedHexColor.value,
                    widget.leadId,
                  );
                }
              } else {
                CustomToast().showCustomToast('Please enter title');
              }
            },
            child: Text(
              'Done',
              style: TextStyle(
                fontSize: 16.sp,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TextFormField(
              controller: _titleController,
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                  hintText: "Enter Title",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: lightGreyColor)),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: quill.QuillEditor(
                controller: editorController.quillController,
                focusNode: _focusNode,
                scrollController: ScrollController(),
                config: quill.QuillEditorConfig(
                  placeholder: 'Start writing your notes...',
                ),
              ),
            ),
          ),
          Obx(
            () {
              return Column(
                children: [
                  if (leadController.profilePicPath.value.isNotEmpty)
                    InkWell(
                      onTap: () {
                        openFile(File(leadController.profilePicPath.value));
                      },
                      child: Container(
                        height: 150.h,
                        width: 250.w,
                        decoration: BoxDecoration(
                          border: Border.all(color: lightGreyColor),
                          borderRadius: BorderRadius.all(Radius.circular(8.r)),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Image.file(
                            File(leadController.profilePicPath.value),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Text(
                                  "Invalid Image",
                                  style: TextStyle(color: Colors.red),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          Container(
            width: double.infinity,
            color: backgroundColor,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_file),
                    onPressed: () async {
                      await takePhoto();
                    },
                  ),
                  CustomStyleButton(
                    controller: editorController.quillController,
                    attribute: quill.Attribute.bold,
                    icon: Icons.format_bold,
                  ),
                  IconButton(
                    icon: const Icon(Icons.format_list_bulleted),
                    onPressed: () {
                      var controller = editorController.quillController;

                      var currentAttr = controller
                          .getSelectionStyle()
                          .attributes[quill.Attribute.list.key];

                      if (currentAttr == quill.Attribute.ul) {
                        controller.formatSelection(
                            quill.Attribute.clone(quill.Attribute.list, null));
                      } else {
                        controller.formatSelection(quill.Attribute.ul);
                      }
                    },
                  ),
                  CustomStyleButton(
                    controller: editorController.quillController,
                    attribute: quill.Attribute.italic,
                    icon: Icons.format_italic,
                  ),
                  SizedBox(width: 10.w),
                  Obx(
                    () {
                      return GestureDetector(
                        onTap: () => _showCustomColorPicker(context),
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: editorController.selectedColor.value,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void openFile(File file) {
    String fileExtension = file.path.split('.').last.toLowerCase();

    if (['jpg', 'jpeg', 'png'].contains(fileExtension)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageScreen(file: file),
        ),
      );
    } else if (fileExtension == 'pdf') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFScreen(file: file),
        ),
      );
    } else if (['xls', 'xlsx'].contains(fileExtension)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Excel file viewing not supported yet.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unsupported file type.')),
      );
    }
  }

  void _showCustomColorPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          height: 280,
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 10,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: customColors.length,
            itemBuilder: (_, index) {
              final color = customColors[index];
              return GestureDetector(
                onTap: () {
                  editorController.changeColor(color);
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black12),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> takePhoto() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        String? filePath = result.files.single.path;

        if (filePath == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: File path is null')),
          );
          return;
        }

        final File file = File(filePath);
        leadController.leadpickedFile.value = File(file.path);
        leadController.profilePicPath.value = file.path.toString();
        print(
            'selected file path from device is ${leadController.leadpickedFile.value}');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No file selected.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading file: $e')),
      );
    }
  }

  void _showBackgroundColorPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          height: 280,
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 10,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: customColors.length,
            itemBuilder: (_, index) {
              final color = customColors[index];
              return GestureDetector(
                onTap: () {
                  editorController.changeBackgroundColor(color);
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black12),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class CustomStyleButton extends StatelessWidget {
  final quill.QuillController controller;
  final quill.Attribute attribute;
  final IconData icon;

  const CustomStyleButton({
    Key? key,
    required this.controller,
    required this.attribute,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isToggled =
        controller.getSelectionStyle().attributes.containsKey(attribute.key);

    return IconButton(
      icon: Icon(icon, color: isToggled ? Colors.blue : Colors.black),
      onPressed: () {
        controller.formatSelection(
          isToggled ? quill.Attribute.clone(attribute, null) : attribute,
        );
      },
    );
  }
}
