module RuBB
  class Node
    class Quote < Node
      attr_accessor :who
      
      def initialize(options={})
        super(options)
        @who = options[:who] || ''
      end
      
      def to_html
        html = '<blockquote>'
        html += "<dl><dt>#{Parser.escape_quotes(@who)}</dt><dd>" unless(@who.empty?)
        html += '<p>'
        @children.each do |child|
          html += child ? child.to_html : ''
        end
        html += '</p>'
        html += '</dd></dl>' unless(@who.empty?)
        html + '</blockquote>'
      end
    end
  end
end
