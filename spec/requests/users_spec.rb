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
  
  
  describe 'GET /users' do
    let(:user) { create(:user) }
    let(:no_activate_user) { create(:no_activate_user) }
    
    it 'activateされていないユーザは表示されないこと' do
     log_in user
     get users_path
     expect(response.body).to_not include no_activate_user.name
    end
  end
  
  describe 'get /users/{id}/edit' do
    let(:user) { create(:user) }
    let(:no_activate_user) { create(:no_activate_user) }
      
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
      
     it '有効化されていないユーザの場合はrootにリダイレクトすること' do
        log_in user
        get user_path(no_activate_user)
        expect(response).to redirect_to root_path
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
    
    it 'admin属性は変更できないこと' do
      # userはこの後adminユーザになるので違うユーザにしておく
      log_in user = create(:user, :another)
      expect(user).to_not be_admin
      patch user_path(user), params: { user: { password: 'password', password_confirmation: 'password', admin: true } }
      user.reload
      expect(user).to_not be_admin
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
  
  
  describe 'pagination' do
    let(:user) { create(:user) }
    before do
      30.times do
        create(:continuous_users)
      end
      log_in(user)
      get users_path
    end
    
    it 'div.paginationが存在すること' do
      expect(response.body).to include '<div role="navigation" aria-label="Pagination" class="pagination">'
    end
    
    it 'ユーザごとのリンクが存在すること' do
      User.paginate(page: 1).each do |user|
        expect(response.body).to include "<a href=\"#{user_path(user)}\">"
      end
    end
    
    it '2つのdiv.paginationが存在すること' do
      # HTMLコード内の<div class="pagination">要素を全て取得
      pagination_divs = response.body.scan('<div role="navigation" aria-label="Pagination" class="pagination">')
      
      # 2つの要素が存在することを確認
      expect(pagination_divs.length).to eq(2)
    end
  end
  
  
  describe 'DELETE /users/{id}' do
    let!(:user) { create(:user, :admin) }
    let!(:another_user) {create(:user, :another) }
    
    context '未ログインの場合' do
      it '削除できないこと' do
        expect{ delete user_path(user)}.to_not change(User, :count)
      end
      
      it 'ログインページにリダイレクトすること' do
        delete user_path(user)
        expect(response).to redirect_to login_path
      end
    end
    
    context 'adminユーザーでない場合' do
      it '削除できないこと' do
        log_in(another_user)
        expect{ delete user_path(user)}.to_not change(User, :count)
      end
      
      it 'rootにリダイレクトすること' do
        log_in(another_user)
        delete user_path(user)
        expect(response).to redirect_to root_path
      end
    end
    
    context 'adminユーザでログイン済みの場合' do
     it '削除できること' do
       log_in user
       expect { delete user_path(another_user) }.to change(User, :count).by(-1)
     end
   end
  end
  
   describe 'GET /users/{id}/following' do
     let(:user){ create(:user) }
     
     it '未ログインならログインページにリダイレクトすること' do
       get following_user_path(user)
       expect(response).to redirect_to login_path
     end
   end
   
   describe 'GET /users/{id}/followers' do
     let(:user){ create(:user) }
     
     it '未ログインならログインページにリダイレクトすること' do
       get followers_user_path(user)
       expect(response).to redirect_to login_path
     end
   end
end
