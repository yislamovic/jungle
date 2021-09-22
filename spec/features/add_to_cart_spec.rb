require 'rails_helper'

RSpec.feature "AddToCarts", type: :feature, js: true do
   # SETUP
 before :each do
  @category = Category.create! name: 'Apparel'

  10.times do |n|
    @category.products.create!(
  name:  Faker::Hipster.sentence(3),
  description: Faker::Hipster.paragraph(4),
  image: open_asset('apparel1.jpg'),
  quantity: 10,
  price: 64.99
)
  end
end

  scenario "it vists the first product page" do
    # ACT
    visit root_path
    find(".button_to", match: :first).click_button('Add')
    # DEBUG / VERIFY
    sleep 2
    save_screenshot
    expect(page).to have_content('My Cart (1)')
  end

end
