class AddEmailCollabPermissionToUser < ActiveRecord::Migration
  def change
    add_column :users, :email_collab, :boolean, default: true
  end
end
