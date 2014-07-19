namespace :ad_types do
  desc "Update counters of published ads for all ad types"
  task update_counters: :environment do
    Ad.counter_culture_fix_counts
  end
end
