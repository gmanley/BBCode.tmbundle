module RuBB
  class Node
    class Image < Node
      attr_accessor :width
      attr_accessor :height
      
      def initialize(options={})
        super(options)
        @width = options[:width]
        @height = options[:height]
      end
      
      def to_html
        if(@width && @height)
          url = Parser.escape_quotes(@children.map {|c| c ? c.to_html : '' }.join)
          html = "<img src=\"#{url}\" style=\"width: #{@width}px; height: #{@height}px;\" alt=\"\" />"
        else
          url = Parser.escape_quotes(@children.map {|c| c ? c.to_html : '' }.join)
          html = "<img src=\"#{url}\" alt=\"\" />"
        end
      end
    end
  end
end

