# Helper methods for formatting date/time info. These methods are mixed into
# the mustache view classes.
module DateHelper
  def datef(time)
    if time < 1.day.ago
      time = time.strftime("%d %b ")
      time.slice!(0) if time[0] == '0'
      time
    else
      time_ago_in_words(time)
    end
  end

  # Formats the time with the full date information.
  #
  # Examples
  #
  #   time = Time.now
  #   # => 2012-06-24 11:22:44 -0600
  #   full_date(time)
  #   # => "11:22 AM - 24 Jun 12"
  #
  # Returns a formatted time String.
  def full_date(time)
    time.strftime("%I:%M %p - %d %b %y")
  end
end
