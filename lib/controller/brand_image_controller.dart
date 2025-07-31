import 'package:get/get.dart';
import 'package:task_management/model/brand_image_model.dart';
import 'package:task_management/service/branding_image_service.dart';

class BrandingImageController extends GetxController {
  var isScrolling = false.obs;
  var isBrandingImageLoading = false.obs;
  RxList<BrandImageData> brandImages = <BrandImageData>[].obs;
  Future<void> brandImageList(String type) async {
    if (type == 'scroll') {
      isScrolling.value = true;
    } else {
      isBrandingImageLoading.value = true;
    }
    final result = await BrandingImageService().overlayImageList();
    if (result != null) {
      brandImages.assignAll(result.data!);
      brandImages.refresh();
      isScrolling.value = false;
      isBrandingImageLoading.value = false;
    } else {
      isScrolling.value = false;
      isBrandingImageLoading.value = false;
    }
    isScrolling.value = false;
    isBrandingImageLoading.value = false;
  }
}
