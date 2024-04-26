require_relative 'apis_helpers/cellxgene_api'
require_relative 'apis_helpers/bgee_api'
require_relative 'apis_helpers/asap_api'

desc 'UPDATE GELLxGENE DATASETS'
task update_cxg: :environment do
  manager = CELLxGENE_API.new
  manager.init
end

desc 'UPDATE BGEE DATASETS'
task update_bgee: :environment do
  manager = BGEE_API.new
  manager.init
end

desc 'UPDATE ASAP DATASETS'
task update_asap: :environment do
  manager = ASAP_API.new
  manager.init
end

desc 'INDEX DB WITH SOLR'
task index_db: :environment do
  Rake::Task['sunspot:reindex'].invoke
end

desc 'Run all required tasks sequentially'
task api_updates: :environment do
  # Define the tasks you want to run sequentially
  tasks_to_run = [
    'update_cxg',
    'update_bgee',
    'index_db'
  ]

  tasks_to_run.each do |task|
    Rake::Task[task].invoke
  end
end
