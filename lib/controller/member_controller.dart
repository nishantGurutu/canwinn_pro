import 'package:get/get.dart';
import 'package:task_management/model/member_list_model.dart';
import 'package:task_management/service/member_service.dart';

class MemberController extends GetxController {
  var isMemberRoleLoading = false.obs;
  var memberListModel = MemberListModel().obs;
  MemberData? selectedMemberData;
  RxList<MemberData> memberList = <MemberData>[].obs;
  Future<void> memberListApi() async {
    isMemberRoleLoading.value = true;
    final result = await MemberClassService().memberListApi();
    if (result != null) {
      memberListModel.value = result;
      memberList.clear();
      memberList.assignAll(memberListModel.value.data!);
    } else {}
    isMemberRoleLoading.value = false;
  }
}
