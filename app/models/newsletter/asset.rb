=begin rdoc
Author::    Chris Hauboldt (mailto:biz@lnstar.com)
Copyright:: 2009 Lone Star Internet Inc.

Wrapper for attachment_fu files plugin, and is used by NewsletterPieces to save assets.

=end

module Newsletter
  class Asset < ActiveRecord::Base
    set_table_name "#{Conf.newsletter_table_prefix}assets"
    belongs_to :field, :conditions => {:type => 'Newsletter::Field::InlineAsset'}, 
      :class_name => 'Newsletter::Field::InlineAsset'
    belongs_to :piece, :class_name => 'Newsletter::Piece'
    has_attachment :storage => :file_system, :path_prefix => Conf.newsletter_asset_path || 'public/newsletter_assets'
  
    named_scope :by_piece, lambda{|piece| {:conditions => {:piece_id => piece.id}}}
  end
end