set :environment, 'development'

every :day, :at => '11:50pm' do
  runner "Ad.with_status(:published).each {|ad| ad.in_archive if (Time.zone.now - ad.updated_at) >= 3.days }"
end

every :day, :at => '0am' do
  runner "Ad.with_status(:approved).each {|ad| ad.publish}"
end

every :monday, :at => '12am' do
  runner "Ad.counter_culture_fix_counts"
end
