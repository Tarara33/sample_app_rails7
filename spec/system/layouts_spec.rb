require 'rails_helper'

RSpec.describe "Layouts", type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:user) { create(:user) }
  
  describe 'header' do
    context 'ログイン済みの場合' do
      before do
        log_in(user)
        visit root_path
      end
      
      it 'titleをクリックするとrootに遷移する' do
        click_link 'sample app'
        expect(current_path).to eq root_path
      end
      
      it 'Homeをクリックするとrootに遷移する' do
        click_link 'Home'
        expect(current_path).to eq root_path
      end
      
      it 'HelpをクリックするとHelpページに遷移する' do
        click_link 'Help'
        expect(current_path).to eq help_path
      end
      
      it 'Usersをクリックするとユーザー一覧ページに遷移する' do
        click_link 'Users'
        expect(current_path).to eq users_path
      end
      
      context 'Account' do
        before do
          click_link 'Account'
        end
        
        it 'Profileをクリックするとユーザー詳細ページに遷移する' do
          click_link 'Profile'
          expect(current_path).to eq user_path(user)
        end
        
        it 'Settingsをクリックするとユーザー編集ページに遷移する' do
          click_link 'Settings'
          expect(current_path).to eq edit_user_path(user)
        end
        
        it 'Log outをクリックするとログアウトしてrootに遷移する' do
          click_link 'Log out'
          expect(current_path).to eq root_path
        end
      end
    end
  end
  
  
  describe '未ログインの場合' do
    before do
      visit root_path
    end
    
    it 'titleをクリックするとrootに遷移する' do
        click_link 'sample app'
        expect(current_path).to eq root_path
    end
    
    it 'Homeをクリックするとrootに遷移する' do
      click_link 'Home'
      expect(current_path).to eq root_path
    end
    
    it 'HelpをクリックするとHelpページに遷移する' do
      click_link 'Help'
      expect(current_path).to eq help_path
    end
    
    it 'Log inをクリックするとログインページに遷移する' do
      click_link 'Log in'
      expect(current_path).to eq login_path
    end
  end
  
  
  describe 'footer' do
    context 'ログイン済みの場合' do
      before do
        log_in(user)
        visit root_path
      end
      
      it 'Aboutをクリックするとaboutページに遷移すること' do
        click_link 'About'
        expect(page.current_path).to eq about_path
      end
      
      it 'Contactをクリックするとcontactページに遷移すること' do
        click_link 'Contact'
        expect(page.current_path).to eq contact_path
      end
    end
    
    context '未ログインの場合' do
      before do
        visit root_path
      end
      
      it 'Aboutをクリックするとaboutページに遷移すること' do
        click_link 'About'
        expect(page.current_path).to eq about_path
      end
      
      it 'Contactをクリックするとcontactページに遷移すること' do
        click_link 'Contact'
        expect(page.current_path).to eq contact_path
      end 
    end
  end
end
