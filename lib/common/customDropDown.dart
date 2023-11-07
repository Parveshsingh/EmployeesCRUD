import 'package:flutter/material.dart';
import 'decoration.dart';

class CustomDropdown extends StatefulWidget {
  final List<String> options;
  final Function(String) onOptionSelected;
  final String hintText;
  TextEditingController roleController = TextEditingController();

  CustomDropdown(
      {super.key,
      required this.options,
      required this.onOptionSelected,
      required this.roleController,
      required this.hintText});

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {

  String selectedOption = '';

  @override
  void dispose() {
    widget.roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: inputfieldDecoration(
        widget.hintText,
        suffixIcon: const Icon(
          Icons.arrow_drop_down,
          color: Colors.blue,
        ),
        prefixIcon: const Icon(Icons.shopping_bag_outlined,color: Colors.blue,)
      ),
      controller: widget.roleController,
      readOnly: true,
      onTap: () {
        _showDropdown(context);
      },
    );
  }

  void _showDropdown(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final numItems = widget.options.length;
        final maxHeight = MediaQuery.of(context).size.height /2;
        const itemHeight = 70.0;
        final calculatedHeight = numItems * itemHeight;
        final height =
            calculatedHeight < maxHeight ? calculatedHeight : maxHeight;
        return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
          ),),
          height: height,
          child: ListView(
            shrinkWrap: true,
            children: widget.options.map((option) {
              return ListTile(
                title: Text(option),
                onTap: () {
                  setState(() {
                    selectedOption = option;
                    widget.roleController.text = selectedOption;
                  });
                  widget.onOptionSelected(option);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
