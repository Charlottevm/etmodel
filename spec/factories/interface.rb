FactoryBot.define do
  factory :tab do
    sequence(:key) {|n| "tab_#{n}" }
    sequence(:position) { |n| n }
  end

  factory :slide do
    sequence(:key) {|n| "slide_#{n}" }
    sequence(:position) { |n| n }
    sidebar_item_id { SidebarItem.all.first.id }
    association :output_element, factory: :output_element
  end
end
