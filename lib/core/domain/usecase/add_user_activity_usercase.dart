import 'package:active_fit/core/data/repository/user_activity_repository.dart';
import 'package:active_fit/core/domain/entity/user_activity_entity.dart';

class AddUserActivityUsecase {
  final UserActivityRepository _userActivityRepository;

  AddUserActivityUsecase(this._userActivityRepository);

  Future<void> addUserActivity(UserActivityEntity userActivityEntity) async {
    return await _userActivityRepository.addUserActivity(userActivityEntity);
  }
}
