import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../core/services/cache_helper.dart';
import '../../../core/utils/app_images.dart';
import '../../../core/utils/const_data.dart';
import '../../../models/activity_join_model.dart';
import '../../../models/attend_model.dart';
import '../../../models/children_model.dart';
import '../../../models/class_join_Model.dart';
import '../../../models/class_model.dart';
import '../../../models/message_model.dart';
import '../../../models/parent_model.dart';
import '../../../models/report_model.dart';
import '../../../models/school_activities_model.dart';
import '../../../models/school_join_model.dart';
import '../../../models/school_model.dart';
import '../../../models/stop_tracking_child_model.dart';
import '../../../models/supervisors_model.dart';
import '../../../models/teacher_model.dart';
import '../../../modules/schools/home/shcools_home_screens.dart';
import '../../../modules/schools/setting/super_setting_screen.dart';

part 'schools_state.dart';

class SchoolsCubit extends Cubit<SchoolsState> {
  SchoolsCubit() : super(SchoolsInitial());
  static SchoolsCubit get(context) => BlocProvider.of(context);
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  List<Widget> screens = [
    SchoolsHomeScreen(),
    SupervisorSettingsScreen(),
  ];
  List<String> titles = [
    'Home',
    'Settings',
  ];
  void changeBottomNavBar(int index) {
    _currentIndex = index;
    emit(SchoolsChangeBottomNavBarState());
  }

