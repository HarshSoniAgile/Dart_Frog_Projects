// ignore_for_file: strict_raw_type, leading_newlines_in_multiline_strings, inference_failure_on_untyped_parameter, inference_failure_on_collection_literal

import 'package:school_management/common/app_logger.dart';
import 'package:school_management/database/mysql_client.dart';
import 'package:school_management/model/school_model.dart';
import 'package:school_management/model/student_model.dart';

class DataSource {
  const DataSource(
    this.sqlClient,
  );

  final MySQLClient sqlClient;

  /// ************************* LogIn *************************
  Future<SchoolModel?> logIn(String? email) async {
    try {
      var sqlQuery = 'SELECT * FROM school WHERE email = "$email";';
      final result = await sqlClient.execute(sqlQuery);

      var data = result.rows.isNotEmpty ? SchoolModel.fromJson(result.rows.first.assoc()) : null;

      return data;
    } catch (e) {
      Logger().e(e);
      return null;
    }
  }

  Future<bool> checkEmail(String email) async {
    var checkEmail = 'SELECT COUNT(*) AS Row_Count FROM school WHERE email = "${email}";';

    final checkEmailResult = await sqlClient.execute(checkEmail);

    Logger().e(checkEmailResult.rows.first.assoc()['Row_Count']);

    if (checkEmailResult.rows.first.assoc()['Row_Count'] != null) {
      return true;
    } else {
      return false;
    }
  }

  /// ******************************** create school *****************************
  Future<SchoolModel?> addSchool(SchoolModel schoolModel) async {
    try {
      var sqlQuery = '''
      INSERT INTO school (name, email, address, photo, zipcode, city, state, contry, password) 
        VALUES 
        ("${schoolModel.name}",
        "${schoolModel.email}",
        "${schoolModel.address}",
        "${schoolModel.photo}",
        ${schoolModel.zipcode},
        "${schoolModel.city}",
        "${schoolModel.state}",
        "${schoolModel.contry}",
        "${schoolModel.password}");
        ''';

      await sqlClient.execute(sqlQuery, iterable: true);

      var sqlQueryGetLastData = 'SELECT * FROM school ORDER BY Id DESC LIMIT 1;';

      final result1 = await sqlClient.execute(sqlQueryGetLastData);

      print(result1.rows.first.assoc());

      var data = result1.rows.isNotEmpty ? SchoolModel.fromJson(result1.rows.first.assoc()) : null;

      return data;
    } catch (e) {
      print('****** error ::::: $e');
    }
    return null;
  }

  /// ******************************** create Or Update Student *****************************
  Future<StudentModel?> addStudent(StudentModel studentModel) async {
    try {
      String sqlQuery;
      if (studentModel.id != null) {
        sqlQuery = '''UPDATE student SET
        name = "${studentModel.name}",
        parent_number = "${studentModel.parentNumber}",
        address = "${studentModel.address}",
        photo = "${studentModel.photo}",
        std = ${studentModel.std},
        school_id = ${studentModel.schoolID},
        dob = "${studentModel.dob}"
        WHERE id = ${studentModel.id}
       ;''';
      } else {
        sqlQuery = '''
      INSERT INTO student (name, parent_number, address, photo, std, school_id, dob) 
        VALUES 
        ("${studentModel.name}",
        "${studentModel.parentNumber}",
        "${studentModel.address}",
        "${studentModel.photo}",
        ${studentModel.std},
        "${studentModel.schoolID}",
        "${studentModel.dob}");
        ''';
      }

      await sqlClient.execute(sqlQuery, iterable: true);

      var sqlQueryGetLastData = 'SELECT * FROM student ORDER BY Id DESC LIMIT 1;';

      final result1 = await sqlClient.execute(sqlQueryGetLastData);

      var data = result1.rows.isNotEmpty ? StudentModel.fromJson(result1.rows.first.assoc()) : null;

      return data;
    } catch (e) {
      print('****** error ::::: $e');
    }
    return null;
  }

  /// ******************************** get school ********************************
  Future getSchool(id) async {
    try {
      var sqlQuery = 'SELECT * FROM school WHERE id = $id;';

      final result = await sqlClient.execute(sqlQuery);

      var school = result.rows.isNotEmpty ? SchoolModel.fromJson(result.rows.first.assoc()) : null;

      return school;
    } catch (e) {}
  }

  /// ******************************** edit school *******************************
  Future editSchool(SchoolModel schoolModel) async {
    try {
      var sqlQuery = '''UPDATE school SET
        name = "${schoolModel.name}",
        email = "${schoolModel.email}",
        address = "${schoolModel.address}",
        photo = "${schoolModel.photo}",
        zipcode = ${schoolModel.zipcode},
        city = "${schoolModel.city}",
        state = "${schoolModel.state}",
        contry = "${schoolModel.contry}"
        WHERE id = ${schoolModel.id}
       ;''';

      final result = await sqlClient.execute(sqlQuery);

      print(result);
      return true;
    } catch (e) {
      print("****** error ::::: $e");
      return e;
    }
  }

