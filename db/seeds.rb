STATUSES = ["draft", "new", "approved", "published", "archive", "rejected"]

type1 = AdType.create(name: "selling")
type2 = AdType.create(name: "rent")
type3 = AdType.create(name: "exchange")
type4 = AdType.create(name: "test")

admin = User.create(email: "admin@admin.com", password: "adminadminadmin", password_confirmation: "adminadminadmin", role: "admin")
user = User.create(email: "user@user.com", password: "useruseruser", password_confirmation: "useruseruser")
user2 = User.create(email: "user2@user.com", password: "user2user2user2", password_confirmation: "user2user2user2")

admin.avatar = Image.create(file: File.new("#{Rails.root}/vendor/assets/images/web-app-theme/avatar.png"))
user.avatar = Image.create(file: File.new("#{Rails.root}/vendor/assets/images/web-app-theme/avatar.png"))
user2.avatar = Image.create(file: File.new("#{Rails.root}/vendor/assets/images/web-app-theme/avatar.png"))

15.times.each do |i|
  ad = user.ads.create(title: "title ##{i}", text: "text ##{i}"*10, price: rand(0..10000), ad_type_id: type1.id, status: STATUSES.sample)
  ad.images.create(file: File.new("#{Rails.root}/public/images/#{rand(1..5)}.jpg"))
end

15.times.each do |i|
  ad = user.ads.create(title: "title ##{i}", text: "text ##{i}"*10, price: rand(0..10000), ad_type_id: type2.id, status: STATUSES.sample)
  ad.images.create(file: File.new("#{Rails.root}/public/images/#{rand(1..5)}.jpg"))
end

15.times.each do |i|
  ad = user.ads.create(title: "title ##{i}", text: "text ##{i}"*10, price: rand(0..10000), ad_type_id: type3.id, status: STATUSES.sample)
  ad.images.create(file: File.new("#{Rails.root}/public/images/#{rand(1..5)}.jpg"))
end
