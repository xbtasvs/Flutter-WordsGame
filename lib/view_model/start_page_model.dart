import 'package:get/get.dart';
import 'package:words/model/user_model.dart';
import 'package:words/controller/user_controller.dart';

class StartPageModel extends GetxController {
  List<UserModel> userList = <UserModel>[].obs;
  Rx<bool> userListLoaded = false.obs;

  UserController controller = UserController();

  @override
  void onInit() {
    controller = UserController();
    getUserList();
    super.onInit();
  }

  void getUserList() async {
    List<UserModel> resultList = await UserController().users();
    userListLoaded.value = true;
    if (resultList != null) {
      userList = resultList;
      print(userList);
    }
  }

  Future<void> addUserName(String name) async {
    // UserModel thisComment = UserModel(
    //   id: 0,
    //   name: name,
    // );

    // userList.add(thisComment);

    bool result = await controller.insertUser(name);
    if (result) {
      getUserList();
    }
  }

  Future<bool> deleteUser(List ids) async {
    for (var id in ids) {
      await controller.deleteUser(id);
    }
    getUserList();
    return true;
  }
}
