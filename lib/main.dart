import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(AgendaKamilaGarciaFraga());
}

class AgendaKamilaGarciaFraga extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda Kamila Garcia Fraga',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.pink[50],
        primaryColor: Colors.pinkAccent,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.grey),
        ),
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pinkAccent,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.favorite, color: Colors.black, size: 80),
              const SizedBox(height: 20),
              Text(
                'Bem-vinda, Kamila Garcia 💖 RA: 1180294',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    TextField(
                      controller: _senhaController,
                      decoration: const InputDecoration(labelText: 'Senha'),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        minimumSize: const Size(double.infinity, 45),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CalendarPage()),
                        );
                      },
                      child: Text(
                        _isLogin ? 'Entrar' : 'Cadastrar',
                        style: TextStyle(color: Colors.pinkAccent),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(
                        _isLogin
                            ? 'Não tem conta? Cadastre-se'
                            : 'Já tem conta? Faça login',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CalendarPage extends StatefulWidget {
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pinkAccent,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Calendário de Tarefas',
          style: TextStyle(color: Colors.pinkAccent),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Bem-vinda, Kamila Garcia 💗 RA:1180294',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          CalendarDatePicker(
            initialDate: _selectedDate,
            firstDate: DateTime(2023),
            lastDate: DateTime(2030),
            onDateChanged: (date) {
              setState(() {
                _selectedDate = date;
              });
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskListPage(selectedDate: _selectedDate),
                ),
              );
            },
            child: const Text(
              'Selecionar o dia',
              style: TextStyle(color: Colors.pinkAccent),
            ),
          ),
        ],
      ),
    );
  }
}

class TaskListPage extends StatefulWidget {
  final DateTime selectedDate;
  const TaskListPage({required this.selectedDate});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final List<Map<String, dynamic>> _tasks = [];

  void _addTask(String taskName) {
    setState(() {
      _tasks.add({'name': taskName, 'done': false});
      _sortTasks();
    });
  }

  void _sortTasks() {
    _tasks.sort((a, b) {
      if (a['done'] && !b['done']) return 1;
      if (!a['done'] && b['done']) return -1;
      return a['name'].toString().toLowerCase().compareTo(b['name'].toString().toLowerCase());
    });
  }

  void _toggleTask(int index) {
    setState(() {
      _tasks[index]['done'] = !_tasks[index]['done'];
      _sortTasks();
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _showAddTaskDialog() {
    final TextEditingController _controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.pink[50],
        title: const Text('Adicionar Tarefa'),
        content: TextField(
          controller: _controller,
          decoration: const InputDecoration(hintText: 'Digite o nome da tarefa'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                _addTask(_controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Adicionar', style: TextStyle(color: Colors.pinkAccent)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String dateFormatted = DateFormat('dd/MM/yyyy').format(widget.selectedDate);
    return Scaffold(
      backgroundColor: Colors.pinkAccent,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Dia $dateFormatted',
          style: const TextStyle(color: Colors.pinkAccent),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add, color: Colors.pinkAccent),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _tasks.isEmpty
            ? const Center(
                child: Text(
                  'Nenhuma tarefa adicionada ainda.',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              )
            : ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  final task = _tasks[index];
                  return Card(
                    color: task['done'] ? Colors.pink[100] : Colors.white,
                    child: ListTile(
                      title: Text(
                        task['name'],
                        style: TextStyle(
                          color: Colors.grey[800],
                          decoration: task['done']
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      leading: Checkbox(
                        value: task['done'],
                        activeColor: Colors.black,
                        onChanged: (_) => _toggleTask(index),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.black),
                        onPressed: () => _deleteTask(index),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
