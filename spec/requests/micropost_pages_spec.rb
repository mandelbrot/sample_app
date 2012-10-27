require 'spec_helper'

describe "Micropost pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') } 
      end
    end

    describe "with valid information" do

      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end
  end

  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }

    describe "as correct user" do
      before { visit root_path }

      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end
  end

  #test for sidebar micropost counts (including proper pluralization)
  describe "should have 1 micropost" do
    let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }   
    before { visit root_path }
      it { should have_selector('span.TESTTEST', text: "1 micropost") }
      it { should_not have_selector('span.TESTTEST', text: "1 microposts") }
      it { should_not have_selector('span.TESTTEST', text: "2 micropost") }
      it { should_not have_selector('span.TESTTEST', text: "2 microposts") }
      it { should_not have_selector('span.TESTTEST', text: "0 micropost") }
      it { should_not have_selector('span.TESTTEST', text: "0 microposts") }

    describe "and 1 more" do
      let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar") }     
      before { visit root_path }
        it { should have_selector('span.TESTTEST', text: "2 microposts") }
        it { should_not have_selector('span.TESTTEST', text: "2 micropost") }
        it { should_not have_selector('span.TESTTEST', text: "1 micropost") }
        it { should_not have_selector('span.TESTTEST', text: "1 microposts") }
        it { should_not have_selector('span.TESTTEST', text: "3 micropost") }
        it { should_not have_selector('span.TESTTEST', text: "3 microposts") }
    end

    #describe "and after deleting 1" do
      #before { click_link "delete" }
      #let!(:m2) { FactoryGirl.delete(:micropost, user: user, content: "Bar") }  
      #Micropost.find(m1[:id]).destroy
      #micropost = user.microposts.first
      #micropost_dup = micropost.dup
      #micropost.destroy

      #Micropost.find_by_id(micropost_dup.id).should be_nil

      #before { visit root_path }
        #it { should have_selector('span.TESTTEST', text: "1 micropost") }
        #it { should_not have_selector('span.TESTTEST', text: "1 microposts") }
        #it { should_not have_selector('span.TESTTEST', text: "2 micropost") }
        #it { should_not have_selector('span.TESTTEST', text: "2 microposts") }
        #it { should_not have_selector('span.TESTTEST', text: "0 micropost") }
        #it { should_not have_selector('span.TESTTEST', text: "0 microposts") }
    #end
  end

  #tests for micropost pagination.
  #describe "pagination" do

    #before(:all) { 30.times { FactoryGirl.create(:user) } }
    #after(:all)  { User.delete_all }

      #it { should have_selector('div.pagination') }

      #it "should list each user" do
        #User.paginate(page: 1).each do |user|
          #page.should have_selector('li', text: user.name)
      #end
    #end
  #end
end