Fabricator(:user) do
  email { Faker::Internet.email }
  password '123123123'
  password_confirmation '123123123'
  role 'user'
end
