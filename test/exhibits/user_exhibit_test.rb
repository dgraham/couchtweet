require 'minitest_helper'

describe UserExhibit do
  let(:user)    { OpenStruct.new(id: 'alice', name: 'Alice', email: 'email', bio: 'bio') }
  let(:view)    { MiniTest::Mock.new }
  let(:exhibit) { UserExhibit.new(user, view) }

  describe '#to_hash' do
    before do
      view.expect :user_path, 'url', [user.id]
      view.expect :gravatar_for, 'gravatar', [user.email]
    end

    it 'includes user url' do
      exhibit.to_hash[:url].must_equal 'url'
      view.verify
    end

    it 'includes gravatar url' do
      exhibit.to_hash[:gravatar].must_equal 'gravatar'
      view.verify
    end

    it 'includes all user properties' do
      exhibit.to_hash.must_equal(
        id:   user.id,
        name: user.name,
        bio:  user.bio,
        url:  'url',
        gravatar: 'gravatar')
      view.verify
    end
  end
end