  void getCurrentSupervisor() async {
    await FirebaseFirestore.instance.collection('schools').get().then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection('schools')
            .doc(element.id)
            .collection('supervisors')
            .doc(CacheHelper.getData(key: 'uid') == null
                ? ''
                : CacheHelper.getData(key: 'uid'))
            .get()
            .then((value) {
          if (value.exists) {
            SUPERVISOR_MODEL = SupervisorsModel.fromJson(value.data()!);
            emit(SchoolsGetSupervisorSuccessState());
          } else {
            emit(SchoolsGetSupervisorErrorState());
          }
        });
      });
    });
  }

  void getCurrentSchool() async {
    await FirebaseFirestore.instance
        .collection('schools')
        .doc(
          CacheHelper.getData(key: 'schoolId') == null
              ? ''
              : CacheHelper.getData(key: 'schoolId'),
        )
        .get()
        .then((value) {
      if (value.exists) {
        print("School name is: ${value.data()!['name']}");
        SCHOOL_MODEL = SchoolModel.fromJson(value.data()!);
        emit(SchoolsGetSupervisorSuccessState());
      }
    }).catchError((error) {
      print(error.toString());
    });
  }

  void updateSchoolProfile({
    String? name,
    String? description,
    String? address,
    String? phone,
    String? establishmentDate,
    String? establishmentBy,
    String? website,
  }) async {
    emit(SchoolsUpdateProfileLoadingState());
    await FirebaseFirestore.instance
        .collection('schools')
        .doc(SCHOOL_MODEL?.id)
        .update({
      'name': name == null ? SCHOOL_MODEL?.name : name,
      'description':
          description == null ? SCHOOL_MODEL?.description : description,
      'location': address == null ? SCHOOL_MODEL?.location : address,
      'phone': phone == null ? SCHOOL_MODEL?.phone : phone,
      'establishedIn': establishmentDate == null
          ? SCHOOL_MODEL?.establishedIn
          : establishmentDate,
      'establishedBy': establishmentBy == null
          ? SCHOOL_MODEL?.establishedBy
          : establishmentBy,
      'website': website == null ? SCHOOL_MODEL?.website : website,
    }).then((value) {
      getCurrentSchool();
      emit(SchoolsUpdateProfileSuccessState());
    }).catchError((error) {
      emit(SchoolsUpdateProfileErrorState());
    });
  }

  File? uploadImageFile;
  String? profileImageUrl;
  void getImageFromGallery({required String uid}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (image != null) {
      uploadImageFile = File(image.path);
      profileImageUrl = image.path;
      await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/$uid')
          .putFile(uploadImageFile!)
          .then((value) {
        value.ref.getDownloadURL().then((value) {
          profileImageUrl = value;
          uploadImageFile = null;
          FirebaseFirestore.instance
              .collection('schools')
              .doc(SCHOOL_MODEL?.id)
              .update({
            'image': value,
          }).then((value) {
            getCurrentSchool();
            emit(SchoolsUpdateProfileImageSuccessState());
          }).catchError((error) {
            emit(SchoolsUpdateProfileImageErrorState(error.toString()));
          });
        }).catchError((error) {
          emit(SchoolsUpdateProfileImageErrorState(error.toString()));
        });
      });
    } else {
      emit(SchoolsUpdateProfileImageErrorState(
          'No image selected. Please select an image.'));
    }
  }

  void updateSupervisorImage({required String uid}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (image != null) {
      uploadImageFile = File(image.path);
      profileImageUrl = image.path;
      await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/$uid')
          .putFile(uploadImageFile!)
          .then((value) {
        value.ref.getDownloadURL().then((value) {
          profileImageUrl = value;
          uploadImageFile = null;
          FirebaseFirestore.instance
              .collection('schools')
              .doc(SCHOOL_MODEL?.id)
              .collection('supervisors')
              .doc(uid)
              .update({
            'image': value,
          }).then((value) {
            getCurrentSupervisor();
            emit(SchoolsUpdateSupervisorImageSuccessState());
          }).catchError((error) {
            print(error.toString());
            emit(SchoolsUpdateSupervisorImageErrorState(error.toString()));
          });
        }).catchError((error) {
          emit(SchoolsUpdateSupervisorImageErrorState(error.toString()));
        });
      });
    }
  }

  void updateSupervisorProfile({
    String? superName,
    String? superPhone,
    String? superAge,
    String? superGender,
  }) {
    emit(SchoolsUpdateSupervisorProfileLoadingState());
    FirebaseFirestore.instance
        .collection('schools')
        .doc(SCHOOL_MODEL?.id)
        .collection('supervisors')
        .doc(SUPERVISOR_MODEL?.id)
        .update({
      'name': superName == null ? SUPERVISOR_MODEL?.name : superName,
      'phone': superPhone == null ? SUPERVISOR_MODEL?.phone : superPhone,
      'age': superAge == null ? SUPERVISOR_MODEL?.age : superAge,
      'gender': superGender == null ? SUPERVISOR_MODEL?.gender : superGender,
    }).then((value) {
      getCurrentSupervisor();
      emit(SchoolsUpdateSupervisorProfileSuccessState());
    }).catchError((error) {
      emit(SchoolsUpdateSupervisorProfileErrorState(error.toString()));
    });
  }

  void createTeacherAccount({
    required String name,
    required String email,
    required String password,
    required String university,
    required String phone,
    required String address,
    required String age,
    required String gender,
  }) {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      print(value.user!.uid);
      if (value.user?.uid != null) {
        addTeacher(
          teachId: value.user!.uid,
          teachName: name,
          teachEmail: email,
          teachPassword: password,
          teachUniversity: university,
          teachPhone: phone,
          teachAddress: address,
          teachAge: age,
          teachGender: gender,
        );
      }
    }).catchError((error) {
      print(error.toString());
    });
  }

  void addTeacher({
    required String teachId,
    required String teachName,
    required String teachEmail,
    required String teachPassword,
    required String teachUniversity,
    required String teachPhone,
    required String teachAddress,
    required String teachAge,
    required String teachGender,
  }) {
    emit(SchoolsAddTeacherLoadingState());
    TeacherModel teacherModel = TeacherModel(
      id: teachId,
      schoolId: SCHOOL_MODEL!.id,
      name: teachName,
      email: teachEmail,
      password: teachPassword,
      university: teachUniversity,
      subject: '',
      image: AppImages.defaultImage2,
      phone: teachPhone,
      gender: teachGender,
      age: teachAge,
      address: teachAddress,
      ban: 'false',
      createdAt: DateTime.now().toString(),
    );
    FirebaseFirestore.instance
        .collection('schools')
        .doc(SCHOOL_MODEL?.id)
        .collection('teachers')
        .doc(teachId)
        .set(teacherModel.toMap())
        .then((value) {
      emit(SchoolsAddTeacherSuccessState());
    }).catchError((error) {
      emit(SchoolsAddTeacherErrorState(error.toString()));
    });
  }

  void createClass({required String className, required String eduLevel}) {
    emit(SchoolsAddClassLoadingState());
    ClassModel classModel = ClassModel(
      id: SUPERVISOR_MODEL!.id,
      name: className,
      schoolId: SCHOOL_MODEL!.id,
      educationalLevel: eduLevel,
      createdAt: DateTime.now().toString(),
    );
    FirebaseFirestore.instance
        .collection('schools')
        .doc(SCHOOL_MODEL?.id)
        .collection('classes')
        .add(classModel.toMap())
        .then((value) {
      FirebaseFirestore.instance
          .collection('schools')
          .doc(SCHOOL_MODEL?.id)
          .collection('classes')
          .doc(value.id)
          .update({
            'id': value.id,
          })
          .then((value) {})
          .catchError((error) {
            emit(SchoolsAddClassErrorState(error.toString()));
          });
      emit(SchoolsAddClassSuccessState());
    }).catchError((error) {
      emit(SchoolsAddClassErrorState(error.toString()));
    });
  }

  void updateClass(
      {required String className,
      required String eduLevel,
      required String classId}) {
    emit(SchoolsUpdateClassLoadingState());
    FirebaseFirestore.instance
        .collection('schools')
        .doc(SCHOOL_MODEL?.id)
        .collection('classes')
        .doc(classId)
        .update({
      'name': className,
      'educationalLevel': eduLevel,
    }).then((value) {
      print("Seccess Update Class 🎉 ");
      emit(SchoolsUpdateClassSuccessState());
    }).catchError((error) {
      emit(SchoolsUpdateClassErrorState(error.toString()));
    });
  }

  void createActivityInSchool(
      {required String activityName,
      required String activityDescription,
      required String activityDate,
      required String activityPrice,
      required String activityDiscount}) {
    emit(SchoolsAddActivityLoadingState());
    SchoolActivitiesModel schoolActivitiesModel = SchoolActivitiesModel(
      id: SCHOOL_MODEL!.id,
      schoolId: SCHOOL_MODEL!.id,
      name: activityName,
      description: activityDescription,
      date: activityDate,
      price: activityPrice,
      discount: activityDiscount,
      activityType: 'accepted',
      createdAt: DateTime.now().toString(),
    );
    FirebaseFirestore.instance
        .collection('schools')
        .doc(SCHOOL_MODEL?.id)
        .collection('activities')
        .add(schoolActivitiesModel.toMap())
        .then((value) {
      FirebaseFirestore.instance
          .collection('schools')
          .doc(SCHOOL_MODEL?.id)
          .collection('activities')
          .doc(value.id)
          .update({
        'id': value.id,
      }).then((value) {
        sendNotificationsToParents();
        emit(SchoolsAddActivitySuccessState());
      }).catchError((error) {
        emit(SchoolsAddActivityErrorState(error.toString()));
      });
    }).catchError((error) {
      emit(SchoolsAddActivityErrorState(error.toString()));
    });
  }

  List<SupervisorsModel> schoolsSupervisorsList = [];
  void getAllSupervisors() async {
    try {
      emit(SchoolsGetAllSupervisorsLoadingState());
      await FirebaseFirestore.instance
          .collection('schools')
          .doc(
            SUPERVISOR_MODEL?.schoolsId == null
                ? CacheHelper.getData(key: 'schoolId')
                : SUPERVISOR_MODEL?.schoolsId,
          )
          .collection('supervisors')
          .snapshots()
          .listen((value) {
        schoolsSupervisorsList = [];
        for (var element in value.docs) {
          if (element.data()['id'] == CacheHelper.getData(key: 'uid')) {
            print('this is me🙄');
          } else {
            print('get all supervisors🎉');
            schoolsSupervisorsList
                .add(SupervisorsModel.fromJson(element.data()));
          }
        }
        print('Success get all supervisors🎉');
        emit(SchoolsGetAllSupervisorsSuccessState());
      });
    } catch (error) {
      print('Error get all supervisors: $error');
      emit(SchoolsGetAllSupervisorsErrorState(error.toString()));
    }
  }

  void addSchoolSupervisor({
    required String supervisorId,
    required String supervisorName,
    required String supervisorEmail,
    required String supervisorPassword,
    required String supervisorPhone,
  }) {
    emit(SchoolsAddSupervisorLoadingState());
    SupervisorsModel supervisorsModel = SupervisorsModel(
      id: supervisorId,
      schoolsId: SCHOOL_MODEL!.id,
      name: supervisorName,
      phone: supervisorPhone,
      email: supervisorEmail,
      password: supervisorPassword,
      gender: 'male',
      age: '0',
      ban: 'false',
      image: AppImages.defaultImage,
      createdAt: DateTime.now().toString(),
    );
    FirebaseFirestore.instance
        .collection('schools')
        .doc(SCHOOL_MODEL?.id)
        .collection('supervisors')
        .doc(supervisorId)
        .set(supervisorsModel.toMap())
        .then((value) {
      print('Success add school supervisor🎉');
      emit(SchoolsAddSupervisorSuccessState());
    }).catchError((error) {
      print('Error add school supervisor: $error');
      emit(SchoolsAddSupervisorErrorState(error.toString()));
    });
  }

  void createSuperVisorAccount({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      print('Success Create supervisor 🎉');
      print('value: $value');
      if (value.user?.uid != null) {
        addSchoolSupervisor(
          supervisorId: value.user!.uid,
          supervisorName: name,
          supervisorEmail: email,
          supervisorPassword: password,
          supervisorPhone: phone,
        );
      }
    }).catchError((error) {
      print('Error create supervisor account: $error');
      emit(SchoolsCreateSupervisorAccountErrorState(error.toString()));
    });
  }

  List<TeacherModel> schoolsTeachersList = [];
  void getAllTeacher() {
    try {
      emit(SchoolsGetAllTeachersLoadingState());
      FirebaseFirestore.instance
          .collection('schools')
          .doc(SCHOOL_MODEL?.id)
          .collection('teachers')
          .snapshots()
          .listen((value) {
        schoolsTeachersList = [];
        for (var element in value.docs) {
          print('get all teachers🎉');
          schoolsTeachersList.add(TeacherModel.fromJson(element.data()));
        }
        print('Success get all teachers🎉');
        emit(SchoolsGetAllTeachersSuccessState());
      });
    } catch (error) {
      print('Error get all teachers: $error');
      emit(SchoolsGetAllTeachersErrorState(error.toString()));
    }
  }

  void banSchoolTeacher(
      {required String teacherId, required String teacherBan}) {
    FirebaseFirestore.instance
        .collection('schools')
        .doc(SCHOOL_MODEL?.id)
        .collection('teachers')
        .doc(teacherId)
        .update({
      'ban': teacherBan,
    }).then((value) {
      print('Success ban school teacher🎉');
      emit(SchoolsBanTeacherSuccessState());
    }).catchError((error) {
      print('Error ban school teacher: $error');
      emit(SchoolsBanTeacherErrorState(error.toString()));
    });
  }

  List<ClassModel> schoolsClassesList = [];
  void getAllSchoolClasses() {
    try {
      FirebaseFirestore.instance
          .collection('schools')
          .doc(SCHOOL_MODEL?.id)
          .collection('classes')
          .snapshots()
          .listen((value) {
        schoolsClassesList = [];
        for (var element in value.docs) {
          print('get all classes🎉');
          schoolsClassesList.add(ClassModel.fromJson(element.data()));
        }
        print('Success get all classes🎉');
        emit(SchoolsGetAllClassesSuccessState());
      });
    } catch (error) {
      print('Error get all classes: $error');
      emit(SchoolsGetAllClassesErrorState(error.toString()));
    }
  }

  List<ClassJoinModel> childrenClassJoin = [];
  void getAllChildrenClass({
    required String classId,
  }) {
    emit(SchoolsGetAllChildrenClassLoadingState());
    try {
      FirebaseFirestore.instance
          .collection('schools')
          .doc(SCHOOL_MODEL?.id)
          .collection('classes')
          .doc(classId)
          .collection('children')
          .snapshots()
          .listen((value) {
        childrenClassJoin = [];
        for (var element in value.docs) {
          print('get all children class🎉');
          childrenClassJoin.add(ClassJoinModel.fromJson(element.data()));
        }
        print('Success get all children class🎉');
        emit(SchoolsGetAllChildrenClassSuccessState());
      });
    } catch (error) {
      print('Error get all children class: $error');
      emit(SchoolsGetAllChildrenClassErrorState(error.toString()));
    }
  }

  void banSupervisor({
    required String supervisorId,
    required String supervisorBan,
  }) {
    FirebaseFirestore.instance
        .collection('schools')
        .doc(SCHOOL_MODEL?.id)
        .collection('supervisors')
        .doc(supervisorId)
        .update({
      'ban': supervisorBan,
    }).then((value) {
      print('Success ban school supervisor🎉');
      emit(SchoolsBanSupervisorSuccessState());
    }).catchError((error) {
      print('Error ban school supervisor: $error');
      emit(SchoolsBanSupervisorErrorState(error.toString()));
    });
  }

  Future signOutSupervisor() async {
    await FirebaseAuth.instance.signOut().then((value) {
      CacheHelper.saveData(key: 'uid', value: '');
      CacheHelper.saveData(key: 'schoolId', value: '');
      CacheHelper.saveData(key: 'user', value: '');
      _currentIndex = 0;
      print('Sign Out Success🎉');
      emit(SchoolSignOutSuccessState());
    }).catchError((error) {
      print('Sign Out Error: $error');
      emit(SchoolSignOutErrorState(error.toString()));
    });
  }

  List<SchoolRequestModel> schoolsRequestsList = [];
  void getAllRequests() {
    try {
      emit(SchoolsGetAllRequestsLoadingState());
      FirebaseFirestore.instance
          .collection('schools')
          .doc(SUPERVISOR_MODEL?.schoolsId)
          .collection('requestsChildren')
          .snapshots()
          .listen((value) {
        schoolsRequestsList = [];
        for (var element in value.docs) {
          print('get all requests🎉');
          schoolsRequestsList.add(SchoolRequestModel.fromJson(element.data()));
        }
        print('Success get all requests🎉');
        emit(SchoolsGetAllRequestsSuccessState());
      });
    } catch (error) {
      print('Error get all requests: $error');
      emit(SchoolsGetAllRequestsErrorState(error.toString()));
    }
  }

  List<ActivityJoinModel> schoolsActivitiesJoinList = [];
  void getAllActivitiesJoiRequests() async {
    emit(SchoolsGetAllActivitiesJoinRequestsLoadingState());
    await FirebaseFirestore.instance
        .collection('schools')
        .doc(SUPERVISOR_MODEL?.schoolsId)
        .collection('activitiesJoin')
        .snapshots()
        .listen((event) {
      schoolsActivitiesJoinList = [];
      for (var element in event.docs) {
        print('get all activities join requests🎉');
        schoolsActivitiesJoinList
            .add(ActivityJoinModel.fromJson(element.data()));
      }
      print('Success get all activities join requests🎉');
      emit(SchoolsGetAllActivitiesJoinRequestsSuccessState());
    });
  }

  ChildrenModel? childrenRequestModel;
  void getChildForRequest({required String childId}) {
    emit(SchoolsGetChildForRequestLoadingState());
    FirebaseFirestore.instance.collection('parents').get().then((value) {
      for (var element in value.docs) {
        element.reference
            .collection('children')
            .doc(childId)
            .get()
            .then((value) {
          if (value.exists) {
            childrenRequestModel = ChildrenModel.fromJson(value.data()!);
            print('Success get child for request🎉');
            emit(SchoolsGetChildForRequestSuccessState());
          }
        });
      }
    }).catchError((error) {
      print('Error get child for request: $error');
      emit(SchoolsGetChildForRequestErrorState(error.toString()));
    });
  }

  List<ChildrenModel> schoolsChildrenList = [];
  List<ChildrenModel> schoolsChildrenNotInClassList = [];
  void getAllSchoolChildren() async {
    try {
      emit(SchoolsGetAllChildrenLoadingState());
      FirebaseFirestore.instance
          .collection('schools')
          .doc(SUPERVISOR_MODEL?.schoolsId)
          .collection('children')
          .snapshots()
          .listen((value) {
        schoolsChildrenList = [];
        schoolsChildrenNotInClassList = [];
        for (var element in value.docs) {
          schoolsChildrenList.add(ChildrenModel.fromJson(element.data()));
          if (element.data()['classId'] == null ||
              element.data()['classId'] == '') {
            schoolsChildrenNotInClassList
                .add(ChildrenModel.fromJson(element.data()));
          }
        }

        print('Success get all children🎉');
        emit(SchoolsGetAllChildrenSuccessState());
      });
    } catch (error) {
      print('Error get all children: $error');
      emit(SchoolsGetAllChildrenErrorState(error.toString()));
    }
  }

