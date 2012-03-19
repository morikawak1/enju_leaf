require 'spec_helper'

describe AcceptsController do
  fixtures :all

  def mock_user(stubs={})
    (@mock_user ||= mock_model(Accept).as_null_object).tap do |user|
      user.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET index" do
    describe "When logged in as Administrator" do
      login_fixture_admin

      it "assigns nil as @accepts" do
        get :index
        assigns(:accepts).should be_nil
        response.should redirect_to(basket_accepts_url(assigns(:basket)))
      end

      describe "When basket_id is specified" do
        it "assigns all accepts as @accepts" do
          get :index, :basket_id => 10
          assigns(:accepts).should eq Basket.find(10).accepts
          response.should be_success
        end
      end
    end

    describe "When logged in as Librarian" do
      login_fixture_librarian

      it "assigns nil as @accepts" do
        get :index
        assigns(:accepts).should be_nil
        response.should redirect_to(basket_accepts_url(assigns(:basket)))
      end

      describe "When basket_id is specified" do
        it "assigns all accepts as @accepts" do
          get :index, :basket_id => 9
          assigns(:accepts).should eq Basket.find(9).accepts
          response.should be_success
        end
      end
    end

    describe "When logged in as User" do
      login_fixture_user

      it "should not assign all accepts as @accepts" do
        get :index
        assigns(:accepts).should be_nil
        response.should be_forbidden
      end
    end
  end

  describe "GET show" do
    describe "When logged in as Administrator" do
      login_fixture_admin

      it "assigns the requested accept as @accept" do
        accept = FactoryGirl.create(:accept)
        get :show, :id => accept.id
        assigns(:accept).should eq(accept)
      end

      it "should not show missing accept" do
        get :show, :id => 'missing'
        response.should be_missing
      end
    end

    describe "When logged in as Librarian" do
      login_fixture_librarian

      it "assigns the requested accept as @accept" do
        accept = FactoryGirl.create(:accept)
        get :show, :id => accept.id
        assigns(:accept).should eq(accept)
      end
    end

    describe "When logged in as User" do
      login_fixture_user

      it "assigns the requested accept as @accept" do
        accept = FactoryGirl.create(:accept)
        get :show, :id => accept.id
        assigns(:accept).should eq(accept)
        response.should be_forbidden
      end
    end

    describe "When not logged in" do
      it "assigns the requested accept as @accept" do
        accept = FactoryGirl.create(:accept)
        get :show, :id => accept.id
        assigns(:accept).should eq(accept)
        response.should redirect_to new_user_session_url
      end
    end
  end

  describe "GET new" do
    describe "When logged in as Administrator" do
      login_fixture_admin

      it "assigns the requested accept as @accept" do
        get :new
        assigns(:accept).should_not be_valid
      end
    end

    describe "When logged in as Librarian" do
      login_fixture_librarian

      it "assigns the requested accept as @accept" do
        get :new
        assigns(:accept).should_not be_valid
      end
    end

    describe "When logged in as User" do
      login_fixture_user

      it "should not assign the requested accept as @accept" do
        get :new
        assigns(:accept).should_not be_valid
        response.should be_forbidden
      end
    end

    describe "When not logged in" do
      it "should not assign the requested accept as @accept" do
        get :new
        assigns(:accept).should_not be_valid
        response.should redirect_to(new_user_session_url)
      end
    end
  end

  describe "GET edit" do
    describe "When logged in as Administrator" do
      login_fixture_admin

      it "assigns the requested accept as @accept" do
        accept = FactoryGirl.create(:accept)
        get :edit, :id => accept.id
        assigns(:accept).should eq(accept)
      end
  
      it "should not edit missing accept" do
        get :edit, :id => 'missing'
        response.should be_missing
      end
    end

    describe "When logged in as Librarian" do
      login_fixture_librarian

      it "assigns the requested accept as @accept" do
        accept = FactoryGirl.create(:accept)
        get :edit, :id => accept.id
        assigns(:accept).should eq(accept)
      end
    end

    describe "When logged in as User" do
      login_fixture_user

      it "assigns the requested accept as @accept" do
        accept = FactoryGirl.create(:accept)
        get :edit, :id => accept.id
        response.should be_forbidden
      end
    end

    describe "When not logged in" do
      it "should not assign the requested accept as @accept" do
        accept = FactoryGirl.create(:accept)
        get :edit, :id => accept.id
        response.should redirect_to(new_user_session_url)
      end
    end
  end

  describe "POST create" do
    before(:each) do
      @attrs = {:item_identifier => '00003'}
      @invalid_attrs = {:item_identifier => 'invalid'}
    end

    describe "When logged in as Administrator" do
      login_fixture_admin

      describe "with valid params" do
        it "assigns a newly created accept as @accept" do
          post :create, :accept => @attrs
          assigns(:accept).should be_valid
        end

        it "redirects to index" do
          post :create, :accept => @attrs
          response.should redirect_to(basket_accepts_url(assigns(:basket)))
          assigns(:accept).item.circulation_status.name.should eq 'Available On Shelf'
        end

        describe "When basket_id is specified" do
          it "redirects to the created accept" do
            post :create, :accept => @attrs, :basket_id => 9
            response.should redirect_to(basket_accepts_url(assigns(:accept).basket))
            assigns(:accept).item.circulation_status.name.should eq 'Available On Shelf'
          end
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved accept as @accept" do
          post :create, :accept => @invalid_attrs
          assigns(:accept).should_not be_valid
        end

        it "redirects to the list" do
          post :create, :accept => @invalid_attrs
          response.should redirect_to(basket_accepts_url(assigns(:accept).basket))
        end
      end

      it "should not create accept without item_id" do
        post :create, :accept => {:item_identifier => nil}, :basket_id => 9
        assigns(:accept).should_not be_valid
        response.should redirect_to basket_accepts_url(assigns(:basket))
      end
    end

    describe "When logged in as Librarian" do
      login_fixture_librarian

      describe "with valid params" do
        it "assigns a newly created accept as @accept" do
          post :create, :accept => @attrs
          assigns(:accept).should be_valid
          assigns(:accept).item.circulation_status.name.should eq 'Available On Shelf'
        end
      end
    end

    describe "When logged in as User" do
      login_fixture_user

      describe "with valid params" do
        it "assigns a newly created accept as @accept" do
          post :create, :accept => @attrs
          assigns(:accept).should_not be_valid
        end

        it "should be forbidden" do
          post :create, :accept => @attrs
          response.should be_forbidden
        end
      end
    end

    describe "When not logged in" do
      before(:each) do
        @attrs = {:item_identifier => '00003'}
        @invalid_attrs = {:item_identifier => 'invalid'}
      end

      describe "with valid params" do
        it "assigns a newly created accept as @accept" do
          post :create, :accept => @attrs
        end

        it "should redirect to new session url" do
          post :create, :accept => @attrs
          response.should redirect_to new_user_session_url
        end
      end
    end
  end

  describe "PUT update" do
    before(:each) do
      @accept = FactoryGirl.create(:accept)
      @attrs = {:item_identifier => @accept.item.item_identifier, :librarian_id => FactoryGirl.create(:librarian).id}
      @invalid_attrs = {:item_id => ''}
    end

    describe "When logged in as Administrator" do
      login_fixture_admin

      describe "with valid params" do
        it "updates the requested accept" do
          put :update, :id => @accept.id, :accept => @attrs
        end

        it "assigns the requested accept as @accept" do
          put :update, :id => @accept.id, :accept => @attrs
          assigns(:accept).should eq(@accept)
          response.should redirect_to(@accept)
        end
      end

      describe "with invalid params" do
        it "assigns the requested accept as @accept" do
          put :update, :id => @accept.id, :accept => @invalid_attrs
        end

        it "re-renders the 'edit' template" do
          put :update, :id => @accept.id, :accept => @invalid_attrs
          response.should redirect_to @accept
        end

        it "should not update accept without item_id" do
          put :update, :id => @accept.id, :accept => @attrs.merge(:item_id => nil)
          assigns(:accept).should be_valid
          response.should redirect_to @accept
        end
      end

      it "should not update missing accept" do
        put :update, :id => 'missing', :accept => { }
        response.should be_missing
      end
    end

    describe "When logged in as Librarian" do
      login_fixture_librarian

      describe "with valid params" do
        it "updates the requested accept" do
          put :update, :id => @accept.id, :accept => @attrs
        end

        it "assigns the requested accept as @accept" do
          put :update, :id => @accept.id, :accept => @attrs
          assigns(:accept).should eq(@accept)
          response.should redirect_to(@accept)
        end
      end

      describe "with invalid params" do
        it "assigns the accept as @accept" do
          put :update, :id => @accept.id, :accept => @invalid_attrs
          assigns(:accept).should be_valid
        end

        it "re-renders the 'edit' template" do
          put :update, :id => @accept.id, :accept => @invalid_attrs
          response.should redirect_to @accept
        end
      end
    end

    describe "When logged in as User" do
      login_fixture_user

      describe "with valid params" do
        it "updates the requested accept" do
          put :update, :id => @accept.id, :accept => @attrs
        end

        it "assigns the requested accept as @accept" do
          put :update, :id => @accept.id, :accept => @attrs
          assigns(:accept).should eq(@accept)
          response.should be_forbidden
        end
      end

      describe "with invalid params" do
        it "assigns the requested accept as @accept" do
          put :update, :id => @accept.id, :accept => @invalid_attrs
          response.should be_forbidden
        end
      end
    end

    describe "When not logged in" do
      describe "with valid params" do
        it "updates the requested accept" do
          put :update, :id => @accept.id, :accept => @attrs
        end

        it "should be forbidden" do
          put :update, :id => @accept.id, :accept => @attrs
          response.should redirect_to(new_user_session_url)
        end
      end

      describe "with invalid params" do
        it "assigns the requested accept as @accept" do
          put :update, :id => @accept.id, :accept => @invalid_attrs
          response.should redirect_to(new_user_session_url)
        end
      end
    end
  end

  describe "DELETE destroy" do
    before(:each) do
      @accept = FactoryGirl.create(:accept)
    end

    describe "When logged in as Administrator" do
      login_fixture_admin

      it "destroys the requested accept" do
        delete :destroy, :id => @accept.id
      end

      it "redirects to the accepts list" do
        delete :destroy, :id => @accept.id
        response.should redirect_to(accepts_url)
      end

      it "should not destroy missing accept" do
        delete :destroy, :id => 'missing'
        response.should be_missing
      end
    end

    describe "When logged in as Librarian" do
      login_fixture_librarian

      it "destroys the requested accept" do
        delete :destroy, :id => @accept.id
      end

      it "redirects to the accepts list" do
        delete :destroy, :id => @accept.id
        response.should redirect_to(accepts_url)
      end
    end

    describe "When logged in as User" do
      login_fixture_user

      it "destroys the requested accept" do
        delete :destroy, :id => @accept.id
      end

      it "should be forbidden" do
        delete :destroy, :id => @accept.id
        response.should be_forbidden
      end
    end

    describe "When not logged in" do
      it "destroys the requested accept" do
        delete :destroy, :id => @accept.id
      end

      it "should be forbidden" do
        delete :destroy, :id => @accept.id
        response.should redirect_to(new_user_session_url)
      end
    end
  end
end
