require 'net/http'

class CELLxGENE_API
  @@CXG_BASE_API_URL = "https://api.cellxgene.cziscience.com/curation/v1/collections/"
  @@SOURCE = "CELLxGENE"

  def init
    collections_id = get_collections_id
    gather_info collections_id
  end

  def add_to_db
    puts "dataset id #{@data[:dataset_id]}"
    dataset = Dataset.find_or_create_by(dataset_id: @data[:dataset_id])
    dataset.update(@data)
    puts "db updated"
  end

  def changed?(json)
    stringified = JSON.generate(json)
    hash = Digest::SHA256.hexdigest(stringified)
    dataset = Dataset.find_by dataset_id: json[:dataset_id]
    if dataset.nil? || (dataset[:dataset_hash] != hash)
      @data[:dataset_hash] = hash
      return true
    else
      return false
    end
  end


  def get_collections_id
    collections_id = []
    http = Net::HTTP
    url = URI.parse(@@CXG_BASE_API_URL)
    req = http.get(url)

    collections = JSON.parse(req, { symbolize_names: true })
    collections.each do |collection|
      collections_id << collection[:collection_id]
    end
    puts 'collections id added'
    return collections_id
  end

  def gather_info(collections_id)
    collections_id.each do |id|
      puts "gather info of id #{id}"
      http = Net::HTTP
      url = URI.parse(@@CXG_BASE_API_URL + id)
      req = http.get(url)

        collection = JSON.parse(req, { symbolize_names: true })

        # Diving in datasets
        collection[:datasets].each do |dataset|

          @data = {
              collection_id: nil,
              dataset_id: nil,
              source: nil,
              doi: nil,
              dataset_hash: nil,
              number_of_cells: [],
              organisms: [],
              disease: [],
              assay_info: [],
              processed_data: [],
              link_to_dataset: [],
              link_to_explore_data: [],
              link_to_raw_data: [],
              cell_types: [],
              tissue: [],
              tissue_uberon: [],
              developmental_stage: [],
              developmental_stage_id: [],
              sex: [],
          }

          if changed? dataset

            @data[:collection_id] = collection[:collection_id]
            @data[:link_to_dataset] = collection[:collection_url]
            @data[:source] = @@SOURCE
            @data[:doi] = collection[:doi]

            # Diving in links
            collection[:links].each do |link|
              @data[:link_to_raw_data] << link[:link_url]
            end

            @data[:dataset_id] = dataset[:dataset_id]
            @data[:link_to_explore_data] = dataset[:explorer_url]
            @data[:number_of_cells] << dataset[:cell_count]

            dataset[:cell_type].each do |cell|
              @data[:cell_types] << cell[:label]
            end

            dataset[:tissue].each do |tissue|
              @data[:tissue] << tissue[:label]
              @data[:tissue_uberon] << tissue[:ontology_term_id]
            end

            dataset[:development_stage].each do |stage|
              @data[:developmental_stage] << stage[:label]
              @data[:developmental_stage_id] << stage[:ontology_term_id]
            end

            dataset[:sex].each do |sex|
              @data[:sex] << sex[:label]
            end

            dataset[:organism].each do |organism|
              @data[:organisms] << organism[:label]
            end

            dataset[:disease].each do |disease|
              @data[:disease] << disease[:label]
            end

            dataset[:assay].each do |assay|
              @data[:assay_info] << assay[:label]
            end

            dataset[:assets].each do |asset|
              @data[:processed_data] << asset[:url]
            end

            # UPDATE table with datasets
            add_to_db
          else
            puts 'does not change'
          end
        end
    end
  end

end
