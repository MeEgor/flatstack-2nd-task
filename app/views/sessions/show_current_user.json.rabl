object false

child @user, root: "user", object_root: false do
  attributes :id, :email, :name

  node :email_confirmed do |user|
    user.email_confirmed?
  end
end

node :user, :if => !@user do
  nil
end

node :info do
  'current user'
end

node :success do
  true
end
