import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../common/states.dart';
import '../../common/commonWidget.dart';
import '../../pages/home/homePage.dart';
import '../../pages/home/employeesDataModel.dart';

enum HomePageEvent {
  list,
  deleteFromCurrentEmployeesUi,
  deleteFromPreviousEmployeesUi,
  removePermanently,
  undoCurrentEmployeesData,
  undoPreviousEmployeesData,
}

enum HomePageState {
  success,
  error,
  loading,
  deleteFromCurrentEmployeesSuccess,
  deleteFromPreviousEmployeesSuccess,
  removePermanentlySuccess,
  undoCurrentEmployeesSuccess,
  undoPreviousEmployeesSuccess
}

class HomePageBloc extends Bloc<BlocEvent, ParentState> {
  List<EmployeeDataModel> emplyeeList =
      List<EmployeeDataModel>.empty(growable: true);
  List<EmployeeDataModel> currentEmployees =
      List<EmployeeDataModel>.empty(growable: true);
  List<EmployeeDataModel> previousEmployees =
      List<EmployeeDataModel>.empty(growable: true);

  int employeesId = 0;
  EmployeeDataModel currentEmployeeDataModel = EmployeeDataModel();
  EmployeeDataModel previousEmployeeDataModel = EmployeeDataModel();

  HomePageBloc() : super(InitState()) {
    on((BlocEvent event, emit) async {
      switch (event.event) {
        case HomePageEvent.list:
          {
            emit(BlocState(state: HomePageState.loading));
            try {
              var data = await HomePage.dbHelper.queryAllEmployees();
              emplyeeList = (data as List<dynamic>)
                  .map((e) =>
                      EmployeeDataModel.fromJson(e as Map<String, dynamic>))
                  .toList();
              if (emplyeeList.isNotEmpty) {
                currentEmployees = emplyeeList
                    .where((employee) => employee.toDate == "")
                    .toList();
                previousEmployees = emplyeeList
                    .where((employee) => employee.toDate != "")
                    .toList();
                emit(BlocState(state: HomePageState.success));
              } else {
                emit(BlocState(
                    state: HomePageState.error, data: "No Data Found"));
              }
            } catch (e) {
              emit(BlocState(state: HomePageState.error, data: e.toString()));
            }
          }
          break;
        case HomePageEvent.deleteFromCurrentEmployeesUi:
          {
            emit(BlocState(state: HomePageState.loading));
            try {
              var index = event.data;
              currentEmployeeDataModel = currentEmployees[index];
              currentEmployees.removeAt(index);

              emit(BlocState(state: HomePageState.deleteFromCurrentEmployeesSuccess, data: index));
            } catch (e) {
              emit(BlocState(state: HomePageState.error, data: e.toString()));
            }
          }
          break;
        case HomePageEvent.deleteFromPreviousEmployeesUi:
          {
            emit(BlocState(state: HomePageState.loading));
            try {
              var index = event.data;
              previousEmployeeDataModel = previousEmployees[index];
              previousEmployees.removeAt(index);
              emit(BlocState(state: HomePageState.deleteFromPreviousEmployeesSuccess, data: index));
            } catch (e) {
              emit(BlocState(state: HomePageState.error, data: e.toString()));
            }
          }
          break;
        case HomePageEvent.removePermanently:
          {
            try {
              var data =
                  await HomePage.dbHelper.deleteEmployee(employeesId);

              emit(BlocState(state: HomePageState.removePermanentlySuccess));
            } catch (e) {
              emit(BlocState(state: HomePageState.error, data: e.toString()));
            }
          }
          break;
        case HomePageEvent.undoCurrentEmployeesData:
          {
            emit(BlocState(state: HomePageState.loading));
            try {
              var index = event.data;
              currentEmployees.insert(index, currentEmployeeDataModel);
              emit(BlocState(state: HomePageState.undoCurrentEmployeesSuccess));
            } catch (e) {
              emit(BlocState(state: HomePageState.error, data: e.toString()));
            }
          }
          break;
        case HomePageEvent.undoPreviousEmployeesData:
          {
            emit(BlocState(state: HomePageState.loading));
            try {
              var index = event.data;
              previousEmployees.insert(index, previousEmployeeDataModel);
              emit(BlocState(state: HomePageState.undoPreviousEmployeesSuccess));
            } catch (e) {
              emit(BlocState(state: HomePageState.error, data: e.toString()));
            }
          }
          break;
      }
    });
  }
}
