require 'faker'

CATEGORIES = [
  "Education",
  "Technology",
  "Travel",
  "Health and Wellness",
  "Photography",
  "Food and Cooking",
  "Fitness",
  "History",
  "Science",
  "Fashion",
  "Art and Crafts",
  "Music",
  "Sports",
  "Nature and Wildlife",
  "DIY Projects",
  "Home Decor",
  "Gaming",
  "Finance and Investment",
  "Movies and TV Shows",
  "Gardening",
  "Motivation and Self-Help",
].freeze

# Create 100 user seeds with unique first names
100.times do
  first_name = Faker::Name.unique.first_name
  user_name = first_name.downcase
  email = "#{user_name}@gmail.com"

  user = User.create!(
    user_name: user_name,
    email: email,
    password: "000000"
  )

  # Create 5 collections for each user
  5.times do
    category_name = CATEGORIES.sample
    category = Category.find_or_create_by(name: category_name)

    collection = Collection.create(
      user_id: user.id,
      title: Faker::Lorem.words(number: 3).join(" "),
      description: Faker::Lorem.paragraph,
      categories: [category],
      custom_fields: [
        { id: "1", field_name: "Field 1", field_type: %w[number boolean date string text].sample },
        { id: "2", field_name: "Field 2", field_type: %w[number boolean date string text].sample },
        { id: "3", field_name: "Field 3", field_type: %w[number boolean date string text].sample },
        { id: "4", field_name: "Field 4", field_type: %w[number boolean date string text].sample },
        { id: "5", field_name: "Field 5", field_type: %w[number boolean date string text].sample },
        { id: "6", field_name: "Field 6", field_type: %w[number boolean date string text].sample },
        { id: "7", field_name: "Field 7", field_type: %w[number boolean date string text].sample },
        { id: "8", field_name: "Field 8", field_type: %w[number boolean date string text].sample },
        { id: "9", field_name: "Field 9", field_type: %w[number boolean date string text].sample },
        { id: "10", field_name: "Field 10", field_type: %w[number boolean date string text].sample },
      ]
    )

   # Create items for the collection
5.times do
  item_name = Faker::Lorem.words(number: 2).join(" ")

  item = Item.create(
    item_name: item_name,
    collection_id: collection.id,
    user_id: user.id,
  )

end
  end
end
