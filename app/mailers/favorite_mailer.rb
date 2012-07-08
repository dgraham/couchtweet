# Send emails regarding favorites. This should be called from a background
# resque job so mail delivery doesn't block the rails app.
class FavoriteMailer < ActionMailer::Base
  default :from => 'notifications@example.com'

  # Notify the user that someone liked their tweet.
  #
  # favorite - The Favorite with references to the user, author, and tweet.
  #
  # Returns nothing.
  def favorite_email(favorite)
    @favorite = favorite
    mail(to: favorite.author.email, subject: "#{favorite.user.id} liked your tweet!")
  end
end
