// import 'package:flutter/material.dart';
// import 'package:flutter_quill/flutter_quill.dart' as quill;
// import 'package:get/get.dart';

// class EditorController extends GetxController {
//   final quill.QuillController quillController = quill.QuillController.basic();
//   var selectedFont = Rxn<String>(); // Nullable
//   var selectedFontSize = Rxn<String>();
//   var selectedColor = Colors.brown.shade100.obs;
//   // var selectedBackgroundColor = Rx<Color>(Colors.transparent);

//   void changeFont(String font) {
//     selectedFont.value = font;
//     quillController.formatSelection(quill.Attribute.fromKeyValue('font', font));
//   }

//   void changeFontSize(String size) {
//     selectedFontSize.value = size;
//     quillController.formatSelection(quill.Attribute.fromKeyValue('size', size));
//   }

//   void changeColor(Color color) {
//     selectedColor.value = color;
//     final hexColor =
//         '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
//     quillController
//         .formatSelection(quill.Attribute.fromKeyValue('color', hexColor));
//   }

//   // void changeBackgroundColor(Color color) {
//   //   selectedBackgroundColor.value = color;
//   //   final hexColor = '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
//   //   quillController.formatSelection(quill.Attribute.fromKeyValue('background', hexColor));
//   // }
// }

// class NoteEditorScreen extends StatelessWidget {
//   final EditorController editorController = Get.put(EditorController());
//   final FocusNode _focusNode = FocusNode();
//   final TextEditingController _titleController = TextEditingController();

//   final List<String> fonts = [
//     'arial',
//     'serif',
//     'monospace',
//     'courier',
//     'calibri',
//     'verdana',
//     'times-new-roman',
//     'tahoma',
//     'impact',
//     'georgia',
//     'comic-sans-ms',
//     'lucida-console',
//     'garamond',
//     'palatino',
//     'bookman',
//     'candara',
//     'optima',
//     'corbel',
//     'segoe-ui',
//     'franklin-gothic',
//     'helvetica',
//     'futura',
//     'gill-sans',
//     'century-gothic',
//     'rockwell',
//     'raleway',
//     'opensans',
//     'montserrat',
//     'roboto',
//     'noto-sans',
//     'ubuntu',
//     'oxygen'
//   ];

//   final List<String> fontSizes = List.generate(30, (i) => "${8 + i}px");

