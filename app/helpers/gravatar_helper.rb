# Helper methods for the Gravatar service at gravatar.com. These methods are
# mixed into the mustache view classes.
module GravatarHelper
  # Constructs a Gravatar url for the user's email address.
  #
  # email - The user's email String that's used in their Gravatar url.
  # size  - The Fixnum size of the Gravatar image (default: 48). This is
  #         doubled in the Gravatar request to handle retina displays. Make
  #         sure to set a width and height on the img container of the
  #         original size.
  #
  # Returns the url String.
  def gravatar_for(email, size=48)
    hash = Digest::MD5.hexdigest(email.strip.downcase)
    "https://gravatar.com/avatar/%s?s=%s" % [hash, size * 2]
  end
end
