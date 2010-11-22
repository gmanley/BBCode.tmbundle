module RuBB
  class Node
    class Email < Node
      attr_accessor :email
      
      def initialize(options={})
        super(options)
        @email = options[:email] || ''
      end
      
      def to_html
        unless(@email.empty?)
          html = "<a href=\"mailto:#{Parser.escape_quotes(@email)}\">"
          @children.each do |child|
            html += child ? child.to_html : ''
          end
          html + '</a>'
        else
          email = Parser.escape_quotes(@children.map {|c| c ? c.to_html : '' }.join)
          html = "<a href=\"mailto:#{email}\">#{email}</a>"
        end
      end
    end
  end
end

