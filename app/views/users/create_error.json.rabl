object false

node :errors do
  errors = {}
  @user.errors.each do |attribute, errors_array|
    errors[attribute] = errors_array
  end
end

node :info do
  'User was not created'
end

node :success do
  false
end
