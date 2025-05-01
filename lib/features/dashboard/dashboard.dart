import 'package:flutter/material.dart';

class Dashboard_Screen extends StatelessWidget {
  const Dashboard_Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF212332),
      appBar: AppBar(
        title: Text(
          "File Manager",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Drawer Header',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "My Files",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  // ElevatedButton.icon(
                  //   icon: Icon(Icons.add),
                  //   label: Text("Add New"),
                  //   onPressed: () {},
                  // ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  InkWell(
                    onTap: () {},
                    child: FileCard(
                        title: "Documents",
                        fileCount: 1328,
                        size: "1.9GB",
                        icon: Icons.folder),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.3),
                  InkWell(
                    onTap: () {},
                    child: FileCard(
                        title: "One Drive",
                        fileCount: 1328,
                        size: "1GB",
                        icon: Icons.cloud_circle),
                  ),
                ],
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {},
                    child: FileCard(
                        title: "Google Drive",
                        fileCount: 1328,
                        size: "2.9GB",
                        icon: Icons.cloud),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.28),
                  InkWell(
                    onTap: () {},
                    child: FileCard(
                        title: "One Drive",
                        fileCount: 1328,
                        size: "1GB",
                        icon: Icons.cloud_circle),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text("Recent Files",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              InkWell(
                  child: FileTile(
                      name: "XD File", date: "01-03-2021", size: "3.5MB")),
              FileTile(name: "Figma File", date: "27-02-2021", size: "19.0MB"),
              FileTile(name: "Documents", date: "23-02-2021", size: "32.5MB"),
              FileTile(name: "Sound File", date: "20-02-2021", size: "3.5MB"),
            ],
          ),
        ),
      ),
    );
  }
}

class FileCard extends StatelessWidget {
  final String title;
  final int fileCount;
  final String size;
  final IconData icon;

  FileCard(
      {required this.title,
      required this.fileCount,
      required this.size,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFF2A2D3E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            // Spacer(),
            Text("$fileCount Files"),
            Text(size, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class FileTile extends StatelessWidget {
  final String name;
  final String date;
  final String size;

  FileTile({required this.name, required this.date, required this.size});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.insert_drive_file, color: Colors.orange),
      title: Text(name),
      subtitle: Text(date),
      trailing: Text(size),
    );
  }
}
