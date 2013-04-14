require 'minitest_helper'

describe TweetExhibit do
  let(:user)    { OpenStruct.new(id: 'alice', name: 'Alice', email: 'email', bio: 'bio') }
  let(:tweet)   { OpenStruct.new( id: 42, text: 'tweet!', source: 'web', user: user, created_at: Time.now, stars: 12) }
  let(:view)    { MiniTest::Mock.new }
  let(:exhibit) { TweetExhibit.new(tweet, view) }

  describe '#user' do
    it 'decorates with UserExhibit' do
      exhibit.user.is_a? UserExhibit
    end
  end

  describe '#to_hash' do
    before do
      view.expect :user_tweet_path, 'tweet_url', [user.id, tweet.id]
      view.expect :datef, 'date', [tweet.created_at]
      view.expect :full_date, 'full_date', [tweet.created_at]
      view.expect :pluralize, 'plural', [tweet.stars, 'person', 'people']
      view.expect :user_path, 'user_url', [user.id]
      view.expect :gravatar_for, 'gravatar', [user.email]
    end

    it 'includes tweet info' do
      exhibit.to_hash.tap do |hash|
        hash[:text].must_equal tweet.text
        hash[:source].must_equal tweet.source
        hash[:url].must_equal 'tweet_url'
      end
      view.verify
    end

    it 'includes timestamps' do
      exhibit.to_hash[:created_at].tap do |hash|
        hash.key?(:millis).must_equal true
        hash[:date].must_equal 'date'
        hash[:full].must_equal 'full_date'
      end
      view.verify
    end

    it 'includes favorites' do
      exhibit.to_hash[:favorites].must_equal(
        any: true,
        count: tweet.stars,
        text: 'plural')
      view.verify
    end

    it 'includes author hash' do
      exhibit.to_hash[:author].must_equal(
        id:   user.id,
        name: user.name,
        bio:  user.bio,
        url:  'user_url',
        gravatar: 'gravatar')
      view.verify
    end
  end
end

