# Send emails regarding followers. This should be called from a background
# resque job so mail delivery doesn't block the rails app.
class FollowerMailer < ActionMailer::Base
  default :from => 'notifications@example.com'

  # Notify the user that they have a new follower
  #
  # user     - The User who is being followed.
  # follower - The User who is interested in their tweets.
  #
  # Returns nothing.
  def following_email(user, follower)
    @user, @follower = user, follower
    mail(to: user.email, subject: "#{follower.id} is now following your tweets!")
  end
end
