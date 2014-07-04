object false

child @user, root: "user", object_root: false do
  attributes :id, :email, :name

  node :email_confirmed do |user|
    user.email_confirmed?
  end

  node :events_count do |user|
    user.events.count
  end
end

node :user, :if => !@user do
  nil
end

node :info do
  'cuser'
end

node :success do
  true
end
