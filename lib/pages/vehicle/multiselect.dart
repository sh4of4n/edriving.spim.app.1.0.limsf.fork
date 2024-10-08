import 'package:flutter/material.dart';

class MultiSelect extends StatefulWidget {
  final List<String> groupID;
  final List<String> initialSelectedGroup;
  final title;
  const MultiSelect({
    Key? key, 
    required this.groupID,
    required this.initialSelectedGroup,
    required this.title,
  }) : super(key: key);

  @override
  State<MultiSelect> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  late List<String> selectedGroup;

  @override
  void initState() {
    super.initState();
    selectedGroup = List.from(widget.initialSelectedGroup); // Initialize selectedGroup
  }

  void itemChange(String itemValue, bool isSelected) {
  setState(() {
    if (itemValue == "ALL") {
      if (isSelected) {
        // Select all options
        selectedGroup = List.from(widget.groupID);
      } else {
        // Deselect all options
        selectedGroup.clear();
      }
    } else {
      if (isSelected) {
        selectedGroup.add(itemValue);
        // Check if all other items are selected
        // if (selectedGroup.length == widget.groupID.length - 1 && selectedGroup.contains("ALL")) {
        //   // If all other items are selected, check "ALL"
        //   selectedGroup.add("ALL");
        // }
      } else {
        selectedGroup.remove(itemValue);
        // Deselect "ALL" if not all items are selected
        // selectedGroup.remove("ALL");
      }
    }
  });
}


  void _submit() {
    Navigator.pop(context, selectedGroup);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${widget.title}'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.groupID
              .map((item) => CheckboxListTile(
                  value: selectedGroup.contains(item),
                  title: Text(item),
                  onChanged: (isChecked) => itemChange(item, isChecked!)))
              .toList(),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: (){
            setState(() {
              selectedGroup.clear();
            });
          },
          child: const Text("Clear"),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text("Done"),
        ),
      ],
    );
  }
}
