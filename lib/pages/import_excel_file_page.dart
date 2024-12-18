import 'dart:developer';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ImportExcelFilePage extends StatefulWidget {
  const ImportExcelFilePage({super.key});

  @override
  State<ImportExcelFilePage> createState() => _ImportExcelFilePageState();
}

class _ImportExcelFilePageState extends State<ImportExcelFilePage> {
  List<Map<String, dynamic>> tableData = [];

  // Function to pick an Excel file
  Future<void> pickExcelFile() async {
    // Pick an Excel file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result != null) {
      final path = result.files.single.path!;
      final file = File(path);

      // Read the Excel file
      await convertExcelToJson(file.path);
    }
  }

  Future<void> convertExcelToJson(String filePath) async {
    try {
      final bytes = await File(filePath).readAsBytes();
      final excel = Excel.decodeBytes(bytes);

      List<Map<String, dynamic>> data = [];

      for (var table in excel.tables.keys) {
        final sheet = excel[table];
        final headers =
            sheet.rows.first.map((cell) => cell!.value.toString()).toList();
        for (var row in sheet.rows.skip(1)) {
          Map<String, dynamic> rowData = {};
          for (int i = 0; i < headers.length; i++) {
            rowData[headers[i]] = row[i]?.value.toString() ?? '';
          }
          data.add(rowData);
        }
      }

      setState(() {
        tableData = data;
        log(tableData.toString());
      });
    } catch (e) {
      log('Error converting Excel to JSON: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> columns =
        tableData.isNotEmpty ? tableData[0].keys.toList() : [];

    // Convert JSON data to DataTable rows
    List<DataRow> rows = tableData.map((data) {
      return DataRow(
        cells: columns.map((column) {
          return DataCell(Text(data[column].toString()));
        }).toList(),
      );
    }).toList();

    //
    return Scaffold(
      appBar: AppBar(
        title: const Text("Import"),
      ),
      body: tableData.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: pickExcelFile,
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(20),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      fixedSize:
                          Size.fromWidth(MediaQuery.sizeOf(context).width),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: const Text('Import Excel'),
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  columns: columns
                      .map((column) => DataColumn(label: Text(column)))
                      .toList(),
                  rows: rows,
                ),
              ),
            ),
    );
  }
}
