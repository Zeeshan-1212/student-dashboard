
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const Dashboard(),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String name = 'Mohammad Zeeshan';
  String course = 'B.Tech Computer Science';
  String email = 'zeeshnu@gmail.com';
  String image = '';

  List<String> skills = ['Flutter', 'Dart', 'Python', 'Java'];

  List<String> achievements = [
    'Hackathon Winner',
    'Python Certification',
    'Flutter Developer'
  ];

  // Reusable input dialog
  void addItem(String title, Function(String) save) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: title),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() => save(controller.text.trim()));
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    ).then((_) => controller.dispose());
  }

  // Edit profile
  void editProfile() {
    final n = TextEditingController(text: name);
    final c = TextEditingController(text: course);
    final e = TextEditingController(text: email);
    final i = TextEditingController(text: image);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var item in [
                ['Name', n],
                ['Course', c],
                ['Email', e],
                ['Image URL', i],
              ])
                TextField(
                  controller: item[1] as TextEditingController,
                  decoration: InputDecoration(labelText: item[0] as String),
                ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                name = n.text;
                course = c.text;
                email = e.text;
                image = i.text;
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    ).then((_) {
      n.dispose();
      c.dispose();
      e.dispose();
      i.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Profile Dashboard'),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Profile Card
            Card(
              color: Colors.deepPurple,
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundImage: image.isNotEmpty
                            ? NetworkImage(image)
                            : null,
                        child: image.isEmpty
                            ? const Icon(Icons.person, size: 50)
                            : null,
                      ),
                      const SizedBox(height: 10),
                      Text(name,
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )),
                      Text(course,
                          style: const TextStyle(color: Colors.white)),
                      TextButton(
                        onPressed: editProfile,
                        child: const Text('Edit Profile',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Dashboard Statistics
            const SizedBox(height: 20),
            const Text('Dashboard Overview',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

            Row(
              children: [
                Expanded(
                  child: statCard('Skills', skills.length, Icons.code),
                ),
                Expanded(
                  child: statCard(
                      'Achievements', achievements.length, Icons.emoji_events),
                ),
              ],
            ),

            // Student Details
            const SizedBox(height: 20),
            const Text('Student Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

            detailCard(Icons.person, 'Name', name),
            detailCard(Icons.school, 'Course', course),
            detailCard(Icons.email, 'Email', email),

            // Skills
            const SizedBox(height: 20),
            sectionHeader('My Skills', () {
              addItem('Add Skill', (value) => skills.add(value));
            }),

            Wrap(
              spacing: 8,
              children: skills.map((skill) {
                return InputChip(
                  label: Text(skill),
                  onDeleted: () {
                    setState(() => skills.remove(skill));
                  },
                );
              }).toList(),
            ),

            // Achievements
            const SizedBox(height: 20),
            sectionHeader('Achievements', () {
              addItem('Add Achievement',
                  (value) => achievements.add(value));
            }),

            ...achievements.map((item) {
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.emoji_events,
                      color: Colors.deepPurple),
                  title: Text(item),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() => achievements.remove(item));
                    },
                  ),
                ),
              );
            }),

            const SizedBox(height: 20),
            const Center(child: Text('© 2026 Student Dashboard')),
          ],
        ),
      ),
    );
  }

  // Statistics Widget
  Widget statCard(String title, int count, IconData icon) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text('$count',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        subtitle: Text(title),
      ),
    );
  }

  // Student Details Widget
  Widget detailCard(IconData icon, String title, String value) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }

  // Section Heading Widget
  Widget sectionHeader(String title, VoidCallback onAdd) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        IconButton(
          onPressed: onAdd,
          icon: const Icon(Icons.add_circle, color: Colors.deepPurple),
        ),
      ],
    );
  }
}
