require 'net/http'

class ASAP_API
  @@ASAP_URL = "https://asap.epfl.ch/projects.json"
  @@SOURCE = "ASAP"

  def init
    gather_info
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
    dataset = Dataset.find_by dataset_id: json[:public_key]
    if dataset.nil? || (dataset[:dataset_hash] != hash)
      @data[:dataset_hash] = hash
      return true
    else
      return false
    end
  end

  def gather_info()
    http = Net::HTTP
    url = URI.parse(@@ASAP_URL)
    req = http.get(url)
    collection = JSON.parse(req, { symbolize_names: true })

    collection.each do |dataset|

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
        link_to_explore_data: nil,
        link_to_raw_data: [],
        cell_types: [],
        tissue: [],
        tissue_uberon: [],
        developmental_stage: [],
        developmental_stage_id: [],
        sex: [],
      }

      if changed? dataset
        puts dataset[:public_key]
        @data[:collection_id] = "ASAP000000"
        @data[:link_to_dataset] = "https://asap.epfl.ch/projects/#{dataset[:public_key]}"
        @data[:source] = @@SOURCE
        @data[:doi] = dataset[:doi]

        @data[:number_of_cells] << dataset[:nber_cols]

        dataset[:experiments].each do |experiment|
          @data[:link_to_raw_data] << experiment[:url]
        end

        @data[:dataset_id] = dataset[:public_key]
        dataset[:annotation_groups].each do |group|
          group[:annotations].each do |annotation|
            annotation[:cell_ontology_terms].each do |term|
              @data[:cell_types] << term[:name]
            end
          end
        end
        @data[:organisms] << dataset[:organism]
        @data[:assay_info] << dataset[:technology]
        @data[:processed_data] << "https://asap.epfl.ch/projects/#{dataset[:key]}/get_file?filename=parsing/output.h5ad"

        #puts @data
        add_to_db
        puts "after add db"
      else
        puts 'does not change'
      end
    end
  end
end
