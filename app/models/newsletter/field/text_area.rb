=begin rdoc
Author::    Chris Hauboldt (mailto:biz@lnstar.com)
Copyright:: 2009 Lone Star Internet Inc.

Dumb text area, created so that we can choose for them to have text areas and text fields.

=end

module Newsletter
    class Field::TextArea < Field
      def keys
        ['text_area']
      end
    end
end