//   final List<Color> customColors = [
//     Colors.white,
//     Colors.black,
//     Colors.red,
//     Colors.green,
//     Colors.blue,
//     Colors.yellow,
//     Colors.orange,
//     Colors.purple,
//     Colors.pink,
//     Colors.teal,
//     Colors.cyan,
//     Colors.lime,
//     Colors.indigo,
//     Colors.brown,
//     Colors.grey,
//     Colors.amber,
//     Colors.deepOrange,
//     Colors.deepPurple,
//     Colors.lightBlue,
//     Colors.lightGreen,
//     Colors.blueGrey,
//     Colors.red.shade100,
//     Colors.red.shade200,
//     Colors.red.shade300,
//     Colors.green.shade100,
//     Colors.green.shade200,
//     Colors.green.shade300,
//     Colors.blue.shade100,
//     Colors.blue.shade200,
//     Colors.blue.shade300,
//     Colors.pink.shade100,
//     Colors.pink.shade200,
//     Colors.pink.shade300,
//     Colors.orange.shade100,
//     Colors.orange.shade200,
//     Colors.orange.shade300,
//     Colors.purple.shade100,
//     Colors.purple.shade200,
//     Colors.purple.shade300,
//     Colors.teal.shade100,
//     Colors.teal.shade200,
//     Colors.teal.shade300,
//     Colors.indigo.shade100,
//     Colors.indigo.shade200,
//     Colors.indigo.shade300,
//     Colors.brown.shade100,
//     Colors.brown.shade200,
//     Colors.brown.shade300,
//     Colors.grey.shade100,
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFFDF1D4),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Get.back();
//           },
//         ),
//         title: const Text("Notes", style: TextStyle(color: Colors.black)),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.check, color: Colors.black),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: Obx(
//         () {
//           return Container(
//             color: editorController.selectedColor.value,
//             child: Column(
//               children: [
//                 Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                   child: TextField(
//                     controller: _titleController,
//                     style: const TextStyle(
//                         fontSize: 20, fontWeight: FontWeight.bold),
//                     decoration: const InputDecoration(
//                       hintText: "Title",
//                       border: InputBorder.none,
//                     ),
//                   ),
//                 ),
//                 // Expanded(
//                 //   child: Padding(
//                 //     padding: const EdgeInsets.symmetric(horizontal: 16),
//                 //     child: quill.QuillEditor(
//                 //       controller: editorController.quillController,
//                 //       focusNode: _focusNode,
//                 //       scrollController: ScrollController(),
//                 //     ),
//                 //   ),
//                 // ),
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: quill.QuillEditor(
//                       controller: editorController.quillController,
//                       focusNode: _focusNode,
//                       scrollController: ScrollController(),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   color: Colors.white,
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Row(
//                       children: [
//                         IconButton(
//                           icon: const Icon(Icons.undo),
//                           onPressed: () =>
//                               editorController.quillController.undo(),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.redo),
//                           onPressed: () =>
//                               editorController.quillController.redo(),
//                         ),
//                         CustomStyleButton(
//                           controller: editorController.quillController,
//                           attribute: quill.Attribute.bold,
//                           icon: Icons.format_bold,
//                         ),
//                         CustomStyleButton(
//                           controller: editorController.quillController,
//                           attribute: quill.Attribute.italic,
//                           icon: Icons.format_italic,
//                         ),
//                         CustomStyleButton(
//                           controller: editorController.quillController,
//                           attribute: quill.Attribute.underline,
//                           icon: Icons.format_underline,
//                         ),
//                         Obx(() {
//                           return DropdownButton<String>(
//                             value: editorController.selectedFont.value,
//                             hint: const Text("Font"),
//                             items: fonts.map((font) {
//                               return DropdownMenuItem<String>(
//                                 value: font,
//                                 child: Text(font,
//                                     style: TextStyle(fontFamily: font)),
//                               );
//                             }).toList(),
//                             onChanged: (value) {
//                               if (value != null)
//                                 editorController.changeFont(value);
//                             },
//                           );
//                         }),
//                         const SizedBox(width: 10),
//                         Obx(() {
//                           return DropdownButton<String>(
//                             value: editorController.selectedFontSize.value,
//                             hint: const Text("Size"),
//                             items: fontSizes.map((size) {
//                               return DropdownMenuItem<String>(
//                                 value: size,
//                                 child: Text(size),
//                               );
//                             }).toList(),
//                             onChanged: (value) {
//                               if (value != null)
//                                 editorController.changeFontSize(value);
//                             },
//                           );
//                         }),
//                         const SizedBox(width: 10),
//                         Obx(() {
//                           return GestureDetector(
//                             onTap: () => _showCustomColorPicker(context),
//                             child: Container(
//                               width: 24,
//                               height: 24,
//                               decoration: BoxDecoration(
//                                 color: editorController.selectedColor.value,
//                                 shape: BoxShape.circle,
//                                 border: Border.all(color: Colors.black),
//                               ),
//                             ),
//                           );
//                         }),
//                         // Background color picker button
//                         // Obx(() {
//                         //   return GestureDetector(
//                         //     onTap: () => _showBackgroundColorPicker(context),
//                         //     child: Container(
//                         //       margin: const EdgeInsets.only(left: 10),
//                         //       width: 24,
//                         //       height: 24,
//                         //       decoration: BoxDecoration(
//                         //         color: editorController.selectedBackgroundColor.value == Colors.transparent
//                         //             ? Colors.grey.shade300
//                         //             : editorController.selectedBackgroundColor.value,
//                         //         shape: BoxShape.circle,
//                         //         border: Border.all(color: Colors.black),
//                         //       ),
//                         //       child: const Icon(Icons.format_color_fill, size: 16, color: Colors.black54),
//                         //     ),
//                         //   );
//                         // }),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   void _showCustomColorPicker(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (_) {
//         return Container(
//           height: 280,
//           padding: const EdgeInsets.all(16),
//           child: GridView.builder(
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 10,
//               crossAxisSpacing: 8,
//               mainAxisSpacing: 8,
//             ),
//             itemCount: customColors.length,
//             itemBuilder: (_, index) {
//               final color = customColors[index];
//               return GestureDetector(
//                 onTap: () {
//                   editorController.changeColor(color);
//                   Navigator.pop(context);
//                 },
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: color,
//                     shape: BoxShape.circle,
//                     border: Border.all(color: Colors.black12),
//                   ),
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }

//   // void _showBackgroundColorPicker(BuildContext context) {
//   //   showModalBottomSheet(
//   //     context: context,
//   //     builder: (_) {
//   //       return Container(
//   //         height: 280,
//   //         padding: const EdgeInsets.all(16),
//   //         child: GridView.builder(
//   //           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//   //             crossAxisCount: 10,
//   //             crossAxisSpacing: 8,
//   //             mainAxisSpacing: 8,
//   //           ),
//   //           itemCount: customColors.length,
//   //           itemBuilder: (_, index) {
//   //             final color = customColors[index];
//   //             return GestureDetector(
//   //               onTap: () {
//   //                 editorController.changeBackgroundColor(color);
//   //                 Navigator.pop(context);
//   //               },
//   //               child: Container(
//   //                 decoration: BoxDecoration(
//   //                   color: color,
//   //                   shape: BoxShape.circle,
//   //                   border: Border.all(color: Colors.black12),
//   //                 ),
//   //               ),
//   //             );
//   //           },
//   //         ),
//   //       );
//   //     },
//   //   );
//   // }
// }

// class CustomStyleButton extends StatelessWidget {
//   final quill.QuillController controller;
//   final quill.Attribute attribute;
//   final IconData icon;

//   const CustomStyleButton({
//     Key? key,
//     required this.controller,
//     required this.attribute,
//     required this.icon,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final isToggled =
//         controller.getSelectionStyle().attributes.containsKey(attribute.key);

//     return IconButton(
//       icon: Icon(icon, color: isToggled ? Colors.blue : Colors.black),
//       onPressed: () {
//         controller.formatSelection(
//           isToggled ? quill.Attribute.clone(attribute, null) : attribute,
//         );
//       },
//     );
//   }
// }
