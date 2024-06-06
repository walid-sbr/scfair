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

    text :ontology_children, default_boost: 0.3, stored: true do
      terms = [tissue_uberon, developmental_stage_id].flatten
      ots = OntologyTerm.where(:identifier => terms).all
      children = OntologyTerm.where(:identifier => ots.map{|e| e.all_children.split(",")}.flatten.compact).all
      children.map{|e| [e.identifier, e.name]}
    end

    text :ontology_parents, default_boost: 0.3, stored: true do
      terms = [tissue_uberon, developmental_stage_id].flatten
      ots = OntologyTerm.where(:identifier => terms).all
      parents = OntologyTerm.where(:identifier => ots.map{|e| e.all_parents.split(",")}.flatten.compact).all
      parents.map{|e| [e.identifier, e.name]}
    end

  end
end
