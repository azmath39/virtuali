class AddTokenToPaintings < ActiveRecord::Migration
  def up
    add_column :paintings, :token, :string
    Painting.all.each{|painting|
      if painting.token.blank?
        painting.token=(painting.tour_id.present? ? "tour_#{painting.tour_id}" : "draft_#{painting.draft_id}" )
        painting.save
      end
      }
  end
 def down
end
end
