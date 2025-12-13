import 'package:hive/hive.dart';

part 'activity_model_hive.g.dart';

@HiveType(typeId: 1)
class ActivityModelHive extends HiveObject{
  @HiveField(0)
  String id;

  @HiveField(1)
  DateTime time;

  ActivityModelHive({required this.id, required this.time});
}