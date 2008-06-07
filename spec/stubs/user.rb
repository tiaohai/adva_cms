define Anonymous do
  methods  :has_role? => false, 
           :anonymous? => true,
           :registered? => false,
           :update_attributes => true, 
           :destroy => true

  instance :user,
           :id => 1,
           :name => 'name', 
           :email => 'foo@bar.baz',
           :homepage => 'http://foo.bar.baz'
end

define User do
  has_many :roles
  
  methods  :has_role? => false, 
           :has_exact_role? => false,
           :anonymous? => false,
           :registered? => true,
           :update_attributes => true, 
           :destroy => true,
           :verified! => nil,
           :assign_token => 'token'

  instance :user,
           :id => 1,
           :name => 'name', 
           :email => 'foo@bar.baz',
           :homepage => 'http://foo.bar.baz',
           :login => 'login',
           :password => 'password',
           :password_confirmation => 'password',
           :created_at => Time.now,
           :updated_at => Time.now,
           :deleted_at => nil
end

scenario :user do
  @user = stub_user
  @users = stub_users
  
  User.stub!(:new).and_return @user
  User.stub!(:find).and_return @user
  User.stub!(:create_superuser).and_return @user
  User.stub!(:paginate).and_return @users
  Site.stub!(:paginate_users_and_superusers).and_return @users
end
