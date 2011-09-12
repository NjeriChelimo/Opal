module Opal
  module ActiveRecord
    module Base
      module InstanceMethods
        # assign order number, used in sorting
        def assign_order_number 
          self.order_number = self.class.next_order_number
        end 
        
        def sanitize_content(attribute)
       	  self.class.send(:include, ::ActionView::Helpers::SanitizeHelper)
          self.send((attribute.to_s + "=").to_sym, sanitize(self.send(attribute.to_sym)))
        end        
        
        def create_log(options = {})# create a log
          options[:log_type] = "unknown" if options[:log_type].blank?
          l = Log.new(options)
          l.target_id = self.id
          l.target_type = self.class.name
          l.user_id = self.user_id if respond_to?(:user_id)
          l.item_id = self.item_id if respond_to?(:item_id)       
          l.save
          return l
        end             
      end
      
      module ClassMethods
        # Get the next order number in line for sorting
        def next_order_number
          last_record = self.find(:last, :order => "order_number ASC")
          last_record ? order_number = last_record.order_number + 1 : order_number = 0
          return order_number         
        end        
        
        def test
          "Testing..."
        end      
      end
    end 
  end
end