namespace :events do

  desc "Import events for all calendars from Google Calendar"
  task :import => :environment do
    importer = BulkEventImporter.new
    importer.import
  end

end
