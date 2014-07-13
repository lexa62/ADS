Fabricator(:ad) do
  title { Faker::Lorem.sentence }
  text { Faker::Lorem.paragraph }
  price { Faker::Number.number(4) }
  status 'draft'
end
