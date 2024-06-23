class CreateExtSources < ActiveRecord::Migration[7.0]
  def change
    create_table :ext_sources do |t|

      t.string :url_mask
      t.string :name
      t.string :description
      t.string :id_regexp
      t.timestamps
    end
  end
end
