module RuBB
  class Node
    class URL < Node
      attr_accessor :url
      
      def initialize(options={})
        super(options)
        @url = options[:url] || ''
      end
      
      def to_html
        unless(@url.empty?)
          html = "<a href=\"#{Parser.escape_quotes(@url)}\">"
          @children.each do |child|
            html += child ? child.to_html : ''
          end
          html + '</a>'
        else
          url = Parser.escape_quotes(@children.map {|c| c ? c.to_html : '' }.join)
          html = "<a href=\"#{url}\">#{url}</a>"
        end
      end
    end
  end
end

