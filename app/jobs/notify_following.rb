# A resque job that emails a user when someone follows their tweets. Emails
# should never be sent from the rails app because they block processing new
# requests.
#
# Examples
#
#   # process followers jobs
#   $ QUEUE=followers bin/rake resque:work
class NotifyFollowing
  @queue = :followers

  def self.perform(user_id, follower_id)
    user = User.get(user_id)
    follower = User.get(follower_id)
    return unless user && follower
    FollowerMailer.following_email(user, follower).tap do |mail|
      puts mail
    end.deliver
  end
end
