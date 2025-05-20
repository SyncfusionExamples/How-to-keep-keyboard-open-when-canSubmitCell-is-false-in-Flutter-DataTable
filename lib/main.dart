import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:collection/collection.dart';

void main() {
  runApp(const MyApp());
}

/// The application that contains datagrid on it.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Syncfusion DataGrid Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

/// The home page of the application which hosts the datagrid.
class MyHomePage extends StatefulWidget {
  /// Creates the home page.
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late EmployeeDataSource employeeDataSource;
  List<Employee> employees = <Employee>[];

  @override
  void initState() {
    super.initState();
    employees = getEmployeeData();
    employeeDataSource = EmployeeDataSource(
      employees: employees,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Syncfusion Flutter DataGrid')),
      body: SfDataGrid(
        source: employeeDataSource,
        allowEditing: true,
        selectionMode: SelectionMode.single,
        navigationMode: GridNavigationMode.cell,
        gridLinesVisibility: GridLinesVisibility.both,
        headerGridLinesVisibility: GridLinesVisibility.both,
        columns: <GridColumn>[
          GridColumn(
            columnName: 'ID',
            label: Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.center,
              child: const Text('ID'),
            ),
          ),
          GridColumn(
            columnName: 'Name',
            label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text('Name'),
            ),
          ),
          GridColumn(
            allowFiltering: false,
            columnName: 'Designation',
            label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text('Designation', overflow: TextOverflow.ellipsis),
            ),
          ),
          GridColumn(
            columnName: 'Salary',
            label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text('Salary'),
            ),
          ),
          GridColumn(
            columnName: 'Country',
            label: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: const Text('Country'),
            ),
          ),
        ],
      ),
    );
  }

  // Modify your getEmployeeData function
  List<Employee> getEmployeeData() {
    return [
      Employee(1, 'James', 'Manager', 20000, 'United States'),
      Employee(2, 'Abinesh', 'Developer', 20000, 'Canada'),
      Employee(3, 'Manoj', 'Project Lead', 20000, 'UK'),
      Employee(4, 'Max', 'Operations Director', 30000, 'Australia'),
      Employee(5, 'Leo', 'Marketing Manager', 30000, 'Germany'),
      Employee(6, 'Finn', 'Manager', 30000, 'Canada'),
      Employee(7, 'Sophia', 'Developer', 22000, 'France'),
      Employee(8, 'Liam', 'Developer', 21000, 'United States'),
      Employee(9, 'Olivia', 'Project Lead', 25000, 'UK'),
      Employee(10, 'Noah', 'Designer', 18000, 'Australia'),
      Employee(11, 'Emma', 'Developer', 20000, 'Germany'),
      Employee(12, 'Mason', 'Manager', 32000, 'Canada'),
      Employee(13, 'Isabella', 'HR', 19000, 'United States'),
      Employee(14, 'Ethan', 'Developer', 20000, 'UK'),
      Employee(15, 'Mia', 'Marketing Manager', 28000, 'Australia'),
      Employee(16, 'Jacob', 'Operations Director', 33000, 'Germany'),
      Employee(17, 'Ava', 'Developer', 21000, 'Canada'),
      Employee(18, 'William', 'Manager', 31000, 'United States'),
      Employee(19, 'Emily', 'Designer', 17000, 'UK'),
      Employee(20, 'Michael', 'Project Lead', 26000, 'Australia'),
    ];
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the employee which will be rendered in datagrid.
class Employee {
  /// Creates the employee class with required details.
  Employee(this.id, this.name, this.designation, this.salary, this.country);

  /// Id of an employee.
  int id;

  /// Name of an employee.
  String name;

  /// Designation of an employee.
  String designation;

  /// Salary of an employee.
  int salary;

  String country;
}

/// An object to set the employee collection data source to the datagrid. This
/// is used to map the employee data to the datagrid widget.
class EmployeeDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  EmployeeDataSource({required this.employees, required this.context}) {
    buildDataGridSource(employees);
  }

  void buildDataGridSource(List<Employee> employees) {
    _employeeData =
        employees
            .map<DataGridRow>(
              (e) => DataGridRow(
                cells: [
                  DataGridCell<int>(columnName: 'ID', value: e.id),
                  DataGridCell<String>(columnName: 'Name', value: e.name),
                  DataGridCell<String>(
                    columnName: 'Designation',
                    value: e.designation,
                  ),
                  DataGridCell<int>(columnName: 'Salary', value: e.salary),
                  DataGridCell<String>(columnName: 'Country', value: e.country),
                ],
              ),
            )
            .toList();
  }

  List<DataGridRow> _employeeData = [];
  BuildContext context;
  List<Employee> employees = [];

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells:
          row.getCells().map<Widget>((e) {
            return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8.0),
              child: Text(e.value.toString()),
            );
          }).toList(),
    );
  }

  dynamic newCellValue;
  TextEditingController editingController = TextEditingController();

  @override
  Future<void> onCellSubmit(
    DataGridRow dataGridRow,
    RowColumnIndex rowColumnIndex,
    GridColumn column,
  ) async {
    final dynamic oldValue =
        dataGridRow
            .getCells()
            .firstWhereOrNull(
              (DataGridCell dataGridCell) =>
                  dataGridCell.columnName == column.columnName,
            )
            ?.value ??
        '';

    final int dataRowIndex = _employeeData.indexOf(dataGridRow);

    if (newCellValue == null || oldValue == newCellValue) {
      return;
    }
    if (column.columnName == 'ID') {
      _employeeData[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<int>(columnName: 'ID', value: newCellValue);
      employees[dataRowIndex].id = newCellValue;
    } else if (column.columnName == 'Name') {
      _employeeData[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'Name', value: newCellValue);
      employees[dataRowIndex].name = newCellValue.toString();
    } else if (column.columnName == 'Designation') {
      _employeeData[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'Designation', value: newCellValue);
      employees[dataRowIndex].designation = newCellValue.toString();
    } else if (column.columnName == 'Salary') {
      _employeeData[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<int>(columnName: 'Salary', value: newCellValue);
      employees[dataRowIndex].salary = newCellValue;
    } else if (column.columnName == 'Country') {
      _employeeData[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'Country', value: newCellValue);
      employees[dataRowIndex].country = newCellValue.toString();
    }
  }

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
                // triggers onCellSubmit and allows keyboard to close.
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
}
