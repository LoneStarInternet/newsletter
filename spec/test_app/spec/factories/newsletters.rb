# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :newsletter, class: Newsletter::Newsletter do
    name {Faker::Company.name}
    description {Faker::Lorem.paragraphs(1).join("\n")[0..125]}
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
        area_id: left_area.id,
        element_id: left_image_element.id,
        field_values_attributes: { image_field.id => {
          url: Faker::Internet.url.gsub(%r#(/[^/]*\.[^/]*)?$#,'/bobo.jpg')
        }}
      )]
    end
    factory :newsletter_with_image_asset do
      pieces do | newsletter | 
        left_area = newsletter.design.areas.where(name: 'left_column').first
        left_image_element = left_area.elements.where(name: 'Left Column Image').first
        image_field = left_image_element.fields.first
        #article = area.elements.where(name: 'Left Column Article').first
        #link = article.fields.where(name: 'link').first
        #headline = article.fields.where(name: 'headline').first
        #excerpt = article.fields.where(name: 'article_excerpt').first
        #right_area = newsletter.design.areas.where(name: 'right_column').first
        
        [ ::Newsletter::Piece.new(
          area_id: left_area.id,
          element_id: left_image_element.id,
          field_values_attributes: { image_field.id => {
            uploaded_data: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, 
              '/spec/support/files/iReach_logo.gif')))
          }}
        )]
      end
    end
    factory :newsletter_with_pdf_asset do
      pieces do | newsletter | 
        left_area = newsletter.design.areas.where(name: 'left_column').first
        left_image_element = left_area.elements.where(name: 'Left Column Image').first
        image_field = left_image_element.fields.first
        #article = area.elements.where(name: 'Left Column Article').first
        #link = article.fields.where(name: 'link').first
        #headline = article.fields.where(name: 'headline').first
        #excerpt = article.fields.where(name: 'article_excerpt').first
        #right_area = newsletter.design.areas.where(name: 'right_column').first
        
        [ ::Newsletter::Piece.new(
          area_id: left_area.id,
          element_id: left_image_element.id,
          field_values_attributes: { image_field.id => {
            uploaded_data: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, 
              '/spec/support/files/test.pdf')))
          }}
        )]
      end
    end
    factory :newsletter_with_pdf_url do
      pieces do | newsletter | 
        left_area = newsletter.design.areas.where(name: 'left_column').first
        left_image_element = left_area.elements.where(name: 'Left Column Image').first
        image_field = left_image_element.fields.first
        #article = area.elements.where(name: 'Left Column Article').first
        #link = article.fields.where(name: 'link').first
        #headline = article.fields.where(name: 'headline').first
        #excerpt = article.fields.where(name: 'article_excerpt').first
        #right_area = newsletter.design.areas.where(name: 'right_column').first
        
        [ ::Newsletter::Piece.new(
          area_id: left_area.id,
          element_id: left_image_element.id,
          field_values_attributes: { image_field.id => {
            url: Faker::Internet.url.gsub(%r#(/[^/]*\.[^/]*)?$#,'/bobo.pdf')
          }}
        )]
      end
    end
  end
end

