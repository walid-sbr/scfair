class CreateOntology < ActiveRecord::Migration[7.0]
  def change
    create_table :ontologies, id: false do |t|

      t.string :id
      t.string :name, null: true
      t.string :parents, null: true
      t.string  :children, null: true
      t.timestamps

    end
  end
end
