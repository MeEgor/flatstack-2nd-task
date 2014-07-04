object false

child @user, root: "user", object_root: false do
  attributes :id, :email, :name

  node :email_confirmed do |user|
    user.email_confirmed?
  end
end

node :info do
  'Email confirmation success'
end

node :success do
  true
end
