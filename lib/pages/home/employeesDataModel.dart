class EmployeeDataModel {
  String name = '';
  int id = 0;
  String role = '';
  String fromDate = '';
  String toDate = '';

  EmployeeDataModel({this.name = '',this.id = 0, this.role = '', this.fromDate = '', this.toDate = ''});

  EmployeeDataModel.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? "";
    id = json['id'] ?? 0;
    role = json['role'] ?? "";
    fromDate = json['fromDate'] ?? "";
    toDate = json['toDate'] ?? "";
  }

}
