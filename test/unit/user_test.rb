require 'minitest_helper'

describe User do
  let(:user) { User.new(password: 'secr3t') }

  describe '#authenticate' do
    it 'rejects nil passwords' do
      user.authenticate(nil).must_equal false
    end

    it 'rejects empty passwords' do
      user.authenticate('').must_equal false
    end

    it 'rejects invalid passwords' do
      user.authenticate('passw0rd').must_equal false
    end

    it 'accepts a valid password' do
      user.authenticate('secr3t').must_equal true
    end
  end
end

