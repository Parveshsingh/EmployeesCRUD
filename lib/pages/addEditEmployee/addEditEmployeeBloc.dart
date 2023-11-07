import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../common/states.dart';
import '../../common/commonWidget.dart';
import '../../pages/home/homePage.dart';
import '../../pages/home/employeesDataModel.dart';
import 'package:intl/intl.dart';


enum AddEditEmployeEvent { add,getData,update }

enum AddEditEmployeState { success, error, loading,getDataSuccess,updateSuccess }

class AddEditEmployeBloc extends Bloc<BlocEvent, ParentState> {

  DateTime focusedFromDay = DateTime.now();
  DateTime focusedToDay = DateTime.now();
  DateTime? selectedFromDay;
  DateTime? selectedToDay;

  TextEditingController employeeNameController = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController selectedRoleController = TextEditingController();


  final List<String> roleList = [
    'Product Designer',
    'Flutter Developer',
    'QA Tester',
    'Product Owner'
  ];
  String selectedRole = '';

  AddEditEmployeBloc() : super(InitState()) {
    on((BlocEvent event, emit) async {
      switch (event.event) {
        case AddEditEmployeEvent.add:
          {
            emit(BlocState(state: AddEditEmployeState.loading));
            try {
              
              var employees = {
                'name': employeeNameController.text,
                'role': selectedRole,
                'fromDate': selectedFromDay != null ? selectedFromDay!.toLocal()
                    .toString()
                    .split(' ')[0]
                    .toString() : "",
                'toDate': selectedToDay != null ? selectedToDay!.toLocal()
                    .toString()
                    .split(' ')[0]
                    .toString() : "",
              };

              await HomePage.dbHelper.insertEmployee(employees);

              emit(BlocState(state: AddEditEmployeState.success));
            } catch (e) {
              emit(BlocState(state: AddEditEmployeState.error, data: e.toString()));
            }
          }
          break;
        case AddEditEmployeEvent.update:
          {
            emit(BlocState(state: AddEditEmployeState.loading));
            try {
              var employeeId = event.data;

              var employees = {
                'name': employeeNameController.text,
                'role': selectedRole,
                'fromDate': selectedFromDay != null ? selectedFromDay!.toLocal()
                    .toString()
                    .split(' ')[0]
                    .toString() : "",
                'toDate': selectedToDay != null ? selectedToDay!.toLocal()
                    .toString()
                    .split(' ')[0]
                    .toString() : "",
              };

              await HomePage.dbHelper.updateEmployee(employeeId,employees);

              emit(BlocState(state: AddEditEmployeState.updateSuccess));
            } catch (e) {
              emit(BlocState(state: AddEditEmployeState.error, data: e.toString()));
            }
          }
          break;
        case AddEditEmployeEvent.getData:
          {
            emit(BlocState(state: AddEditEmployeState.loading));
            try {
              var employeeId = event.data;
              var data = await HomePage.dbHelper.getEmployeeById(employeeId);
              printText("DAta is $data");
              EmployeeDataModel employeeDataModel = EmployeeDataModel.fromJson(data as Map<String,dynamic>);
              employeeNameController.text = employeeDataModel.name;
              selectedRole = employeeDataModel.role;
              selectedRoleController.text = employeeDataModel.role;
              DateFormat format = DateFormat("yyyy-MM-dd");

              if(employeeDataModel.fromDate != "")
              {
                selectedFromDay = format.parse(employeeDataModel.fromDate);
              }else{
                selectedFromDay = null;
              }

              if(selectedFromDay == null)
                {
                  fromDateController.text = "";
                }
              else if (selectedFromDay!.toLocal().toString().split(' ')[0] ==
                  DateTime.now().toLocal().toString().split(' ')[0]) {
                fromDateController.text = "Today";
              } else if (selectedFromDay!.toLocal().toString().split(' ')[0] ==
                  checkNextMonday().toString().split(' ')[0]) {
                fromDateController.text = "Next Monday";
              } else if (selectedFromDay!.toLocal().toString().split(' ')[0] ==
                  checkNextTuesday().toString().split(' ')[0]) {
                fromDateController.text = "Next Tuesday";
              } else {
                fromDateController.text = dateFormatter(selectedFromDay!
                    .toLocal()
                    .toString()
                    .split(' ')[0]
                    .toString());
              }
              if(employeeDataModel.toDate != "")
                {
                  selectedToDay = format.parse(employeeDataModel.toDate);
                }else
                  {
                    selectedToDay = null;
                  }


              if (selectedToDay == null) {
                toDateController.text = "No Date";
              } else if (selectedToDay!.toLocal().toString().split(' ')[0] ==
                  DateTime.now().toLocal().toString().split(' ')[0]) {
                toDateController.text = "Today";
              } else {
                toDateController.text = dateFormatter(selectedToDay!
                    .toLocal()
                    .toString()
                    .split(' ')[0]
                    .toString());
              }

              emit(BlocState(state: AddEditEmployeState.getDataSuccess));
            } catch (e) {
              emit(BlocState(state: AddEditEmployeState.error, data: e.toString()));
            }
          }
          break;

      }
    });
  }
}

