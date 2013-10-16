require 'spec_helper'

describe "Static pages" do

  subject { page }

  describe "Home page" do

    it "should have the h1 'Sample App'" do
      visit root_path
      expect(page).to have_content('Sample App')
    end

    it "should have the base title" do
      visit root_path
      expect(page).to have_title("Ruby on Rails Tutorial Sample App")
    end

    it "should not have a custom page title" do
      visit root_path
      expect(page).not_to have_title('Home')
    end

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem Ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      it "shoud render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end

      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }

        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
      end

      it "should have correct micropost count" do
        expect(page).to have_content("2 microposts")
      end

      describe "with lots of posts" do

        before do
          40.times { FactoryGirl.create(:micropost, user: user, content: "Lorem Ipsum") }
          sign_in user
          visit root_path
        end

        it "should have pagination" do
          expect(page).to have_selector("div.pagination")
        end
      end

      describe "viewing another users posts" do

        let(:user2) { FactoryGirl.create(:user) }
        before do
          FactoryGirl.create(:micropost, user: user2, content: "Lorem Ipsum")
          FactoryGirl.create(:micropost, user: user2, content: "Dolor sit amet")
          sign_in user
          visit user_path(user2)
        end

        it "should not have delete link" do
          expect(page).to have_content(user2.name)
          expect(page).not_to have_selector("a.delete-micropost")
        end
      end
    end
  end

  describe "Help page" do

    it "should have the h1 'Help'" do
      visit help_path
      expect(page).to have_content('Help')
    end

    it "should have the title 'Help'" do
      visit help_path
      expect(page).to have_title("Help")
    end
  end

  describe "About page" do

    it "should have the h1 'About Us'" do
      visit about_path
      expect(page).to have_content('About Us')
    end

    it "should have the title 'About Us'" do
      visit about_path
      expect(page).to have_title("About Us")
    end
  end

  describe "Contact page" do

    it "should have the content 'Contact'" do
      visit contact_path
      expect(page).to have_content('Contact')
    end

    it "should have the title 'Contact'" do
      visit contact_path
      expect(page).to have_title("Contact")
    end
  end
end