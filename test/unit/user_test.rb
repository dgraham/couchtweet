require 'minitest_helper'

describe User do

  describe '#authenticate' do
    let(:user) { User.new(password: 'secr3t') }

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

  describe '#password=' do
    let(:user) { User.new }

    it 'accepts nil' do
      user.password = nil
      user.password.must_be_nil
    end

    it 'accepts empty passwords as nil' do
      user.password = ''
      user.password.must_be_nil
    end

    it 'accepts plain text' do
      user.password = 'secr3t'
      user.password.must_be_instance_of String
      user.password.wont_equal 'secr3t'
      BCrypt::Password.new(user.password).must_be :==, 'secr3t'
    end

    it 'accepts bcrypted text' do
      crypted = BCrypt::Password.create('secr3t')
      user.password = crypted
      user.password.must_be_instance_of String
      user.password.wont_equal 'secr3t'
      user.password.must_equal crypted.to_s
      BCrypt::Password.new(user.password).must_be :==, 'secr3t'
    end
  end

  describe '#valid?' do
    describe 'password' do
      let(:user) { User.new(email: 'test@example.com') }

      it 'rejects nil passwords' do
        user.password = nil
        user.valid?.must_equal false
        user.errors.include?(:password).must_equal true
      end

      it 'rejects empty passwords' do
        user.password = ''
        user.valid?.must_equal false
        user.errors.include?(:password).must_equal true
      end

      it 'accepts good addresses' do
        user.password = 'secr3t'
        user.valid?.must_equal true
        user.errors.empty?.must_equal true
      end
    end

    describe 'email' do
      let(:user) { User.new(password: 'secr3t') }

      it 'rejects nil addresses' do
        user.email = nil
        user.valid?.must_equal false
        user.errors.include?(:email).must_equal true
      end

      it 'rejects empty addresses' do
        user.email = ''
        user.valid?.must_equal false
        user.errors.include?(:email).must_equal true
      end

      it 'rejects short addresses' do
        user.email = 'a@b'
        user.valid?.must_equal false
        user.errors.include?(:email).must_equal true
      end

      it 'rejects long addresses' do
        user.email = '%s@%s.com' % ['a' * 150, 'b' * 150]
        user.valid?.must_equal false
        user.errors.include?(:email).must_equal true
      end

      it 'accepts good addresses' do
        user.email = 'test@example.com'
        user.valid?.must_equal true
        user.errors.empty?.must_equal true
      end
    end
  end
end

