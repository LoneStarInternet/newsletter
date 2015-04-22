=begin rdoc
Author::    Chris Hauboldt (mailto:biz@lnstar.com)
Copyright:: 2009 Lone Star Internet Inc.

Wrapper for attachment_fu files plugin, and is used by NewsletterPieces to save assets.

=end

module Newsletter
  class Asset < ActiveRecord::Base
    self.table_name =  "#{::Newsletter.table_prefix}assets"
    belongs_to :field, :conditions => {:type => 'Newsletter::Field::InlineAsset'}, 
      :class_name => 'Newsletter::Field::InlineAsset'
    belongs_to :piece, :class_name => 'Newsletter::Piece'
    
    mount_uploader :image, AssetUploader
      
    attr_protected :id

    scope :by_piece, lambda{|piece| where("piece_id IS NOT NULL AND piece_id=?", piece.try(:id)) }

    def public_filename
      return File.join(::Newsletter::Asset.build_public_dirname(id),File.basename(self[:image])) if self[:image].present?
      nil
    end

    def self.build_public_dirname(id)
      "#{::Newsletter.asset_path}/#{("%08d" %id)[-8,4]}/#{("%08d" %id)[-4,4]}"
    end

    def is_image?
      image.content_type.include?('image')
    rescue => e
      false
    end
  end
end
