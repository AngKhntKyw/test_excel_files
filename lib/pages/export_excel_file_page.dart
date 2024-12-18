import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

List<Map<String, dynamic>> myMapList = [
  {
    'name': 'John',
    'age': 30,
    'email': 'john@example.com',
    'date': DateTime.now(),
  },
  {
    'name': 'Aung Khant Kyaw',
    'age': 26,
    'email': 'aung@example.com',
    'date': DateTime.now(),
  },
  {
    'name': 'Htet Oakkar',
    'age': 58,
    'email': 'oak@example.com',
    'date': DateTime.now(),
  }
];

class ExportExcelFilePage extends StatefulWidget {
  const ExportExcelFilePage({super.key});

  @override
  State<ExportExcelFilePage> createState() => _ExportExcelFilePageState();
}

class _ExportExcelFilePageState extends State<ExportExcelFilePage> {
  Future<void> generateExcelFromJson() async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];

    // Step 3: Set headers in the Excel file (First row)
    if (myMapList.isNotEmpty) {
      Map<String, dynamic> firstItem = myMapList[0];
      List<String> headers = firstItem.keys.toList();

      for (int i = 0; i < headers.length; i++) {
        sheet.getRangeByIndex(1, i + 1).setText(headers[i]);
        sheet.getRangeByIndex(1, i + 1).cellStyle.bold = true;
        sheet.setColumnWidthInPixels(
            i + 1, (MediaQuery.sizeOf(context).width / 3).toInt());
      }

      // Step 4: Add data from JSON to the Excel sheet
      for (int rowIndex = 0; rowIndex < myMapList.length; rowIndex++) {
        Map<String, dynamic> item = myMapList[rowIndex];

        for (int colIndex = 0; colIndex < headers.length; colIndex++) {
          String key = headers[colIndex];
          dynamic value = item[key];

          switch (value.runtimeType) {
            case const (String):
              sheet.getRangeByIndex(rowIndex + 2, colIndex + 1).setText(value);
              break;
            case const (int):
              sheet
                  .getRangeByIndex(rowIndex + 2, colIndex + 1)
                  .setNumber(value.toDouble());
              break;
            case const (double):
              sheet
                  .getRangeByIndex(rowIndex + 2, colIndex + 1)
                  .setNumber(value);
              break;
            case const (bool):
              sheet
                  .getRangeByIndex(rowIndex + 2, colIndex + 1)
                  .setText(value.toString());
              break;
            case const (DateTime):
              sheet
                  .getRangeByIndex(rowIndex + 2, colIndex + 1)
                  .setDateTime(value);
              break;
            default:
              sheet
                  .getRangeByIndex(rowIndex + 2, colIndex + 1)
                  .setText(value?.toString() ?? '');
              break;
          }
        }
      }
    }

    // Step 5: Save the Excel file as a byte array
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    // Step 6: Get the application directory and create file path
    final directory = await getExternalStorageDirectory();
    final String filePath = "${directory!.path}/GeneratedData.xlsx";
    final File file = File(filePath);

    // Step 7: Write bytes to the file
    await file.writeAsBytes(bytes, flush: true);

    // Step 8: Open the generated Excel file
    await OpenFile.open(filePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Export"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: OutlinedButton(
            onPressed: generateExcelFromJson,
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(20),
                fixedSize: Size.fromWidth(MediaQuery.sizeOf(context).width),
                foregroundColor: Colors.green,
                side: const BorderSide(color: Colors.green),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: const Text("Export"),
          ),
        ),
      ),
    );
  }
}
