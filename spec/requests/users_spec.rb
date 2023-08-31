require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /signup" do
    it "正常にレスポンスを返すこと" do
      get signup_path
      expect(response).to have_http_status(:success)
    end
    
    it 'Sign up | Ruby on Rails Tutorial Sample Appが含まれること' do
     get signup_path
     expect(response.body).to include full_title('Sign up')
   end
  end
  
  
  describe 'get /users/{id}/edit' do
    let(:user) { create(:user) }
    
    it 'タイトルがEdit user | Ruby on Rails Tutorial Sample Appであること' do
     log_in user
     get edit_user_path(user)
     expect(response.body).to include full_title('Edit user')
    end
    
    context '未ログインの場合' do
      it 'flashが空でないこと' do
        get edit_user_path(user)
        expect(flash).not_to be_empty
      end
      
      it '未ログインユーザーはログインページにリダイレクトされること' do
        get edit_user_path(user)
        expect(response).to redirect_to login_path
      end
      
      it 'ログインすると編集ページにリダイレクトされること' do
        get edit_user_path(user)
        log_in(user)
        expect(response).to redirect_to edit_user_path(user)
      end
    end
    
    context '別のユーザーの場合' do
      let(:another_user) { create(:user, :another) }
      
      before do
        log_in(user)
        get edit_user_path(another_user)
      end
      
      it 'flashが空であること' do
        expect(flash).to be_empty
      end
      
      it 'root_pathにリダイレクトされること' do
        expect(response).to redirect_to root_path
      end
    end
  end
  
  
  describe 'PATCH /users' do
    let(:user) { create(:user) }
    
    it 'タイトルが Edit user | Ruby on Rails Tutorial Sample Appであること' do
      log_in(user)
      get edit_user_path(user)
      expect(response.body).to include full_title('Edit user')
    end
    
    context '無効な値の場合' do
      before do
        log_in(user)
        patch user_path(user), params: { user: { name: '', email: 'foo@invlid', password: 'foo', password_confirmation: 'bar' } }
      end
      
      it 'アップデートに失敗すること' do
        user.reload
        expect(user.name).not_to eq('')
        expect(user.email).not_to eq('')
        expect(user.password).not_to eq('foo')
        expect(user.password_confirmation).to_not eq 'bar'
      end
      
      it '更新アクションの後に editページが表示されてること' do
        expect(response.body).to include full_title('Edit user')
      end
      
      it 'formに４つのエラーが出ていること' do
        expect(response.body).to include ('The form contains 4 errors.')
      end
    end
    
    context '有効な値の場合' do
      before do
        log_in(user)
        @name = 'Foo Bar'
        @email = 'foo@bar.com'
        patch user_path(user), params: { user: { name: @name, email: @email, password: '', password_confirmation: '' } }
      end
      
      it 'アップデートに成功すること' do
        user.reload
        expect(user.name).to eq @name
        expect(user.email).to eq @email
      end
      
      it 'Users#showにリダイレクトすること' do
        expect(response).to redirect_to user
      end
      
      it 'flashが表示されてること' do
        expect(flash).to be_any
      end
    end
    
    context '未ログインの場合' do
      it 'flashが空でないこと' do
        patch user_path(user), params: { user: { name: user.name, email: user.email } }
        expect(flash).to_not be_empty
      end
      
      it '未ログインユーザはログインページにリダイレクトされること' do
        patch user_path(user), params: { user: { name: user.name, email: user.email } }
        expect(response).to redirect_to login_path
      end
    end
    
    context '別のユーザーの場合' do
      let(:another_user) { create(:user, :another) }
      
      before do
        log_in(user)
        patch user_path(another_user), params: { user: { name: another_user.name, email: another_user.email } }
      end
      
      it 'flashが空であること' do
        expect(flash).to be_empty
      end
      
      it 'root_pathにリダイレクトされること' do
        expect(response).to redirect_to root_path
      end
    end
  end
end
