import 'package:active_fit/core/data/repository/user_repository.dart';
import 'package:active_fit/core/domain/entity/user_entity.dart';

class AddUserUsecase {
  final UserRepository _userRepository;

  AddUserUsecase(this._userRepository);

  Future<void> addUser(UserEntity userEntity) async {
    return await _userRepository.updateUserData(userEntity);
  }
}
