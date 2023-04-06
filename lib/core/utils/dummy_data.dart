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
  ];
}