// get data of parent for request
  ParentModel? parentModelForChildren;
  void getParentForChildren({required String parentId}) {
    emit(SchoolsGetParentForChildRequestLoadingState());
    FirebaseFirestore.instance
        .collection('parents')
        .doc(parentId)
        .get()
        .then((value) {
      if (value.exists) {
        parentModelForChildren = ParentModel.fromJson(value.data()!);
        print('Success get parent for child request🎉');
        emit(SchoolsGetParentForChildRequestSuccessState());
      }
    }).catchError((error) {
      print('Error get parent for child request: $error');
      emit(SchoolsGetParentForChildRequestErrorState(error.toString()));
    });
  }

  List<ReportModel> schoolsReportsList = [];
  void getAllReports({required String childId}) async {
    emit(SchoolsGetAllReportsLoadingState());
    await FirebaseFirestore.instance
        .collection('schools')
        .doc(SUPERVISOR_MODEL?.schoolsId)
        .collection('children')
        .doc(childId)
        .collection('reports')
        .snapshots()
        .listen((event) {
      schoolsReportsList = [];
      for (var element in event.docs) {
        schoolsReportsList.add(ReportModel.fromJson(element.data()));
      }
      print('Success get all reports🎉');
      emit(SchoolsGetAllReportsSuccessState());
    });
  }

  List<AttendModel> schoolsAttendList = [];
  void getAllAttendList({required String childId}) async {
    emit(SchoolsGetAllAttendListLoadingState());
    await FirebaseFirestore.instance
        .collection('schools')
        .doc(SUPERVISOR_MODEL?.schoolsId)
        .collection('children')
        .doc(childId)
        .collection('schedules')
        .snapshots()
        .listen((event) {
      schoolsAttendList = [];
      for (var element in event.docs) {
        schoolsAttendList.add(AttendModel.fromJson(element.data()));
      }
      print('Success get all attend list🎉');
      emit(SchoolsGetAllAttendListSuccessState());
    });
  }

  void addChildrenToClass(
      {required ChildrenModel childrenModel, required String classId}) async {
    emit(SchoolsAddChildrenToClassLoadingState());
    ClassJoinModel classJoinModel = ClassJoinModel(
      id: 'sd32rdfdf34t34fdf',
      classId: classId,
      childId: childrenModel.id,
    );
    await FirebaseFirestore.instance
        .collection('schools')
        .doc(SUPERVISOR_MODEL?.schoolsId)
        .collection('classes')
        .doc(classId)
        .collection('children')
        .add(classJoinModel.toJson())
        .then((value) {
      FirebaseFirestore.instance
          .collection('schools')
          .doc(SUPERVISOR_MODEL?.schoolsId)
          .collection('classes')
          .doc(classId)
          .collection('children')
          .doc(value.id)
          .update({
        'id': value.id,
      });
      print('Success add children to class🎉');
      emit(SchoolsAddChildrenToClassSuccessState());
    }).catchError((error) {
      print('Error add children to class: $error');
      emit(SchoolsAddChildrenToClassErrorState(error.toString()));
    });
    FirebaseFirestore.instance
        .collection('schools')
        .doc(SUPERVISOR_MODEL?.schoolsId)
        .collection('children')
        .doc(childrenModel.id)
        .update({
      'classId': classId,
      'schoolId': SUPERVISOR_MODEL?.schoolsId,
    }).then((value) {
      FirebaseFirestore.instance
          .collection('parents')
          .doc(childrenModel.parentId)
          .collection('children')
          .doc(childrenModel.id)
          .update({
        'classId': classId,
        'schoolId': SUPERVISOR_MODEL?.schoolsId,
      });
      emit(SchoolsAddChildrenToClassSuccessState());
    }).catchError((error) {
      print('Error add children to class: $error');
      emit(SchoolsAddChildrenToClassErrorState(error.toString()));
    });
  }

  void acceptRequest(
      {required ChildrenModel childrenModel, required String requestId}) async {
    emit(SchoolsAccepteRequestLoadingState());
    await FirebaseFirestore.instance
        .collection('schools')
        .doc(SUPERVISOR_MODEL?.schoolsId)
        .collection('children')
        .doc(childrenModel.id)
        .set(childrenModel.toMap())
        .then((value) {
      FirebaseFirestore.instance
          .collection('parents')
          .doc(childrenModel.parentId)
          .collection('requests')
          .doc(requestId)
          .update({
        'requestStatus': 'accepted',
      });
      FirebaseFirestore.instance
          .collection('schools')
          .doc(SUPERVISOR_MODEL?.schoolsId)
          .collection('requestsChildren')
          .doc(requestId)
          .update({
        'requestStatus': 'accepted',
      });
      emit(SchoolsAccepteRequestSuccessState());
    }).catchError((error) {
      print('Error accepte request: $error');
      emit(SchoolsAccepteRequestErrorState(error.toString()));
    });
  }

  void rejectRequest({required String requestId, required String stringNote}) {
    emit(SchoolsRejectRequestLoadingState());
    FirebaseFirestore.instance
        .collection('schools')
        .doc(SUPERVISOR_MODEL?.schoolsId)
        .collection('requestsChildren')
        .doc(requestId)
        .update({
      'requestStatus': 'rejected',
      'note': stringNote,
    }).then((value) {
      FirebaseFirestore.instance
          .collection('parents')
          .doc(childrenRequestModel?.parentId)
          .collection('requests')
          .doc(requestId)
          .update({
        'requestStatus': 'rejected',
        'note': stringNote,
      });
      FirebaseFirestore.instance
          .collection('parents')
          .doc(childrenRequestModel?.parentId)
          .collection('children')
          .doc(childrenRequestModel?.id)
          .update({
        'schoolId': '',
      });
      emit(SchoolsRejectRequestSuccessState());
    }).catchError((error) {
      print('Error reject request: $error');
      emit(SchoolsRejectRequestErrorState(error.toString()));
    });
  }

  void acceptActivitiesJoinRequest({required ActivityJoinModel activitiesReq}) {
    emit(SchoolsAcceptActivitiesJoinRequestLoadingState());
    FirebaseFirestore.instance
        .collection('schools')
        .doc(SUPERVISOR_MODEL?.schoolsId)
        .collection('activitiesJoin')
        .doc(activitiesReq.id)
        .update({
      'activityStatus': 'accepted',
    }).then((value) {
      FirebaseFirestore.instance
          .collection('schools')
          .doc(SUPERVISOR_MODEL?.schoolsId)
          .collection('activities')
          .doc(activitiesReq.schoolActivityId)
          .collection('children')
          .add(activitiesReq.toMap())
          .then((value) {
        FirebaseFirestore.instance
            .collection('schools')
            .doc(SUPERVISOR_MODEL?.schoolsId)
            .collection('activities')
            .doc(activitiesReq.schoolActivityId)
            .collection('children')
            .doc(value.id)
            .update({
          'id': value.id,
          'activityStatus': 'accepted',
        }).then((value) {
          FirebaseFirestore.instance
              .collection('parents')
              .doc(childrenRequestModel?.parentId)
              .collection('children')
              .doc(activitiesReq.childId)
              .collection('activitiesJoin')
              .add(activitiesReq.toMap());
        });
      });
      emit(SchoolsAcceptActivitiesJoinRequestSuccessState());
    }).catchError((error) {
      print('Error accept activities join request: $error');
      emit(SchoolsAcceptActivitiesJoinRequestErrorState(error.toString()));
    });
  }

  List<SchoolActivitiesModel> schoolsActivitiesList = [];
  void getAllActivities() {
    emit(SchoolsGetAllActivitiesLoadingState());
    FirebaseFirestore.instance
        .collection('schools')
        .doc(SUPERVISOR_MODEL?.schoolsId)
        .collection('activities')
        .snapshots()
        .listen((value) {
      schoolsActivitiesList = [];
      for (var element in value.docs) {
        schoolsActivitiesList
            .add(SchoolActivitiesModel.fromJson(element.data()));
      }
      emit(SchoolsGetAllActivitiesSuccessState());
    }).onError((error, stackTrace) {
      print('Error get all activities: $error');
      emit(SchoolsGetAllActivitiesErrorState(error.toString()));
    });
  }

  void unTrackingChild({
    required String childId,
    required String parentId,
    required bool isTracking,
  }) {
    StopTrackingChildModel stopTrackingChildModel = StopTrackingChildModel(
      id: 'wwwwwwww',
      childId: childId,
      supervisorId: SUPERVISOR_MODEL?.id ?? '',
      note: '',
    );
    emit(SchoolsUnTrackingChildLoadingState());
    if (isTracking) {
      FirebaseFirestore.instance
          .collection('schools')
          .doc(SUPERVISOR_MODEL?.schoolsId)
          .collection('stopTracking')
          .doc(childId)
          .set(stopTrackingChildModel.toMap());
    } else {
      FirebaseFirestore.instance
          .collection('schools')
          .doc(SUPERVISOR_MODEL?.schoolsId)
          .collection('stopTracking')
          .doc(childId)
          .delete();
    }
    FirebaseFirestore.instance
        .collection('schools')
        .doc(SUPERVISOR_MODEL?.schoolsId)
        .collection('children')
        .doc(childId)
        .update({
      'tracking': isTracking,
    }).then((value) {
      print('Success un tracking child');
      FirebaseFirestore.instance
          .collection('parents')
          .doc(parentId)
          .collection('children')
          .doc(childId)
          .update({
        'tracking': isTracking,
      });
      emit(SchoolsUnTrackingChildSuccessState());
    }).catchError((error) {
      print('Error un tracking child: $error');
      emit(SchoolsUnTrackingChildErrorState(error.toString()));
    });
  }

  void sendMessage({required String message, required String receiverId}) {
    emit(SchoolSendMessageLoadingState());
    MessageModel messageModel = MessageModel(
      senderId: SUPERVISOR_MODEL?.id ?? '',
      receiverId: receiverId,
      message: message,
      dateTime: DateTime.now().toString(),
    );
    FirebaseFirestore.instance
        .collection('schools')
        .doc(SUPERVISOR_MODEL?.schoolsId)
        .collection('supervisors')
        .doc(SUPERVISOR_MODEL?.id)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      print('Success send message to supervisor 🎉');
      emit(SchoolSendMessageSuccessState());
    }).catchError((error) {
      print('Error send message: $error');
      emit(SchoolSendMessageErrorState(error: error.toString()));
    });
    FirebaseFirestore.instance.collection('parents').doc(receiverId).get().then(
      (value) {
        if (value.exists) {
          FirebaseFirestore.instance
              .collection('parents')
              .doc(receiverId)
              .collection('chats')
              .doc(SUPERVISOR_MODEL?.id)
              .collection('messages')
              .add(messageModel.toMap())
              .then((value) {
            print('Success send message to parent🎉');
          });
        }
      },
    );
  }

  List<MessageModel> messages = [];
  void getMessages({required String receiverId}) {
    emit(SchoolGetMessagesLoadingState());
    FirebaseFirestore.instance
        .collection('schools')
        .doc(SUPERVISOR_MODEL?.schoolsId)
        .collection('supervisors')
        .doc(SUPERVISOR_MODEL?.id)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });
      emit(SchoolGetMessagesSuccessState());
    });
  }

  void sendNotificationsToParents() async {
    // Get all the parent documents from the parent collection
    var parentDocs =
        await FirebaseFirestore.instance.collection('parents').get();
    // Get all the token documents from the token collection
    var tokenDocs = await FirebaseFirestore.instance.collection('tokens').get();
    // Convert the token documents to a map for easier lookup later
    var tokensMap = Map.fromIterable(tokenDocs.docs,
        key: (doc) => doc['id'], value: (doc) => doc['token']);

    // Loop through each parent document
    parentDocs.docs.forEach((parentDoc) {
      var parentId = parentDoc.id;
      if (tokensMap.containsKey(parentId)) {
        var token = tokensMap[parentId];
        // Send a notification to the parent's token
        sendNotificationToParent(token);
      } else {
        print('No token found for parent $parentId');
      }
    });
  }

  void sendNotificationToParent(String token) async {
    var response = await http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: <String, String>{
        "content-type": "application/json",
        "Authorization": TOKEN_MESSAGE,
      },
      body: jsonEncode({
        "to": token,
        "notification": {
          "body":
              "👋 A new activity has been added. Log in to your account to view the details and participate.",
          "title": "New Activity Added🎉"
        },
      }),
    );
    // Check the response for errors or other information
    print(response.body);
  }
}
