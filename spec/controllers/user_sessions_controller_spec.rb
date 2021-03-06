require 'rails_helper'

describe UserSessionsController do
  render_views

  before(:each) do
    @user = FactoryBot.create :user
  end

  context "User is not logged in" do
    it "should get to the login page" do
      get :new
      expect(response).to be_successful
      expect(response.body).to have_selector("form") do |form|
        expect(form).to have_selector("input", type: "text", name: "user_session[email]")
        expect(form).to have_selector("input", type: "password", name: "user_session[password]")
      end
    end

    it "should redirect to admin after succesfull login in" do
      post :create, params: {
        user_session: { email: @user.email, password: @user.password }
      }

      expect(assigns(:user_session).user).to eq(@user)
      expect(response).to redirect_to(root_path)
    end

    it "should render the same page to admin after unsuccessfull login." do
      post :create, params: {
        user_session: { email: @user.email, password: 'pssassword' }
      }

      expect(controller.send(:current_user)).to be_nil
      expect(response).to be_successful
    end
  end
end
