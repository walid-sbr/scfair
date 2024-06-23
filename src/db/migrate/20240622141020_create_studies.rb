class CreateStudies < ActiveRecord::Migration[7.0]
  def change
 create_table :studies do |t|
      t.text :title
      t.text :first_author
      t.text :authors
      t.text :authors_json
      t.text :abstract
      t.references :journal, foreign_key: true, index: true
      t.text :volume
      t.text :issue
      #      t.integer :pmid                                                                                                                                                                                                  
      t.text :doi
      t.integer :year
      t.text :comment
      t.text :description
      t.timestamp :published_at
      t.timestamps
    end
    add_index :studies, :doi, unique: true

  end
end
