import 'package:flutter/material.dart';
import 'package:test_excel/pages/export_excel_file_page.dart';
import 'package:test_excel/pages/import_excel_file_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Import and Export Excel files",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: MediaQuery.sizeOf(context).height / 20),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    allowSnapshotting: true,
                    barrierDismissible: true,
                    fullscreenDialog: true,
                    maintainState: true,
                    builder: (context) => const ExportExcelFilePage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(20),
                  fixedSize: Size.fromWidth(MediaQuery.sizeOf(context).width),
                  foregroundColor: Colors.green,
                  side: const BorderSide(color: Colors.green),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: const Text("Export"),
            ),
            SizedBox(height: MediaQuery.sizeOf(context).height / 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    allowSnapshotting: true,
                    barrierDismissible: true,
                    fullscreenDialog: true,
                    maintainState: true,
                    builder: (context) => const ImportExcelFilePage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(20),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  fixedSize: Size.fromWidth(MediaQuery.sizeOf(context).width),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: const Text("Import"),
            ),
          ],
        ),
      ),
    );
  }
}
