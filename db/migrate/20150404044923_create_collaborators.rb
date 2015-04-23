class CreateCollaborators < ActiveRecord::Migration
  def change
    create_table :collaborators do |t|
      t.string :name
      t.timestamps
    end

    add_column :wikis, :collaborator_id, :integer
    add_index :wikis, :collaborator_id

  end

end
