module RuBB
  class Node
    class Text < Node
      attr_accessor :text
      attr_accessor :ignore_whitespace
      
      def initialize(options={})
        super(options)
        @text = options[:text] || ''
        @ignore_whitespace = options[:ignore_whitespace] || false
      end
  
      def to_html
        if(@ignore_whitespace)
          @text.gsub(/\s/, '')
        else
          @text.gsub(/\r\n?/, "\n").gsub(/\n/, '<br />')
        end
      end
    end
  end
end
