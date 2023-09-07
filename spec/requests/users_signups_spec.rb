require 'rails_helper'

RSpec.describe "UsersSignups", type: :request do

  describe "POST /user #create" do
    it "無効な値だと登録されないこと" do
      expect {
       post users_path, params: { user: { name: '',
                                          email: 'user@invlid',
                                          password: 'foo',
                                          password_confirmation: 'bar' } }
      }.to_not change(User, :count)
    end
  end 
  
  context '有効な値の場合' do
   let(:user_params) { { user: { name: 'Example User',
                                 email: 'user@example.com',
                                 password: 'password',
                                 password_confirmation: 'password' } } }
                                 
    before do
       ActionMailer::Base.deliveries.clear
    end

    it '登録されること' do
       expect {
         post users_path, params: user_params
       }.to change(User, :count).by 1
    end
  
    it 'rootにリダイレクトされること' do
       post users_path, params: user_params
       user = User.last
       expect(response).to redirect_to root_path
    end
     
    it 'flashが表示されること' do
       post users_path, params: user_params
       expect(flash).to be_any
    end
     
    it 'ログイン状態ではないこと' do
       post users_path, params: user_params
       expect(logged_in?).to be_falsy
    end
     
    it 'メールが1件存在すること' do
         post users_path, params: user_params
         expect(ActionMailer::Base.deliveries.size).to eq 1
    end

    it '登録時点ではactivateされていないこと' do
       post users_path, params: user_params
       expect(User.last).to_not be_activated
    end
  end
end
