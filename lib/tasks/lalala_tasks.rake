namespace :lalala do

  namespace :assets do
    desc "Reprocess assets"
    task :reprocess => :environment do
      ImageAsset.all.each do |image|
        image.asset.recreate_versions! if image.asset
      end
    end
  end

end
