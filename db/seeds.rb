STATUSES = ["draft", "new", "approved", "published", "archive", "rejected"]

type1 = AdType.create(name: "selling")
type2 = AdType.create(name: "test")

admin = User.create(email: "admin@admin.com", password: "adminadminadmin", password_confirmation: "adminadminadmin", role: "admin")
user = User.create(email: "user@user.com", password: "useruseruser", password_confirmation: "useruseruser")

20.times.each do |i|
  ad = user.ads.create(title: "title ##{i}", text: "text ##{i}"*10, price: rand(0..10000), ad_type_id: type1.id, status: STATUSES.sample)
  ad.images.create(file: File.new("#{Rails.root}/public/images/#{rand(1..5)}.jpg"))
end