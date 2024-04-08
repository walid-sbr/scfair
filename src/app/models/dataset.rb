# app/models/dataset.rb

class Dataset < ApplicationRecord
  searchable do
    text :collection_id
    text :dataset_id
    text :source
    text :doi
    text :cell_types
    text :tissue
    text :tissue_uberon
    text :developmental_stage
    text :developmental_stage_id
    text :sex
    text :organisms
    text :disease
    text :assay_info
    integer :number_of_cells, multiple: true
    text :processed_data
    text :link_to_dataset
    text :link_to_explore_data
    text :link_to_raw_data
    text :dataset_hash
  end
end
