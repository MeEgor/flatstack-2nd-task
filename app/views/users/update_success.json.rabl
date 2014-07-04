object false

child @user, root: "user", object_root: false do
  attributes :id, :email, :name

  node :email_confirmed do |user|
    user.email_confirmed?
  end
end

node :info do
  'User updaed'
end

node :success do
  true
end