  /// ******************************** get All School List  **********************
  Future<Map<String, dynamic>?> getAllSchool(int? page, int? limit) async {
    try {
      var totalRecordQuery = 'SELECT COUNT(*) AS Row_Count FROM school;';
      var totalRecordResult = await sqlClient.execute(totalRecordQuery);

      var totalRecord = totalRecordResult.rows.first.assoc();

      var sqlQuery = 'SELECT * FROM school LIMIT ${((page ?? 1) - 1) * 10}, ${limit ?? 10};';

      final result = await sqlClient.execute(sqlQuery);

      final schoolList = <SchoolModel>[];

      for (var school in result.rows) {
        schoolList.add(SchoolModel.fromJson(school.assoc()));
      }

      return {'total_count': totalRecord['Row_Count'], 'page': page, 'data': schoolList};
    } catch (e) {
      Logger().e(e);
      return null;
    }
  }

  /// ******************************** get All student List  **********************
  Future<Map<String, dynamic>?> getAllStudent(int? page, int? limit, int? schoolId) async {
    try {
      var totalRecordQuery = 'SELECT COUNT(*) AS Row_Count FROM student WHERE school_id = $schoolId;';
      var totalRecordResult = await sqlClient.execute(totalRecordQuery);

      var totalRecord = totalRecordResult.rows.first.assoc();

      var sqlQuery = 'SELECT * FROM student WHERE school_id = $schoolId LIMIT ${((page ?? 1) - 1) * 10}, ${limit ?? 10} ;';

      final result = await sqlClient.execute(sqlQuery);

      final studentList = <StudentModel>[];

      for (var student in result.rows) {
        studentList.add(StudentModel.fromJson(student.assoc()));
      }

      return {'total_count': totalRecord['Row_Count'], 'page': page, 'data': studentList};
    } catch (e) {
      Logger().e(e);
      return null;
    }
  }

  Future dashboardCounts() async {
    var totalStudentQuery = 'SELECT COUNT(*) AS Row_Count FROM student;';
    var totalStudentQueryResult = await sqlClient.execute(totalStudentQuery);
    Logger().i("total student : ${totalStudentQueryResult.rows.first.assoc()['Row_Count']}");
    var totalStudent = totalStudentQueryResult.rows.first.assoc()['Row_Count'];

    var totalStudentBySTDQuery = '''SELECT  std, COUNT(*) Row_Count FROM student GROUP BY std ORDER BY Row_Count desc''';
    var totalStudentBySTDQueryResult = await sqlClient.execute(totalStudentBySTDQuery);
    var stdWiseStudent = [];
    for (var i in totalStudentBySTDQueryResult.rows) {
      Logger().i("std wise student : ${i.assoc()['std']} --  ${i.assoc()['Row_Count']}");
      stdWiseStudent.add({'std': i.assoc()['std'], 'student': i.assoc()['Row_Count']});
    }

    var totalStudentBySchoolQuery = '''SELECT 
        school.id, school.name, COUNT(*) Row_Count
    FROM 
       student
    INNER JOIN 
       school 
    ON
       student.school_id=school.id
	GROUP BY school.id ORDER BY Row_Count desc;
       ''';
    var totalStudentBySchoolQueryResult = await sqlClient.execute(totalStudentBySchoolQuery);
    var schoolWiseStudent = [];

    for (var i in totalStudentBySchoolQueryResult.rows) {
      Logger().i("school wise student : ${i.assoc()['name']} -- ${i.assoc()['Row_Count']}");
      schoolWiseStudent.add({'school': i.assoc()['name'], 'student': i.assoc()['Row_Count']});
    }

    return {'total_student': totalStudent, 'std_wise_student': stdWiseStudent, 'school_wise_student': schoolWiseStudent};
  }

  /// ******************************** get student ********************************
  Future getStudent(id) async {
    try {
      var sqlQuery = 'SELECT * FROM student WHERE id = $id;';

      final result = await sqlClient.execute(sqlQuery);

      var student = result.rows.isNotEmpty ? StudentModel.fromJson(result.rows.first.assoc()) : null;

      return student;
    } catch (e) {}
  }

  /// ******************************** delete student ********************************
  Future deleteStudent(id) async {
    try {
      var sqlQuery = 'DELETE FROM student WHERE id = $id;';

      await sqlClient.execute(sqlQuery);

      return true;
    } catch (e) {
      Logger().e(e);
      return e;
    }
  }
}
