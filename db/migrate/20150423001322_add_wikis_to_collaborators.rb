class AddWikisToCollaborators < ActiveRecord::Migration
  def up
    add_column :collaborators, :wiki_id, :integer
    add_index :collaborators, :wiki_id
  end

  def down
    remove_column :collaborators, :wiki_id, :integer
    remove_index :collaborators, :wiki_id
  end
end
