import 'package:flutter/material.dart';

void main() => runApp(TaskManagerApp());

class TaskManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager with CircularProgressIndicator',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: TaskManagerScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Task {
  String title;
  double progress; // 0.0 to 1.0

  Task({required this.title, this.progress = 0.0});
}

class TaskManagerScreen extends StatefulWidget {
  @override
  _TaskManagerScreenState createState() => _TaskManagerScreenState();
}

class _TaskManagerScreenState extends State<TaskManagerScreen> {
  final List<Task> _tasks = [];
  final TextEditingController _controller = TextEditingController();

  void _addTask(String title) {
    setState(() {
      _tasks.add(Task(title: title));
      _controller.clear();
    });
  }

  void _updateProgress(int index) {
    setState(() {
      if (_tasks[index].progress < 1.0) {
        _tasks[index].progress += 0.1;
        if (_tasks[index].progress > 1.0) {
          _tasks[index].progress = 1.0;
        }
      }
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  Widget _buildTaskCard(Task task, int index) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      elevation: 3,
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text(task.title, style: TextStyle(fontSize: 18)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 60,
                  width: 60,
                  child: CircularProgressIndicator(
                    value: task.progress,
                    strokeWidth: 6,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ),
                Text("${(task.progress * 100).toInt()}%"),
              ],
            ),
          ],
        ),
        onTap: () => _updateProgress(index),
        onLongPress: () => _confirmDelete(index),
      ),
    );
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete Task'),
        content: Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _deleteTask(index);
              Navigator.pop(context);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Task Manager')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Enter task',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (_controller.text.trim().isNotEmpty) {
                      _addTask(_controller.text.trim());
                    }
                  },
                  child: Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: _tasks.isEmpty
                ? Center(child: Text('No tasks yet. Add one!'))
                : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) =>
                  _buildTaskCard(_tasks[index], index),
            ),
          ),
        ],
      ),
    );
  }
}
