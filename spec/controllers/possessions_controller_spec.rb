require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe PossessionsController do
  let(:user) { User.new }
  let(:possession) { Possession.new }
  let(:possessions) { Object.new }
  let(:id) { 99.to_param }
  before :each do
    allow_message_expectations_on_nil
    ApplicationController.any_instance.stub(:current_user).and_return user
    request.env['warden'].stub(:authenticate!).and_return user
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # PossessionsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all possessions as @possessions" do
      user.should_receive(:possessions).and_return [possession]
      user.should_receive(:labels).and_return []
      get :index, {}, valid_session
      assigns(:possessions).should eq([possession])
      assigns(:labels).should eq []
    end
  end

  describe "GET show" do
    before :each do
      user.should_receive(:possessions).and_return possessions
      @find_mock = possessions.should_receive(:find).with(id)
    end
    it "assigns the requested possession as @possession" do
      @find_mock.and_return possession
      get :show, {id: id}, valid_session
      assigns(:possession).should eq(possession)
    end
    it "will redirect to possessions path if cannot find a possesion" do
      @find_mock.and_raise Mongoid::Errors::DocumentNotFound.new Object, {}
      get :show, {id: id}, valid_session
      response.should redirect_to possessions_url
    end
  end

  describe "GET new" do
    it "assigns a new possession as @possession" do
      user.should_receive(:possessions).and_return user
      user.should_receive(:build).and_return possession
      get :new, {}, valid_session
      assigns(:possession).should be_a_new(Possession)
    end
  end
  
  describe "GET edit" do
    it "assigns the requested possession as @possession" do
      user.should_receive(:possessions).and_return possessions
      possessions.should_receive(:find).with(id).and_return possession
      get :edit, {id: id}, valid_session
      assigns(:possession).should eq(possession)
    end
  end
  
  describe "POST create" do
    before :each do
      user.should_receive(:possessions).and_return user
      user.should_receive(:build).with({}).and_return possession
      @save_mock = possession.should_receive(:save)
    end
    it "can create with valid params" do
      @save_mock.and_return true
      post :create, {possession: {}}, valid_session
      assigns(:possession).should be_a(Possession)
      response.status.should eq(302)
    end
    it "cannot create with invalid params" do
      @save_mock.and_return(false)
      post :create, {possession: {}}, valid_session
      response.should render_template("new")
    end
  end
   
  describe "PUT update" do
    before :each do
      user.should_receive(:possessions).and_return possessions
      possessions.should_receive(:find).with(id).and_return possession
    end
    it "with valid params can update" do
      params = { "these" => "params" }
      possession.should_receive(:update_attributes).with(params).and_return true
      put :update, {id: id, possession: params}, valid_session
      assigns(:possession).should eq(possession)
      response.status.should eq(302)
    end
    it "with invalid params cannot update" do
      params = { "these" => "params" }
      possession.should_receive(:update_attributes).with(params).and_return false
      put :update, {id: id, possession: params}, valid_session
      assigns(:possession).should eq(possession)
      response.should render_template("edit")
    end
  end
  
  describe "DELETE destroy" do
    it "destroys the requested possession" do
      user.should_receive(:possessions).and_return possessions
      possessions.should_receive(:find).with(id).and_return possession
      possession.should_receive(:destroy)
      delete :destroy, {id: id}, valid_session
      response.should redirect_to(possessions_url)
    end
  end
end
