require_relative 'apis_helpers/cellxgene_api'
require_relative 'apis_helpers/bgee_api'

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
