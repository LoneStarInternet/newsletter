=begin rdoc
Author::    Chris Hauboldt (mailto:biz@lnstar.com)
Copyright:: 2009 Lone Star Internet Inc.

Used to store key-value pairs for a NewsletterPiece's NewsletterFields

=end

module Newsletter
  class FieldValue < ActiveRecord::Base
    self.table_name =  "#{::Newsletter.table_prefix}field_values"
    belongs_to :piece, :class_name => 'Newsletter::Piece'
    belongs_to :field, :class_name => 'Newsletter::Field'
    scope :by_piece, lambda{|piece| where("piece_id IS NOT NULL AND piece_id=?",piece.try(:id))}
    scope :by_field, lambda{|field| where("field_id IS NOT NULL AND field_id=?",field.try(:id))}
    scope :by_key, lambda{|key| where(key: key)}

    attr_protected :id
  end
end