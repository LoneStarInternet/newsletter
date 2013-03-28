=begin rdoc
Author::    Chris Hauboldt (mailto:biz@lnstar.com)
Copyright:: 2009 Lone Star Internet Inc.

Used to store key-value pairs for a NewsletterPiece's NewsletterFields

=end

module Newsletter
  class FieldValue < ActiveRecord::Base
    set_table_name "#{Conf.newsletter_table_prefix}field_values"
    belongs_to :piece, :class_name => 'Newsletter::Piece'
    belongs_to :field, :class_name => 'Newsletter::Field'
    named_scope :by_piece, lambda{|piece| {:conditions => {:piece_id => piece.id}}}
    named_scope :by_field, lambda{|field| {:conditions => {:field_id => field.id}}}
    named_scope :by_key, lambda{|key| {:conditions => {:key => key}}}
  end
end