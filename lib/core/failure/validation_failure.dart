abstract class ValidationFailure {
  final String message;
  const ValidationFailure(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ValidationFailure &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}

class PastCheckInFailure extends ValidationFailure {
  const PastCheckInFailure()
      : super('Check-in date cannot be in the past.');
}

class InvalidCheckOutFailure extends ValidationFailure {
  const InvalidCheckOutFailure()
      : super('Check-out date must be after check-in date.');
}

class RoomNotSelectedFailure extends ValidationFailure {
  const RoomNotSelectedFailure()
      : super('Please select a hotel room to continue.');
}

class MissingDatesFailure extends ValidationFailure {
  const MissingDatesFailure()
      : super('Please select both check-in and check-out dates.');
}
