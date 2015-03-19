# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :newsletter, class: Newsletter::Newsletter do
    name {Faker::Company.name}
    description {Faker::Lorem.paragraphs}
    association :design
    pieces do |newsletter|
      left_area = newsletter.design.areas.where(name: 'left_column').first
      left_image_element = left_area.elements.where(name: 'Left Column Image').first
      image_field = left_image_element.fields.first
      #article = area.elements.where(name: 'Left Column Article').first
      #link = article.fields.where(name: 'link').first
      #headline = article.fields.where(name: 'headline').first
      #excerpt = article.fields.where(name: 'article_excerpt').first
      #right_area = newsletter.design.areas.where(name: 'right_column').first
      
      [ ::Newsletter::Piece.new(
        area: left_area,
        element: left_image_element,
        field_values_attributes: { image_field.id => {
          url: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRwNmnMYLBp2Sw9vg-snbZ_GKONKo_WY0f3S1ETL2era2DZKKqD'
        }}
      )]
    end
 end
end

