module Deleteable

  def self.included(receiver)
    receiver.extend ClassMethods
  end

  def is_deleted?
    !deleted_at.nil?
  end

  def delete
    update_attribute(:deleted_at,Time.now)
  end

  def undelete
    update_attribute(:deleted_at,nil)
  end

  module ClassMethods
    def find(*args)
      if args[0] == (:exclusive_scope)
        args.shift
        super
      else
        with_scope(:find => {:conditions => ["#{table_name}.deleted_at is null"]}) do
          super
        end
      end
    end
  end

end

module DeleteableActions
  def delete
    destroy
  end

  def destroy
    thing = controller_name.singularize.split('_').collect{|string| string.capitalize}.join.constantize.find(params[:id])
    thing.delete
    redirect_to(eval("#{controller_name}_path(derailed_params)"))
  end

  def undelete
    thing = controller_name.singularize.split('_').collect{|string| string.capitalize}.join.constantize.find(:exclusive_scope,params[:id])
    thing.undelete
    redirect_to(eval("#{controller_name}_path(derailed_params)"))
  end
end