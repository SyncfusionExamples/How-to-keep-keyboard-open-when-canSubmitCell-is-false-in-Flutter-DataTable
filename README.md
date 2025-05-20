# How to keep keyboard open when canSubmitCell is false in Flutter DataTable (SfDataGrid)?

In this article, we’ll demonstrate how to keep the keyboard open when canSubmitCell returns false in a [Flutter DataTable](https://www.syncfusion.com/flutter-widgets/flutter-datagrid).

First, initialize the [SfDataGrid](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/SfDataGrid-class.html) widget with the necessary properties. In the TextField’s onSubmitted callback, which is triggered when the user presses Done or Enter on the keyboard, call your asynchronous [canSubmitCell](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/DataGridSource/canSubmitCell.html) method to determine whether editing should end. If it returns false, request focus back to the TextField. This ensures that the keyboard remains visible when editing is not allowed to conclude.

```dart
  @override
  Widget? buildEditWidget(
    DataGridRow dataGridRow,
    RowColumnIndex rowColumnIndex,
    GridColumn column,
    CellSubmit submitCell,
  ) {
    final String displayText =
        dataGridRow
            .getCells()
            .firstWhereOrNull(
              (dataCell) => dataCell.columnName == column.columnName,
            )
            ?.value
            ?.toString() ??
        '';

    final bool isNumericType =
        column.columnName == 'ID' || column.columnName == 'Salary';

    newCellValue = null;
    editingController.text = displayText;
    final focusNode = FocusNode();

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          padding: const EdgeInsets.all(8.0),
          alignment:
              isNumericType ? Alignment.centerRight : Alignment.centerLeft,
          child: TextField(
            autofocus: true,
            controller: editingController,
            focusNode: focusNode,
            textAlign: isNumericType ? TextAlign.right : TextAlign.left,
            keyboardType:
                isNumericType ? TextInputType.number : TextInputType.text,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 8.0),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                newCellValue = isNumericType ? int.tryParse(value) : value;
              } else {
                newCellValue = null;
              }
            },
            onSubmitted: (value) async {
              // Ask if cell can be submitted
              bool canSubmit = await canSubmitCell(
                dataGridRow,
                rowColumnIndex,
                column,
              );
              if (canSubmit) {
                // Triggers onCellSubmit and allows keyboard to close.
                submitCell();
              } else {
                // Keep focus, prevent keyboard from hiding.
                focusNode.requestFocus();
              }
            },
          ),
        );
      },
    );
  }

  @override
  Future<bool> canSubmitCell(
    DataGridRow dataGridRow,
    RowColumnIndex rowColumnIndex,
    GridColumn column,
  ) async {
    if (column.columnName == 'ID' && newCellValue == null) {
      return false;
    } else {
      return true;
    }
  }
```

You can download this example on [GitHub](https://github.com/SyncfusionExamples/How-to-keep-keyboard-open-when-canSubmitCell-is-false-in-Flutter-DataTable).