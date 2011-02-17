require 'spec_helper'

describe ExtentsController do
  fixtures :all

  describe "GET index" do
    before(:each) do
      Factory.create(:extent)
    end

    describe "When logged in as Administrator" do
      before(:each) do
        sign_in Factory(:admin)
      end

      it "assigns all extents as @extents" do
        get :index
        assigns(:extents).should eq(Extent.all)
      end
    end

    describe "When logged in as User" do
      before(:each) do
        sign_in Factory(:user)
      end

      it "assigns all extents as @extents" do
        get :index
        assigns(:extents).should eq(Extent.all)
      end
    end

    describe "When not logged in" do
      it "assigns all extents as @extents" do
        get :index
        assigns(:extents).should eq(Extent.all)
      end
    end
  end

  describe "GET show" do
    describe "When logged in as Administrator" do
      before(:each) do
        sign_in Factory(:admin)
      end

      it "assigns the requested extent as @extent" do
        extent = Factory.create(:extent)
        get :show, :id => extent.id
        assigns(:extent).should eq(extent)
      end
    end

    describe "When logged in as Librarian" do
      before(:each) do
        sign_in Factory(:librarian)
      end

      it "assigns the requested extent as @extent" do
        extent = Factory.create(:extent)
        get :show, :id => extent.id
        assigns(:extent).should eq(extent)
      end
    end

    describe "When logged in as User" do
      before(:each) do
        sign_in Factory(:user)
      end

      it "assigns the requested extent as @extent" do
        extent = Factory.create(:extent)
        get :show, :id => extent.id
        assigns(:extent).should eq(extent)
      end
    end

    describe "When not logged in" do
      it "assigns the requested extent as @extent" do
        extent = Factory.create(:extent)
        get :show, :id => extent.id
        assigns(:extent).should eq(extent)
      end
    end
  end

  describe "GET new" do
    describe "When logged in as Administrator" do
      before(:each) do
        sign_in Factory(:admin)
      end

      it "assigns the requested extent as @extent" do
        get :new
        assigns(:extent).should_not be_valid
        response.should be_forbidden
      end
    end

    describe "When logged in as Librarian" do
      before(:each) do
        sign_in Factory(:librarian)
      end

      it "should not assign the requested extent as @extent" do
        get :new
        assigns(:extent).should_not be_valid
        response.should be_forbidden
      end
    end

    describe "When logged in as User" do
      before(:each) do
        sign_in Factory(:user)
      end

      it "should not assign the requested extent as @extent" do
        get :new
        assigns(:extent).should_not be_valid
        response.should be_forbidden
      end
    end

    describe "When not logged in" do
      it "should not assign the requested extent as @extent" do
        get :new
        assigns(:extent).should_not be_valid
        response.should redirect_to(new_user_session_url)
      end
    end
  end

  describe "GET edit" do
    describe "When logged in as Administrator" do
      before(:each) do
        sign_in Factory(:admin)
      end

      it "assigns the requested extent as @extent" do
        extent = Factory.create(:extent)
        get :edit, :id => extent.id
        assigns(:extent).should eq(extent)
      end
    end

    describe "When logged in as Librarian" do
      before(:each) do
        sign_in Factory(:librarian)
      end

      it "assigns the requested extent as @extent" do
        extent = Factory.create(:extent)
        get :edit, :id => extent.id
        response.should be_forbidden
      end
    end

    describe "When logged in as User" do
      before(:each) do
        sign_in Factory(:user)
      end

      it "assigns the requested extent as @extent" do
        extent = Factory.create(:extent)
        get :edit, :id => extent.id
        response.should be_forbidden
      end
    end

    describe "When not logged in" do
      it "should not assign the requested extent as @extent" do
        extent = Factory.create(:extent)
        get :edit, :id => extent.id
        response.should redirect_to(new_user_session_url)
      end
    end
  end

  describe "POST create" do
    before(:each) do
      @attrs = Factory.attributes_for(:extent)
      @invalid_attrs = {:name => ''}
    end

    describe "When logged in as Administrator" do
      before(:each) do
        sign_in Factory(:admin)
      end

      describe "with valid params" do
        it "assigns a newly created extent as @extent" do
          post :create, :extent => @attrs
          assigns(:extent).should be_valid
        end

        it "should be forbidden" do
          post :create, :extent => @attrs
          response.should be_forbidden
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved extent as @extent" do
          post :create, :extent => @invalid_attrs
          assigns(:extent).should_not be_valid
        end

        it "should be forbidden" do
          post :create, :extent => @invalid_attrs
          response.should be_forbidden
        end
      end
    end

    describe "When not logged in" do
      describe "with valid params" do
        it "assigns a newly created extent as @extent" do
          post :create, :extent => @attrs
          assigns(:extent).should be_valid
        end

        it "should be forbidden" do
          post :create, :extent => @attrs
          response.should redirect_to(new_user_session_url)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved extent as @extent" do
          post :create, :extent => @invalid_attrs
          assigns(:extent).should_not be_valid
        end

        it "should be forbidden" do
          post :create, :extent => @invalid_attrs
          response.should redirect_to(new_user_session_url)
        end
      end
    end
  end

  describe "PUT update" do
    before(:each) do
      @extent = Factory(:extent)
      @attrs = Factory.attributes_for(:extent)
      @invalid_attrs = {:name => ''}
    end

    describe "When logged in as Administrator" do
      before(:each) do
        sign_in Factory(:admin)
      end

      describe "with valid params" do
        it "updates the requested extent" do
          put :update, :id => @extent.id, :extent => @attrs
        end

        it "assigns the requested extent as @extent" do
          put :update, :id => @extent.id, :extent => @attrs
          assigns(:extent).should eq(@extent)
        end
      end

      describe "with invalid params" do
        it "assigns the requested extent as @extent" do
          put :update, :id => @extent.id, :extent => @invalid_attrs
          response.should render_template("edit")
        end
      end
    end

    describe "When logged in as Librarian" do
      before(:each) do
        sign_in Factory(:librarian)
      end

      describe "with valid params" do
        it "updates the requested extent" do
          put :update, :id => @extent.id, :extent => @attrs
        end

        it "assigns the requested extent as @extent" do
          put :update, :id => @extent.id, :extent => @attrs
          assigns(:extent).should eq(@extent)
          response.should be_forbidden
        end
      end

      describe "with invalid params" do
        it "assigns the requested extent as @extent" do
          put :update, :id => @extent.id, :extent => @invalid_attrs
          response.should be_forbidden
        end
      end
    end

    describe "When logged in as User" do
      before(:each) do
        sign_in Factory(:user)
      end

      describe "with valid params" do
        it "updates the requested extent" do
          put :update, :id => @extent.id, :extent => @attrs
        end

        it "assigns the requested extent as @extent" do
          put :update, :id => @extent.id, :extent => @attrs
          assigns(:extent).should eq(@extent)
          response.should be_forbidden
        end
      end

      describe "with invalid params" do
        it "assigns the requested extent as @extent" do
          put :update, :id => @extent.id, :extent => @invalid_attrs
          response.should be_forbidden
        end
      end
    end

    describe "When not logged in" do
      describe "with valid params" do
        it "updates the requested extent" do
          put :update, :id => @extent.id, :extent => @attrs
        end

        it "should be forbidden" do
          put :update, :id => @extent.id, :extent => @attrs
          response.should redirect_to(new_user_session_url)
        end
      end

      describe "with invalid params" do
        it "assigns the requested extent as @extent" do
          put :update, :id => @extent.id, :extent => @invalid_attrs
          response.should redirect_to(new_user_session_url)
        end
      end
    end
  end

  describe "DELETE destroy" do
    before(:each) do
      @extent = Factory(:extent)
    end

    describe "When logged in as Administrator" do
      before(:each) do
        sign_in Factory(:admin)
      end

      it "destroys the requested extent" do
        delete :destroy, :id => @extent.id
      end

      it "should be forbidden" do
        delete :destroy, :id => @extent.id
        response.should be_forbidden
      end
    end

    describe "When logged in as Librarian" do
      before(:each) do
        sign_in Factory(:librarian)
      end

      it "destroys the requested extent" do
        delete :destroy, :id => @extent.id
      end

      it "should be forbidden" do
        delete :destroy, :id => @extent.id
        response.should be_forbidden
      end
    end

    describe "When logged in as User" do
      before(:each) do
        sign_in Factory(:user)
      end

      it "destroys the requested extent" do
        delete :destroy, :id => @extent.id
      end

      it "should be forbidden" do
        delete :destroy, :id => @extent.id
        response.should be_forbidden
      end
    end

    describe "When not logged in" do
      it "destroys the requested extent" do
        delete :destroy, :id => @extent.id
      end

      it "should be forbidden" do
        delete :destroy, :id => @extent.id
        response.should redirect_to(new_user_session_url)
      end
    end
  end
end
