class CreateDatasets < ActiveRecord::Migration[7.0]
  def change
    create_table :datasets do |t|
      t.string :source  # Source of the API (CellXGene, Bgee, ASAP...)
      t.string :doi, null: true # Digital Object Identifier of scientific paper
      t.string :cell_types, array: true, default: []  # Array of cell types of the dataset
      t.string :tissue, array: true, default: []  # Array of tissues
      t.string :tissue_uberon, array: true, default: []  # Array of tissues UBERON term
      t.string :developmental_stage, array: true, default: [] # Array of developmental stages
      t.string :developmental_stage_id, array: true, default: [] # Array of developmental stages id
      t.string :sex, array: true, default: [] # Array of sex
      t.string :organisms, null: true  # Organism label
      t.string :disease, null: true  # Disease status
      t.string :assay_info, null: true  # Assay type
      t.integer :number_of_cells, null: true  # Number of cells
      t.string :processed_data, null: true  # Link to download processed dataset
      t.string :link_to_dataset, null: true  # Link to collection url
      t.string :link_to_explore_data, null: true   # Link to explore dataset
      t.string :link_to_raw_data, null: true  # Link to download raw dataset
      t.string :hash # Hash of JSON to check if changes

      t.timestamps
    end
  end
end
