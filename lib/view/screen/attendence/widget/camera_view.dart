import "dart:io";
import "package:camera/camera.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:task_management/controller/attendence/attendence_controller.dart";
import "package:task_management/controller/register_controller.dart";
import "package:task_management/controller/task_controller.dart";

class CameraView extends StatefulWidget {
  final List<CameraDescription> cameras;
  final String type;
  final String latitude;
  final String longitude;
  final String attendenceTime;
  final String address;
  const CameraView({
    super.key,
    required this.cameras,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.attendenceTime,
    required this.address,
  });

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  final AttendenceController attendenceController = Get.find();
  final RegisterController registerController = Get.find();
  CameraController? controller;
  String imagePath = "";
  List<CameraDescription> cameras = [];

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  bool isBack = false;

  Future<void> initializeCamera() async {
    controller = CameraController(widget.cameras[1], ResolutionPreset.max);
    await controller?.initialize();
    if (mounted) {
      setState(() {
        isBack = false;
      });
    }
  }

  Future<void> initializeCamera1() async {
    controller = CameraController(widget.cameras[0], ResolutionPreset.max);
    await controller?.initialize();
    if (mounted) {
      setState(() {
        isBack = true;
      });
    }
  }

  File? pickedImage;
  final TaskController taskController = Get.find();

  final TextEditingController addressTextEditingController =
      TextEditingController();
  Rx<File> pickedFile = File('').obs;
  void captureImage({String? address}) async {
    try {
      final XFile? pickImage = await controller?.takePicture();
      print('picked image value from camera is ${pickImage?.path}');
      if (pickImage != null) {
        pickedFile.value = File(pickImage.path);
        print('picked image value from camera is 2 ${pickedFile.value}');

        if (widget.type == "checkin") {
          if (attendenceController.attendenceUserDetails.value?.data?.punchin ==
              1) {
            Get.back();
            await attendenceController.attendencePunchout(
                pickedFile.value,
                address ?? "",
                widget.latitude,
                widget.longitude,
                widget.attendenceTime,
                "",
                pickedFile.value);
          } else {
            Get.back();
            await attendenceController.attendencePunching(
                pickedFile.value,
                address ?? "",
                widget.latitude,
                widget.longitude,
                widget.attendenceTime,
                "",
                pickedFile.value);
          }
        }
      }
    } catch (e) {
      print("Error taking picture: $e");
    }
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: double.infinity,
          child: controller == null
              ? Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                  ),
                )
              : CameraPreview(controller!),
        ),
        Positioned(
          right: 5.w,
          left: 290.w,
          top: 25.h,
          child: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.close,
              size: 35,
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
          right: 145.w,
          left: 145.w,
          bottom: 30.h,
          child: GestureDetector(
            onTap: () async {
              captureImage(address: widget.address);
            },
            child: Image.asset("assets/images/png/Image-Capture.png"),
          ),
        ),
      ],
    );
  }
}
