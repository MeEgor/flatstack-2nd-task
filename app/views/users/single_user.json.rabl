child @user, root: "user", object_root: false do
  attributes :id, :email, :name

  node :email_confirmed do |user|
    user.email_confirmed?
  end

  node :has_email do |user|
    user.has_email?
  end

  node :has_password do |user|
    user.has_password?
  end

  node :events_count do |user|
    user.events.count
  end

  node :has_vk do |user|
    user.has_vk?
  end
end
