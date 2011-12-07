module DataTypes
  module Location
    module FieldType
      def option_types
        {}
      end
    end

    module Field
      def form_helper_params
        {
          :type => :single,
          :args => [:text_field, :data]
        }
      end
    end
  end
end
