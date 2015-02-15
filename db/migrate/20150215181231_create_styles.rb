class CreateStyles < ActiveRecord::Migration
  def change
    create_table :styles do |t|
      t.string :name
      t.string :description

      t.timestamps null: false
		end

    rename_column :beers, :style, :style_old
    add_column :beers, :style_id, :integer

    Beer.all.each do |b|
			if Style.where(name: b.style_old).empty?
				style = Style.new name:b.style_old
				style.save
			end
			
			b.style_id = Style.where(name: b.style_old).first.id
			b.save!

		end

		remove_column :beers, :style_old
  end
end
