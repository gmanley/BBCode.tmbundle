module RuBB
  class Node
    class Styled < Node
      attr_accessor :style_hash
      attr_accessor :html_tag_name
      
      def initialize(options={})
        super(options)
        @style_hash = options[:style_hash] || {}
        @html_tag_name = options[:html_tag_name] || 'span'
      end
      
      def to_html
        html = "<#{@html_tag_name} style=\""
        @style_hash.each do |k,v|
          if(v) # if v is not nil
            v = v[/\A([^;]*);/,1] if v.include?(';') # ignore semicolons and any trailing text
            html += "#{k}: #{v};"
          end
        end
        html += '">'
        @children.each do |child|
          html += child ? child.to_html : ''
        end
        html + "</#{@html_tag_name}>"
      end
    end
  end
end

