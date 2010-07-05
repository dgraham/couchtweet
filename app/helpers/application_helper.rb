# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def datef(time)
    suffixes = %w[th st nd rd th th th th th th]
    if time < 1.day.ago
      time = time.strftime("%I:%M %p %b %d")
      time.slice!(0) if time[0] == '0'
      time + suffixes[time[-1].to_i]
    else
      time_ago_in_words(time) + " ago"
    end
  end

end
