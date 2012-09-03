# An exhibit that converts a User into a Hash suitable for a Mustache view
# to display.
class UserExhibit < Exhibit

  # Returns a Hash of user view data:
  #   :id       - The user id String.
  #   :name     - The user's full name String.
  #   :url      - The url String to their profile.
  #   :gravatar - The url String to their Gravatar image.
  def to_hash
    {
      id: id,
      name: name,
      bio: bio,
      url: view.user_path(id),
      gravatar: view.gravatar_for(email)
    }
  end
end

