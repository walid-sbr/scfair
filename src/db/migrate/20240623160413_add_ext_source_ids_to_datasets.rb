class AddExtSourceIdsToDatasets < ActiveRecord::Migration[7.0]
  def change
    add_column :datasets, :ext_source_ids, :string, array: true, default: []
  end
end
