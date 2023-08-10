require 'rails_helper'

RSpec.describe "StaticPages", type: :system do
  before do
    driven_by(:rack_test)
  end
  
  
 
  describe "root" do
    it "root_pathへのリンクが2つ、help, about, contact, へのリンクが表示されていること" do
      visit root_path
      link_to_root = page.find_all("a[href=\"#{root_path}\"]")#ダブルクォート二つ使うのでエスケープできるように\"\"で式展開かこむ
      
      expect(link_to_root.size).to eq 2
      expect(page).to have_link "Help", href: help_path
      expect(page).to have_link "About", href: about_path
      expect(page).to have_link "Contact", href: contact_path
      expect(page).to have_link "Sign up now!", href: signup_path
    end
  end
end