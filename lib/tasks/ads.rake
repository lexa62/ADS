namespace :ads do
  desc "Archive all ads that published 3 days ago"
  task archive: :environment do
    Ad.with_status(:published).find_each {|ad| ad.in_archive if (Time.zone.now - ad.updated_at) >= 3.days }
  end

  desc "Publish all approved ads"
  task publish: :environment do
    Ad.with_status(:approved).find_each {|ad| ad.publish}
  end
end
