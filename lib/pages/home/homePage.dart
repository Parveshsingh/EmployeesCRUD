import 'package:demoapp/common/commonWidget.dart';
import 'package:demoapp/common/images.dart';
import 'package:demoapp/common/text_styles.dart';
import 'package:demoapp/pages/addEditEmployee/addEditEmployeePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../dbHelper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../pages/home/homePageBloc.dart';
import '../../common/states.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key}) {
    initPreferences();
  }

  static late EmployeeDatabase dbHelper;

  static initPreferences() async {
    dbHelper = EmployeeDatabase.instance;
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomePageBloc _bloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = HomePageBloc();
    _bloc.add(BlocEvent(event: HomePageEvent.list));
  }

  editEmployeeDetails(employeeId) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => AddEditEmployeePage(
          id: employeeId,
        ),
      ),
    ).then((value) {
      _bloc.add(BlocEvent(event: HomePageEvent.list));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Text("Employee List"),
          actions: [
            IconButton(
              tooltip: "Refresh",
                onPressed: () {
                  ScaffoldMessenger.of(
                      _scaffoldKey.currentContext!)
                      .hideCurrentSnackBar();
                  _bloc.add(BlocEvent(event: HomePageEvent.list));
                },
                icon: const Icon(Icons.refresh))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: "Add New Employee",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => AddEditEmployeePage(),
              ),
            ).then((value) {
              _bloc.add(BlocEvent(event: HomePageEvent.list));
            });
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                10.0), // Adjust the border radius to 0 for a square shape
          ),
          child: const Icon(Icons.add),
        ),
        body: BlocConsumer<HomePageBloc, ParentState>(
          listener: (context, state) {
            if (state.state == HomePageState.loading) {
              showLoader(context);
            } else if (state.state == HomePageState.success) {
              cancelLoader(context);
            } else if (state.state == HomePageState.error) {
              cancelLoader(context);
              showToast(state.data);
            } else if (state.state ==
                HomePageState.deleteFromCurrentEmployeesSuccess) {
              cancelLoader(context);
              showSnackBar(state.data);
            } else if (state.state ==
                HomePageState.deleteFromPreviousEmployeesSuccess) {
              cancelLoader(context);
              showSnackBarPreviousEmployees(state.data);
            } else if (state.state == HomePageState.removePermanentlySuccess) {
              cancelLoader(context);
              _bloc.add(BlocEvent(event: HomePageEvent.list));
            } else if (state.state ==
                HomePageState.undoCurrentEmployeesSuccess) {
              cancelLoader(context);
            } else if (state.state ==
                HomePageState.undoPreviousEmployeesSuccess) {
              cancelLoader(context);
            }
          },
          builder: (context, state) {
            if (state.state == HomePageState.success ||
                state.state == HomePageState.undoCurrentEmployeesSuccess ||
                state.state == HomePageState.undoPreviousEmployeesSuccess ||
                state.state ==
                    HomePageState.deleteFromPreviousEmployeesSuccess ||
                state.state == HomePageState.removePermanentlySuccess ||
                state.state ==
                    HomePageState.deleteFromCurrentEmployeesSuccess) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        "Current Employees",
                        style: semiBoldTextStyle(
                            color: Colors.blue, fontSize: 18.0),
                      ),
                    ),
                    Card(
                      child: _bloc.currentEmployees.isNotEmpty
                          ? ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _bloc.currentEmployees.length,
                              separatorBuilder: (context, index) {
                                return const Divider(
                                  height: 2,
                                  color: Colors.grey,
                                );
                              },
                              itemBuilder: (context, index) {
                                var employee = _bloc.currentEmployees[index];
                                return Slidable(
                                  closeOnScroll: true,
                                  enabled: true,
                                  endActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context1) {
                                          ScaffoldMessenger.of(
                                                  _scaffoldKey.currentContext!)
                                              .hideCurrentSnackBar();
                                          showAlertDialog(context,
                                              dialogTitle: "Delete Alert",
                                              isCancellable: true,
                                              textMsg:
                                                  "Do You Want to delete this....",
                                              onPressed: () {
                                            _bloc.employeesId = employee.id;
                                            _bloc.add(BlocEvent(
                                                event: HomePageEvent
                                                    .deleteFromCurrentEmployeesUi,
                                                data: index));
                                            Navigator.pop(context);
                                          });
                                        },
                                        label: 'Delete',
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete,
                                      )
                                    ],
                                  ),
                                  child: ListTile(
                                    onTap: () {
                                      editEmployeeDetails(employee.id);
                                    },
                                    visualDensity: const VisualDensity(
                                        horizontal: 2.0, vertical: 3.0),
                                    title: Text(
                                      employee.name,
                                      style: semiBoldTextStyle(fontSize: 18.0),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(employee.role),
                                        Text(
                                            'From ${dateFormatter(employee.fromDate)}'),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Center(
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text("No Current Employees Found"),
                              ),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        "Previous Employees",
                        style: semiBoldTextStyle(
                            color: Colors.blue, fontSize: 18.0),
                      ),
                    ),
                    Card(
                      child: _bloc.previousEmployees.isNotEmpty
                          ? ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _bloc.previousEmployees.length,
                              separatorBuilder: (context, index) {
                                return const Divider(
                                  height: 2,
                                  color: Colors.grey,
                                );
                              },
                              itemBuilder: (context, index) {
                                var employee = _bloc.previousEmployees[index];
                                return Slidable(
                                  closeOnScroll: true,
                                  enabled: true,
                                  endActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context1) {
                                          ScaffoldMessenger.of(
                                                  _scaffoldKey.currentContext!)
                                              .hideCurrentSnackBar();
                                          showAlertDialog(context,
                                              dialogTitle: "Delete Alert",
                                              isCancellable: true,
                                              textMsg:
                                                  "Do You Want to delete this....",
                                              onPressed: () {
                                            _bloc.employeesId = employee.id;
                                            _bloc.add(BlocEvent(
                                                event: HomePageEvent
                                                    .deleteFromPreviousEmployeesUi,
                                                data: index));
                                            Navigator.pop(context);
                                          });
                                        },
                                        label: 'Delete',
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete,
                                      )
                                    ],
                                  ),
                                  child: ListTile(
                                    onTap: () {
                                      editEmployeeDetails(employee.id);
                                    },
                                    visualDensity: const VisualDensity(
                                        horizontal: 2.0, vertical: 3.0),
                                    title: Text(
                                      employee.name,
                                      style: semiBoldTextStyle(fontSize: 18.0),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(employee.role),
                                        Text(
                                            '${dateFormatter(employee.fromDate)} - ${dateFormatter(employee.toDate)}'),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Center(
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text("No Previous Employees Found"),
                              ),
                            ),
                    ),
                    Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            'Swipe Left to delete',
                            style: regular_TextStyle(color: Colors.grey[700]),
                          ),
                        )),
                  ],
                ),
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Images.searchRecordImg,
                  ),
                  Text(
                    "No Employee Record Found",
                    style: semiBoldTextStyle(fontSize: 20.0),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  void showSnackBarPreviousEmployees(index) {
    final snackBar = SnackBar(
      content: const Text('Employee Data Has Been Deleted'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          _bloc.add(BlocEvent(
              event: HomePageEvent.undoPreviousEmployeesData, data: index));
          ScaffoldMessenger.of(_scaffoldKey.currentContext!)
              .hideCurrentSnackBar();
        },
      ),
    );

    ScaffoldMessenger.of(_scaffoldKey.currentContext!)
        .showSnackBar(snackBar)
        .closed
        .then((reason) {
      printText("The snackbar Closed previous");
      _bloc.add(BlocEvent(event: HomePageEvent.removePermanently));
    });
  }

  void showSnackBar(index) {
    final snackBar = SnackBar(
      content: const Text('Employee Data Has Been Deleted'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          _bloc.add(BlocEvent(
              event: HomePageEvent.undoCurrentEmployeesData, data: index));
          ScaffoldMessenger.of(_scaffoldKey.currentContext!)
              .hideCurrentSnackBar();
        },
      ),
    );

    ScaffoldMessenger.of(_scaffoldKey.currentContext!)
        .showSnackBar(snackBar)
        .closed
        .then((reason) {
      printText("The snackbar Closed Current");
      _bloc.add(BlocEvent(event: HomePageEvent.removePermanently));
    });
  }
}
