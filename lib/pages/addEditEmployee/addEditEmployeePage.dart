import 'package:demoapp/common/commonWidget.dart';
import 'package:demoapp/common/decoration.dart';
import 'package:demoapp/common/text_styles.dart';
import 'package:demoapp/pages/addEditEmployee/addEditEmployeeBloc.dart';
import 'package:demoapp/pages/addEditEmployee/fromCustomDateDialog.dart';
import 'package:demoapp/pages/addEditEmployee/toCustomDateDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../common/customDropDown.dart';
import '../../common/states.dart';

class AddEditEmployeePage extends StatefulWidget {
   final id;
   const AddEditEmployeePage({super.key,this.id});

  @override
  State<AddEditEmployeePage> createState() => _AddEditEmployeePageState();
}

class _AddEditEmployeePageState extends State<AddEditEmployeePage> {
  late AddEditEmployeBloc _bloc;

  String saveButtonText = "Save";
  String appbarText = "Add Employee Details";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = AddEditEmployeBloc();

    if(widget.id != null)
      {
        _bloc.add(BlocEvent(event: AddEditEmployeEvent.getData,data: widget.id));
        setState(() {
          saveButtonText = "Update";
          appbarText = "Update Employee Details";
        });
      }else
        {
          _bloc.selectedFromDay = DateTime.now();
          _bloc.fromDateController.text = "Today";
          _bloc.selectedToDay = null;
          _bloc.toDateController.text = "No Date";
        }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: AppBar(
          title:  Text(appbarText),
        ),
        body: BlocConsumer<AddEditEmployeBloc, ParentState>(
          listener: (context, state) {
            if (state.state == AddEditEmployeState.loading) {
              showLoader(context);
            } else if (state.state == AddEditEmployeState.success) {
              cancelLoader(context);
              Navigator.pop(context, true);
            } else if (state.state == AddEditEmployeState.error) {
              cancelLoader(context);
              showToast(state.data);
            }else if(state.state == AddEditEmployeState.getDataSuccess)
              {
                cancelLoader(context);
              }else if(state.state == AddEditEmployeState.updateSuccess)
                {
                  cancelLoader(context);
                  Navigator.pop(context, true);
                }
          },
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Form(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, top: 15.0, bottom: 8.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _bloc.employeeNameController,
                          decoration: inputfieldDecoration("Employee Name",
                              prefixIcon: const Icon(
                                Icons.perm_identity,
                                color: Colors.blue,
                              )),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomDropdown(
                          hintText: "Select Role",
                          options: _bloc.roleList,
                          roleController: _bloc.selectedRoleController,
                          onOptionSelected: (option) {
                            setState(() {
                              _bloc.selectedRole = option;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  printText("text");
                                },
                                child: TextFormField(
                                  readOnly: true,
                                  controller: _bloc.fromDateController,
                                  decoration: inputfieldDecoration("Date",
                                      prefixIcon: IconButton(
                                          onPressed: () {
                                            showFromDateDialog();
                                          },
                                          icon: const Icon(
                                            Icons.calendar_today,
                                            color: Colors.blue,
                                          ))),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 15.0, right: 15.0),
                              child: Icon(
                                Icons.arrow_forward,
                                color: Colors.blue,
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  showToDateDialog();
                                },
                                child: TextFormField(
                                  readOnly: true,
                                  controller: _bloc.toDateController,
                                  decoration: inputfieldDecoration("Date",
                                      prefixIcon: IconButton(
                                        onPressed: () {
                                          showToDateDialog();
                                        },
                                        icon: const Icon(
                                          Icons.calendar_today,
                                          color: Colors.blue,
                                        ),
                                      )),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[50], elevation: 0),
                        child: Text(
                          'Cancel',
                          style: semiBoldTextStyle(color: Colors.blue),
                        ),
                      ),
                      const SizedBox(width: 20.0),
                      ElevatedButton(
                        onPressed: () {
                          if(validatePage())
                            {
                              if(widget.id != null)
                              {
                                _bloc.add(BlocEvent(event: AddEditEmployeEvent.update,data: widget.id));
                              }else
                              {
                                _bloc.add(BlocEvent(event: AddEditEmployeEvent.add));
                              }
                            }
                        },
                        child:  Text(saveButtonText),
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  validatePage()
  {
    if(_bloc.employeeNameController.text.isEmpty)
      {
        showToast("Please Enter Employee Name");
        return false;
      }else if(_bloc.selectedRoleController.text.isEmpty)
        {
          showToast("Please Select Role");
          return false;
        }else
          {
            return true;
          }
  }

  showFromDateDialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return FromDateDialog(
            bloc: _bloc,
          );
        }).then((value) {
      if (value) {
        if (_bloc.selectedFromDay!.toLocal().toString().split(' ')[0] ==
            DateTime.now().toLocal().toString().split(' ')[0]) {
          _bloc.fromDateController.text = "Today";
        } else if (_bloc.selectedFromDay!.toLocal().toString().split(' ')[0] ==
            checkNextMonday().toString().split(' ')[0]) {
          _bloc.fromDateController.text = "Next Monday";
        } else if (_bloc.selectedFromDay!.toLocal().toString().split(' ')[0] ==
            checkNextTuesday().toString().split(' ')[0]) {
          _bloc.fromDateController.text = "Next Tuesday";
        } else {
          _bloc.fromDateController.text = dateFormatter(_bloc.selectedFromDay!
              .toLocal()
              .toString()
              .split(' ')[0]
              .toString());
        }
      } else {
        _bloc.fromDateController.text = "";
      }
    });
  }

  showToDateDialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return ToCustomDateDialog(
            bloc: _bloc,
          );
        }).then((value) {
      if (value) {
        if (_bloc.selectedToDay == null) {
          _bloc.toDateController.text = "No Date";
        } else if (_bloc.selectedToDay!.toLocal().toString().split(' ')[0] ==
            DateTime.now().toLocal().toString().split(' ')[0]) {
          _bloc.toDateController.text = "Today";
        } else {
          _bloc.toDateController.text = dateFormatter(_bloc.selectedToDay!
              .toLocal()
              .toString()
              .split(' ')[0]
              .toString());
        }
      } else {
        _bloc.toDateController.text = "";
      }
    });
  }
}
