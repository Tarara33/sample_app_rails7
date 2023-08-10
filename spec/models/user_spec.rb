require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { User.new(name: 'Sarina',
                        email: 'user@exsample.com',
                        password: "foobar",
                        password_confirmation: "foobar")}
  
  context '入力フォーム' do
    it 'userが有効であること' do
      expect(user).to be_valid
    end
    
    it 'nameが必須であること' do
      user.name = ''
      expect(user).to be_invalid
    end
    
    it 'emailが必須であること' do
      user.email = ''
      expect(user).to be_invalid
    end
  end
  
  context '文字数制限' do
    it 'nameは50文字以内であること' do
      user.name = "a" * 51
      expect(user).to be_invalid
    end 
    
    it 'emailは255文字以内であること' do
      user.email = "#{'a' * 244} + @example.com" 
      expect(user).to be_invalid
    end 
  end
  
  context 'メールアドレス系' do
    it 'メールアドレスが有効な形式であること' do
      valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                           first.last@foo.jp alice+bob@baz.cn]
      valid_addresses.each do |valid_address|
        user.email = valid_address
        expect(user).to be_valid
      end
    end
    
    it 'メールアドレスが無効な形式であること' do
      invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                             foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      invalid_addresses.each do |invalid_address|
        user.email = invalid_address
        expect(user).to be_invalid
      end
    end
    
    it 'emailは小文字でDB登録されていること' do
     mixed_case_email = 'Foo@ExAMPle.CoM'
     user.email = mixed_case_email
     user.save
     expect(user.reload.email).to eq mixed_case_email.downcase
   end
 end
 
 context 'パスワード系' do
   it 'パスワードが必須であること' do
     user.password = user.password_confirmation = '' * 6
     expect(user).to be_invalid
   end
   
   it 'パスワードは6文字以上であること' do
     user.password = user.password_confirmation = 'a' * 5
     expect(user).to be_invalid
   end
 end
 
end
