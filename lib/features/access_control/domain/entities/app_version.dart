import 'package:equatable/equatable.dart';

class AppVersion extends Equatable {
  final String version;
  final String url;

  const AppVersion({required this.version, required this.url});

  @override
  List<Object?> get props => [version, url];
}
