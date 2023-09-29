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
 
 describe '#authenticated?' do
   it 'digestがnilならfalseを返すこと' do
     expect(user.authenticated?(:remember, '')).to be_falsy
   end
 end
 
  describe '#follow and #unfollow' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user, :another) }
    
    it 'followするとfollowing?がtrueになること' do
      expect(user.following?(another_user)).to_not be_truthy
      user.follow(another_user)
      expect(user.following?(another_user)).to be_truthy
    end
    
    it 'unfollowするとfollowing?がfalseになること' do
      user.follow(another_user)
      expect(user.following?(another_user)).to_not be_falsey
      user.unfollow(another_user)
      expect(user.following?(another_user)).to be_falsey
    end
    
    it 'followするとfollowing?がtrueになること' do
      expect(user.following?(another_user)).to_not be_truthy
      user.follow(another_user)
      expect(another_user.followers.include?(user)).to be_truthy
      expect(user.following?(another_user)).to be_truthy
    end
  end
  
  describe '#feed' do
    let(:posted_by_user){ create(:post_by_user) }
    let(:posted_by_lana){ create(:post_by_lana) }
    let(:posted_by_archer){ create(:post_by_archer) }
    let(:user) { posted_by_user.user }
    let(:lana) { posted_by_lana.user }
    let(:another) { posted_by_archer.user }
  
    before do
      user.follow(lana)
    end
  
    it 'フォローしているユーザの投稿が表示されること' do
      lana.microposts.each do |lana_posts|
        expect(user.feed.include?(lana_posts)).to be_truthy
      end
    end
    
    it '自分自身の投稿が表示されること' do
      user.microposts.each do |self_posts|
        expect(user.feed.include?(self_posts)).to be_truthy
      end
    end
    
    it 'フォローしていないユーザの投稿は表示されないこと' do
      another.microposts.each do |another_posts|
        expect(user.feed.include?(another_posts)).to be_falsey
      end
    end
  end
end

