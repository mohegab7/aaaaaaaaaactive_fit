import 'package:active_fit/core/data/repository/intake_repository.dart';
import 'package:active_fit/core/domain/entity/intake_entity.dart';


class DeleteIntakeUsecase {
  final IntakeRepository _intakeRepository;

  DeleteIntakeUsecase(this._intakeRepository);

  Future<void> deleteIntake(IntakeEntity intakeEntity) async {
    await _intakeRepository.deleteIntake(intakeEntity);
  }
}
