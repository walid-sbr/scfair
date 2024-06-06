class CreateOntologyTerm < ActiveRecord::Migration[7.0]
  def change
    create_table :ontology_terms do |t|

      t.string :identifier
      t.string :name, null: true
      t.string :parents, null: true
      t.string :children, null: true
      t.string :all_children, null: true
      t.string :all_parents, null: true
      t.string :exists_in_datasets, null: true
      t.timestamps

    end

    add_index :ontology_terms, :identifier, unique: true
  end
end
