# -*- encoding: utf-8 -*-
require 'spec_helper'

describe "profiles/show" do
  fixtures :all

  before(:each) do
    @profile = assign(:profile, profiles(:admin))
    view.stub(:current_user).and_return(User.find('enjuadmin'))
  end

  it "renders attributes in <p>" do
    allow(view).to receive(:policy).and_return double(update?: true, destroy?: true)
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Checkout/)
  end

  describe "when logged in as Librarian" do
    before(:each) do
      @profile = assign(:profile, profiles(:librarian2))
      user = users(:librarian1)
      view.stub(:current_user).and_return(user)
    end

    it "cannot be deletable by other librarian" do
      render
      @ability.should_not be_able_to( :destroy, @profile )
    end
  end
end
