enum RoleState {
  customer('ROLECUSTOMER', 'Khách hàng'),
  deliverer('ROLEDELIVERER', 'Người giao hàng'),
  kitchenManager('ROLEKITCHENMANAGER', 'Quản lý bếp');

  const RoleState(this.code, this.message);

  final String code;
  final String message;
}

enum ActiveStatus {
  delete,
  active,
  ban,
}
