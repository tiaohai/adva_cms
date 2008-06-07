require File.dirname(__FILE__) + '/../spec_helper'


describe 'Roles: ' do
  include Stubby
  
  before :each do     
    scenario :roles
  end
  
  describe '#has_role?' do
    describe 'a user' do  
      it "has the role :user" do
        @user.has_role?(:user).should_not be_nil
      end
  
      it "has the role :author for another user's content" do
        @user.has_role?(:author, @content).should be_nil
      end
  
      it "does not have the role :moderator" do
        @user.has_role?(:moderator, @section).should be_nil
      end
  
      it "does not have the role :admin" do
        @user.has_role?(:admin, @site).should be_nil
      end
  
      it "does not have the role :superuser" do
        @user.has_role?(:superuser).should be_nil
      end
    end  
  
    describe 'a content author' do
      it "has the role :user" do
        @author.has_role?(:user).should_not be_nil
      end
  
      it 'has the role :author for that content' do
        @author.has_role?(:author, @content).should_not be_nil
      end
  
      it "does not have the role :moderator" do
        @author.has_role?(:moderator, @section).should be_nil
      end
  
      it "does not have the role :admin" do
        @author.has_role?(:admin, @site).should be_nil
      end
  
      it "does not have the role :superuser" do
        @author.has_role?(:superuser).should be_nil
      end
    end
  
    describe 'a section moderator' do
      it "has the role :user" do
        @moderator.has_role?(:user).should_not be_nil
      end
  
      it "has the role :author for another user's content" do
        @moderator.has_role?(:author, @content).should_not be_nil
      end
  
      it "has the role :moderator for that section" do
        @moderator.has_role?(:moderator, @section).should_not be_nil
      end
  
      it "does not have the role :admin" do
        @moderator.has_role?(:admin, @site).should be_nil
      end
  
      it "does not have the role :superuser" do
        @moderator.has_role?(:superuser).should be_nil
      end
    end  
  
    describe 'a site admin' do
      it "has the role :user" do
        @admin.has_role?(:user).should_not be_nil
      end
  
      it "has the role :author for another user's content" do
        @admin.has_role?(:author, @content).should_not be_nil
      end
  
      it "has the role :moderator for sections belonging to that site" do
        @admin.has_role?(:moderator, @section).should_not be_nil
      end
  
      it "has the role :site for that site" do
        @admin.has_role?(:admin, @site).should_not be_nil
      end  
  
      it "does not have the role :superuser" do
        @admin.has_role?(:superuser).should be_nil
      end
    end  
  
    describe 'a superuser' do
      it "has the role :user" do
        @superuser.has_role?(:user).should_not be_nil
      end
  
      it "has the role :author for another user's content" do
        @superuser.has_role?(:author, @content).should_not be_nil
      end
  
      it "has the role :moderator for sections belonging to that site" do
        @superuser.has_role?(:moderator, @section).should_not be_nil
      end
  
      it "has the role :site for that site" do
        @superuser.has_role?(:admin, @site).should_not be_nil
      end
  
      it "has the role :superuser" do
        @superuser.has_role?(:superuser).should_not be_nil
      end
    end
  end
  
  describe "#permissions (class method)" do
    it "inverts passed permissions hash and merges it to default_permissions" do
    end
    
    it "expands :all to [:show, :create, :update, :delete]" do
    end
  end

  describe '#role_authorizing (with default_permissions)' do
    describe 'on a site' do
      it 'returns a superuser role for the :create action' do
        @site.role_authorizing(:create).should == @superuser_role
      end

      it 'returns a superuser role for the :create action' do
        @site.role_authorizing(:update).should == @admin_role
      end

      it 'returns a superuser role for the :create action' do
        @site.role_authorizing(:delete).should == @superuser_role
      end
    end

    describe 'on a section' do
      it 'returns an admin role for the :create action' do
        @section.role_authorizing(:create).should == @admin_role
      end

      it 'returns an admin role for the :create action' do
        @section.role_authorizing(:update).should == @admin_role
      end

      it 'returns an admin role for the :create action' do
        @section.role_authorizing(:delete).should == @admin_role
      end
    end
    
    # @content.role_authorizing(:manage_articles).should == @moderator_role
    # @wikipage.role_authorizing(:manage_wikipages).should == @user_role
  end
  
  describe '#expand' do
    it 'works' do
      @author_role.expand.should == [@author_role, @moderator_role, @admin_role]
      @moderator_role.expand.should == [@moderator_role, @admin_role]
      @admin_role.expand.should == [@admin_role]
    end
  end
  
  { Role::User      => 'You need to be logged in to perform this action.',
    Role::Author    => 'You need to be the author of this object to perform this action.',
    Role::Moderator => 'You need to be a moderator to perform this action.',
    Role::Admin     => 'You need to be an admin to perform this action.',
    Role::Superuser => 'You need to be a superuser to perform this action.' }.each do |role, message|
  
    it "#{Role}#message returns '#{message}'" do
      role.new.message.should == message
    end
  end
  
  
  # describe 'User.roles.for' do
  #   it 'works' do
  #   end
  # end
end