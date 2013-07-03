class AddMlsidToDrafts < ActiveRecord::Migration
  def change
    add_column :drafts, :mls_id, :string
    add_column :drafts, :store_realtor, :boolean, :default => false
    Draft.all.each{|draft|
      draft.store_realtor=false
      draft.save
    }
  end
end
