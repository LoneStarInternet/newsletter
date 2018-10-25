module Deleteable

  def self.included(receiver)
    receiver.extend ClassMethods
    receiver.class_eval do
      default_scope where("deleted_at IS NULL")
    end
  end

  def is_deleted?
    !deleted_at.nil?
  end

  def destroy(hard_delete=false)
    if !hard_delete && self.class.column_names.include?('deleted_at')
      delete
    else
      super
    end
  end

  def delete
    update_attribute(:deleted_at,Time.now)
  end

  def undelete
    update_attribute(:deleted_at,nil)
  end

  module ClassMethods
    def deleted
      unscoped.where("deleted_at IS NOT NULL")
    end
  end

end

module DeleteableActions
  def delete
    destroy
  end

  def destroy
    thing = self.class.name.gsub(/s?Controller$/,'').constantize.find(params[:id])
    thing.delete
    redirect_to(action: :index)
  end

  # :nocov: - not currently supported
  def undelete
    thing = self.class.name.gsub(/s?Controller$/,'').constantize.find(params[:id])
    thing.undelete
    redirect_to(action: :index)
  end
  # :nocov:
end
