object false

child @user, root: "user", object_root: false do
  attributes :id, :email, :name

  node :email_confirmed do |user|
    user.email_confirmed?
  end
end

node :errors do
  errors = {}
  @user.errors.each do |attribute, errors_array|
    errors[attribute] = errors_array
  end
end

node :info do
  'Email confirmation error'
end

node :success do
  false
end
