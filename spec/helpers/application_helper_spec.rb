require "rails_helper"

RSpec.describe "ApplicationHelper", type: :helper do
  
  describe "full_title" do
    let(:base_title) {"Ruby on Rails Tutorial Sample App"}
    
    context "引数がない場合" do
      it "base_titleのみ返す" do
        expect(full_title("")).to eq("#{base_title}")
      end
    end
    
    context "引数がある場合" do
      it "引数の文字列とbase_titleが返る" do
        expect(full_title("Page Title")).to eq("Page Title | #{base_title}")
      end
    end 
  end
end