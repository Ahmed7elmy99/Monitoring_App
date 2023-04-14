import '../routes/app_routes.dart';
import 'app_images.dart';

class HomeModel {
  final String title;
  final String description;
  final String route;
  final String image;

  HomeModel({
    required this.title,
    required this.description,
    required this.image,
    required this.route,
  });

  static List<HomeModel> homeList = [
    HomeModel(
      title: 'Schools',
      description: 'School Description',
      image: AppImages.schoolIcon,
      route: Routers.SCHOOL,
    ),
    HomeModel(
      title: 'Admins',
      description: 'Teacher Description',
      image: AppImages.adminIcon,
      route: Routers.ADMINS_SCREEN,
    ),
    HomeModel(
      title: 'Parents',
      description: 'Teacher Description',
      image: AppImages.parentLIcon,
      route: Routers.ADMIN_PARENTS_SCREEN,
    ),
  ];
}

class SchoolHomeModel {
  final String title;
  final String route;
  final String image;

  SchoolHomeModel({
    required this.title,
    required this.image,
    required this.route,
  });

  static List<SchoolHomeModel> schoolHomeList = [
    SchoolHomeModel(
      title: 'Teachers',
      image: AppImages.teacherIcon,
      route: Routers.SCHOOL_TEACHERS,
    ),
    SchoolHomeModel(
      title: 'Supervisors',
      image: AppImages.adminIcon,
      route: Routers.SCHOOL_SUPERVISOR,
    ),
    SchoolHomeModel(
      title: 'Classes',
      image: AppImages.classroomIcon,
      route: Routers.SCHOOL_CLASSES,
    ),
    SchoolHomeModel(
      title: 'Children',
      image: AppImages.childrenIcon,
      route: Routers.SCHOOL_CHILDREN,
    ),
    SchoolHomeModel(
      title: 'Activities',
      image: AppImages.activityIcon01,
      route: Routers.SCHOOL_ACTIVITIES,
    ),
  ];
}

class ParentHomeModel {
  final String title;
  final String route;
  final String image;

  ParentHomeModel({
    required this.title,
    required this.image,
    required this.route,
  });

  static List<ParentHomeModel> parentHomeList = [
    ParentHomeModel(
      title: 'Schools',
      image: AppImages.schoolIcon,
      route: Routers.PARENTS_SCHOOLS_SCREEN,
    ),
    ParentHomeModel(
      title: 'Children',
      image: AppImages.childrenIcon,
      route: Routers.PARENTS_CHILDREN_SCREEN,
    ),
  ];
}

class TeachersModel {
  final String title;
  final String route;
  final String image;

  TeachersModel({
    required this.title,
    required this.image,
    required this.route,
  });

  static List<TeachersModel> teacherHomeList = [
    TeachersModel(
      title: 'Teachers',
      image: AppImages.adminIcon,
      route: Routers.TEACHERS_SCREEN,
    ),
    TeachersModel(
      title: 'Classes',
      image: AppImages.classroomIcon,
      route: Routers.TEACHERS_CLASSES_SCREEN,
    ),
  ];
}
