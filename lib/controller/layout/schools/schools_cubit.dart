import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teatcher_app/core/utils/const_data.dart';
import 'package:teatcher_app/models/teacher_model.dart';

import '../../../core/services/cache_helper.dart';
import '../../../core/utils/app_images.dart';
import '../../../models/children_model.dart';
import '../../../models/class_model.dart';
import '../../../models/school_activities_model.dart';
import '../../../models/school_join_model.dart';
import '../../../models/school_model.dart';
import '../../../models/supervisors_model.dart';
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

  void createActivityInSchool({
    required String activityName,
    required String activityDescription,
    required String activityDate,
    required String activityPrice,
    required String activityDiscount,
  }) {
    emit(SchoolsAddActivityLoadingState());
    SchoolActivitiesModel schoolActivitiesModel = SchoolActivitiesModel(
      id: SCHOOL_MODEL!.id,
      schoolId: SCHOOL_MODEL!.id,
      name: activityName,
      description: activityDescription,
      date: activityDate,
      price: activityPrice,
      discount: activityDiscount,
      activityType: 'pending',
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

  ChildrenModel? childrenRequestModel;
  void getChildForRequest({
    required String childId,
  }) {
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
        for (var element in value.docs) {
          schoolsChildrenList.add(ChildrenModel.fromJson(element.data()));
        }
        print('Success get all children🎉');
        emit(SchoolsGetAllChildrenSuccessState());
      });
    } catch (error) {
      print('Error get all children: $error');
      emit(SchoolsGetAllChildrenErrorState(error.toString()));
    }
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
        'note': stringNote,
      });
      emit(SchoolsRejectRequestSuccessState());
    }).catchError((error) {
      print('Error reject request: $error');
      emit(SchoolsRejectRequestErrorState(error.toString()));
    });
  }
}
