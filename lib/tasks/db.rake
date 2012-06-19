namespace :db do
  desc 'Create the database from config/couchdb.yml for the current environment'
  task :create do
    db = CouchRest::Model::Base.database
    db.create!
    # We need utc_random to sort tweets in the timeline properly.
    RestClient.put("#{db.server.uri}/_config/uuids/algorithm", '"utc_random"')
  end

  desc 'Drops the database for the current environment'
  task :drop do
    if Rails.env != 'production'
      CouchRest::Model::Base.database.delete!
    end
  end

  desc 'Load the seed data from db/seeds.rb'
  task :seed => :environment do
    load "#{Rails.root}/db/seeds.rb"
    Seeds.start
  end

  desc 'Create and update map/reduce views'
  task :migrate => :environment do
    Dir["#{Rails.root}/app/models/**/*.rb"].each do |path|
      require path
    end
    CouchRest::Model::Base.subclasses.each do |klass|
      klass.save_design_doc!
    end
  end

  desc 'Create the database, load the schema, and initialize with seed data'
  task :setup => [:create, :migrate, :seed]

  desc 'Drop and create the database, load the schema, and initialize with seed data'
  task :reset => [:drop, :setup]
end
