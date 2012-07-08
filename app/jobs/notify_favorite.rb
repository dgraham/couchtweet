# A resque job that emails a user when someone marks their tweet as a favorite.
# Emails should never be sent from the rails app because they block processing
# new requests.
#
# Examples
#
#   # process favorites jobs
#   $ QUEUE=favorites bin/rake resque:work
class NotifyFavorite
  @queue = :favorites

  def self.perform(favorite_id)
    favorite = Favorite.get(favorite_id)
    return unless favorite
    FavoriteMailer.favorite_email(favorite).tap do |mail|
      puts mail
    end.deliver
  end
end
