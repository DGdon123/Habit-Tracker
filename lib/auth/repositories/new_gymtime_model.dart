import 'package:hive/hive.dart';

part 'new_gymtime_model.g.dart';

@HiveType(typeId: 1)
class DataModel1 extends HiveObject {
  @HiveField(0)
  final String? date;

  @HiveField(1)
  final String? time;

  DataModel1({this.date, this.time});
}
