# An exhibit that renders a Tweet and its User author into a Hash suitable
# for a Mustache view to display.
class TweetExhibit < Exhibit

  # Decorate Tweet#user calls with a UserExhibit so the User can be properly
  # rendered in the view.
  #
  # Returns a UserExhibit decorating this tweet's User.
  def user
    @user ||= UserExhibit.new(model.user, view)
  end

  # Convert this Tweet into a Hash suitable for a view template.
  #
  # Returns a Hash of tweet view data:
  #  :text       - The tweet's content String.
  #  :source     - The app String used to post the tweet.
  #  :url        - The String url to the tweet.
  #  :created_at - The Hash of timstamp info:
  #    :millis   - The timestamp in milliseconds.
  #    :date     - The formatted date String (e.g. '24 Jun').
  #    :full     - The formatted full date String (e.g. '11:33 AM - 24 Jun 12').
  #  :favorites  - The Hash of favorite info. Not all tweet views populate the
  #                favorite count.
  #    :any      - A Boolean true if anyone has starred this tweet.
  #    :count    - The Fixnum count of stars.
  #    :text     - How many people liked this tweet (e.g. '12 people').
  #  :author     - The Hash of user info:
  #    :id       - The user id String.
  #    :name     - The user's full name String.
  #    :url      - The url String to their profile.
  #    :gravatar - The url String to their Gravatar image.
  def to_hash
    {
      text: text,
      source: source,
      url: view.user_tweet_path(user.id, id),
      created_at: {
        millis: (created_at.to_f * 1000).to_i,
        date: view.datef(created_at),
        full: view.full_date(created_at)
      },
      favorites: {
        any: (stars || 0) > 0,
        count: stars,
        text: view.pluralize(stars, 'person', 'people')
      },
      author: user.to_hash
    }
  end
end

