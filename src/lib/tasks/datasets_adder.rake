require_relative 'apis_helpers/cellxgene_api'
require_relative '../../app/models/dataset.rb'

desc 'UPDATE GELLxGENE DATASETS'
task update_cxg: :environment do
  manager = CELLxGENE_API.new
  manager.init
end
