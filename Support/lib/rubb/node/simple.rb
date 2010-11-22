module RuBB
  class Node
    class Simple < Node
      attr_accessor :html_tag_name
      
      def initialize(options={})
        super(options)
        @html_tag_name = options[:html_tag_name] || ''
      end
      
      def to_html
        html = "<#{@html_tag_name}>"
        @children.each do |child|
          html += child ? child.to_html : ''
        end
        html + "</#{@html_tag_name}>"
      end
    end
  end
end

