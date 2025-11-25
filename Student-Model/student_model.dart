class StudentModel {
  final int id;
  final String name;
  final int age;
  final String grade;

  const StudentModel({
    required this.id,
    required this.name,
    required this.age,
    required this.grade,
  });

  StudentModel copyWith({
    int? newID,
    String? newName,
    int? newAge,
    String? newGrade,
  }) {
    return StudentModel(
      id: newID ?? id,
      name: newName ?? name,
      age: newAge ?? age,
      grade: newGrade ?? grade,
    );
  }// Creates a new StudentModel object by copying the current one

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      grade: map['grade'],
    );
  }
  //factory : in only constructor , named constructor
  StudentModel.fromMap2(Map<String, dynamic> map)
    : this(
        id: map['id'],
        name: map['name'],
        age: map['age'],
        grade: map['grade'],
      );
      //recursive constructor

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'age': age, 'grade': grade};
  }
}

class StudentManager {
  final List<StudentModel> _students = [];

  // Create
  void addStudent(StudentModel student) {
    _students.add(student);
    print('Student added: ${student.name}');
  }

  // Read
  List<StudentModel> getAllStudents() {
    return _students;
  }

  List<String> getAllStudentsName() {
    return _students.map((student) => student.name).toList();
  }

  // Update
  void updateStudent(int id, StudentModel updatedStudent) {
    final index = _students.indexWhere((student) => student.id == id);
    if (index != -1) {
      _students[index] = updatedStudent;
      print('Student updated: ${updatedStudent.name}');
    } else {
      print('Student not found!');
    }
  }

  // Delete
  void deleteStudent(int id) {
    _students.removeWhere((student) => student.id == id);
    print('Student deleted with ID: $id');
  }
}

void main() {
  final StudentManager manager = StudentManager();

  final student1 = StudentModel(id: 1, name: 'Ahmed', age: 20, grade: 'A');
  manager.addStudent(student1);

  final student2 = StudentModel(id: 2, name: 'Sara', age: 22, grade: 'B');
  manager.addStudent(student2);

  final student3 = StudentModel(id: 3, name: 'Ali', age: 21, grade: 'A-');
  manager.addStudent(student3);

  print(manager.getAllStudentsName());

  final updatedStudent = student1.copyWith(newName: "ahmed ali");
  manager.updateStudent(1, updatedStudent);

  manager.deleteStudent(2);
}
