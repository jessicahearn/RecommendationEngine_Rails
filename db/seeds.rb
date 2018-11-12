# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


user_names    = ["Kame", "Jin", "Taguchi", "Koki", "Ueda", "Nakamaru"]
product_names = ["Computer", "iPhone", "Coffee Maker", "TV", "Laptop", "Lamp", "Crock Pot", 
                  "Rice Maker", "DVD Player", "Bluray", "Book", "Chair", "Couch", "Desk", 
                  "Mixer", "Piano", "Coffee Table", "Bed", "Wardrobe", "Rug", "Microwave"]

# Create Users
user_names.each do |name|
  u = User.new(name: name)
  u.save
end

# Create Products
product_names.each do |name|
  p = Product.new(name: name)
  p.save
end

# Create UserProducts
User.all.each do |user|
  Product.all.each do |product|
    up = UserProduct.new(user: user, product: product)
    up.save
  end
end

# Create Random Likes and Dislikes
subset = UserProduct.order("RANDOM()").first(50)

subset.each_with_index do |item, index|
  if index.odd?
    item.liked = true
    item.save
  else
    item.disliked = true
    item.save
  end
end
