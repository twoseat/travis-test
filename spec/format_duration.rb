# A mixin that adds the ability to format a +Numeric+ as a user-readable duration
class Numeric

  # Formats a number as a user-readable duration
  #
  # @return [String] a user-readable duration. Follows the following algorithm
  #                   1. If more than an hour, print hours and minutes
  #                   2. If less than an hour and more than a minute, print minutes and seconds
  #                   3. If less than a minute and more than a second, print seconds.tenths
  def duration
    remainder = self

    hours = (remainder / HOUR).to_int
    remainder -= HOUR * hours

    minutes = (remainder / MINUTE).to_int
    remainder -= MINUTE * minutes

    return "#{hours}h #{minutes}m" if hours > 0

    seconds = (remainder / SECOND).to_int
    remainder -= SECOND * seconds

    return "#{minutes}m #{seconds}s" if minutes > 0

    tenths = (remainder / TENTH).to_int
    "#{seconds}.#{tenths}s"
  end

  private

  MILLISECOND = 0.001.freeze

  TENTH = (100 * MILLISECOND).freeze

  SECOND = (10 * TENTH).freeze

  MINUTE = (60 * SECOND).freeze

  HOUR = (60 * MINUTE).freeze

end
