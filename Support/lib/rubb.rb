module RuBB
  class << self
    def parse(bbcode)
      Parser.parse(Parser.escape_html(bbcode), nil)
    end
  
    def to_html(bbcode)
      parse(bbcode).to_html
    end
  end
end

class String
  def bb_to_html
    RuBB.to_html(self)
  end
end

$: << (File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rubb/node'
require 'rubb/parser'
