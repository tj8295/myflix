require 'spec_helper'

describe UsersController do

  describe "GET new" do
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do
    context "with valid user input" do
      before do
        post :create, user: Fabricate.attributes_for(:user)
      end

      it "creates @user in db on valid input" do
        expect(User.count).to eq(1)
      end

      it "redirects to home_path on valid input" do
        expect(response).to redirect_to home_path
      end
    end

    context "with invalid user input" do
      before do
        post :create, user: { email: " "}
      end

      it "does not create @user in db on invalid input" do
        expect(User.count).to eq(0)
      end

      it "renders :new template on invalid input" do
        expect(response).to render_template :new
      end
      it "sets @user variable" do
        expect(assigns(:user)).to be_instance_of(User)
      end
    end
  end

  describe "GET show" do
    it "sets the @user" do
      alice = Fabricate(:user)
      set_current_user(alice)
      queue_item1 = Fabricate(:queue_item, user: alice)
      queue_item2 = Fabricate(:queue_item, user: alice)
      get :show, id: alice.id
      expect(assigns(:user)).to eq(alice)
    end

    it_behaves_like "require_sign_in" do
      let(:action) { get :show, id: 3 }
    end
  end
end

