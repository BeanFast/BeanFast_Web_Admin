import 'package:get/get.dart';

import '/models/role.dart';
import '/enums/menu_index_enum.dart';
import '/enums/auth_state_enum.dart';
import '/models/user.dart';

Map<String, int> rowSize = {'5': 5, '10': 10, '15': 15, '20': 20};

List<Role> listRole = [];
Role? selectedRole;
Rx<User> currentUser = User().obs;
RxInt selectedMenuIndex = MenuIndexState.customer.index.obs;
Rx<AuthState> authState = AuthState.unauthenticated.obs;

void changeRole(String code) {
  selectedRole = listRole.firstWhereOrNull((e) => e.code == code);
}

void changePage(int index) {
  selectedMenuIndex.value = index;
}
