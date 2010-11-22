module RuBB
  class Node
    attr_accessor :children
  
    def initialize(options={})
      @children = options[:children] || []
    end
  
    def <<(child)
      @children << child
    end
  
    def to_html
      html = ''
      @children.each do |child|
        html += child ? child.to_html : ''
      end
      html
    end
  end
end

Dir.glob(File.join(File.dirname(__FILE__), 'node/*.rb')).each {|f| require f }  