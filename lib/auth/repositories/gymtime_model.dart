import 'package:hive/hive.dart';

part 'gymtime_model.g.dart';

@HiveType(typeId: 0)
class DataModel extends HiveObject {
  @HiveField(0)
  final String? date;

  @HiveField(1)
  final String? time;

  DataModel({this.date, this.time});
}
