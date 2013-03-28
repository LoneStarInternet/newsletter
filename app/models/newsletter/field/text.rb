=begin rdoc
Author::    Chris Hauboldt (mailto:biz@lnstar.com)
Copyright:: 2009 Lone Star Internet Inc.

Dumb text field, created so that we can choose for them to have text areas and text fields.

=end

module Newsletter
    class Field::Text < Field
      def keys
        ['text']
      end
    end
end