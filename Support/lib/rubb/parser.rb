module RuBB
  class Parser
    TEXT_REGEXP = /\A([^\[]+)/
    BB_REGEXP = /\A\[([^\]]*)\]/
    
    class << self
      def escape_html(code)
        code.gsub(/&/,'&amp;').gsub(/</,'&lt;').gsub(/>/,'&gt;')
      end
      
      def escape_quotes(code)
        code.gsub(/"/, "\\\"").gsub(/'/, "\\\\'")
      end
      
      def remove_wrapping_quotes(code)
        if code[0] == "\"" && code[code.length-1] == "\""
          return code[/\A"(.*)"\z/,1]
        elsif code[0] == "\'" && code[code.length-1] == "\'"
          return code[/\A'(.*)'\z/,1]
        end
        code
      end
      
      def parse(code, current_tag_name, extra_params={})
        return nil if code.length == 0
        
        ignore_bbcode_in_children = false
        
        node = case current_tag_name
        when 'h1'
          Node::Simple.new(:html_tag_name => 'h1')
        when 'h2'
          Node::Simple.new(:html_tag_name => 'h2')
        when 'h3'
          Node::Simple.new(:html_tag_name => 'h3')
        when 'h4'
          Node::Simple.new(:html_tag_name => 'h4')
        when 'h5'
          Node::Simple.new(:html_tag_name => 'h5')
        when 'h6'
          Node::Simple.new(:html_tag_name => 'h6')
        when 'b'
          Node::Simple.new(:html_tag_name => 'strong')
        when 'i'
          Node::Simple.new(:html_tag_name => 'em')
        when 'u'
          Node::Simple.new(:html_tag_name => 'ins')
        when 's'
          Node::Simple.new(:html_tag_name => 'del')
        when 'code'
          ignore_bbcode_in_children = true 
          Node::Simple.new(:html_tag_name => 'pre')
        when 'ul', 'ol', 'li', 'table', 'tr', 'th', 'td'
          Node::Simple.new(:html_tag_name => current_tag_name)
        when 'size'
          Node::Styled.new(:html_tag_name => 'span', 
                           :style_hash => {'font-size' => (extra_params[:param] ? extra_params[:param].to_f.to_s + 'px' : nil)})
        when 'color'
          Node::Styled.new(:html_tag_name => 'span', 
                           :style_hash => {'color' => (extra_params[:param] ? extra_params[:param].to_s : nil)})
        when 'left'
          Node::Styled.new(:html_tag_name => 'div', :style_hash => {'text-align' => 'left'})
        when 'center'
          Node::Styled.new(:html_tag_name => 'div', :style_hash => {'text-align' => 'center'})
        when 'right'
          Node::Styled.new(:html_tag_name => 'div', :style_hash => {'text-align' => 'right'})
        when 'quote'
          Node::Quote.new(:who => (extra_params[:param] ? extra_params[:param].to_s : ''))
        when 'url'
          ignore_bbcode_in_children = true if extra_params[:param].nil?
          Node::URL.new(:url => (extra_params[:param] ? extra_params[:param].to_s : ''))
        when 'email'
          ignore_bbcode_in_children = true if extra_params[:param].nil?
          Node::Email.new(:email => (extra_params[:param] ? extra_params[:param].to_s : ''))
        when 'img'
          ignore_bbcode_in_children = true
          if(extra_params[:param] && (dimensions = extra_params[:param].to_s.split('x')).size >= 2)
            Node::Image.new(:width => dimensions[0].to_i, :height => dimensions[1].to_i)
          else
            Node::Image.new
          end
        else
          Node.new
        end
    
        until code.empty?
          match_data = code.match(TEXT_REGEXP)

          if(match_data)
            code.replace(match_data.post_match)
            case current_tag_name
            when 'ul', 'ol', 'table', 'tr' # ignore orphaned text within these tags
              # do nothing
            else
              node << Node::Text.new(:text => match_data[1], :ignore_whitespace => ignore_bbcode_in_children)
            end
          else
            match_data = code.match(BB_REGEXP)
            if(match_data)
              tag = match_data[1].sub(/\s*=\s*/,' = ').split(' ')
              tag_name = tag.first.downcase
              
              code.replace(match_data.post_match)
              if(current_tag_name && tag_name == ('/' + current_tag_name))
                return node
              else
                case current_tag_name
                when 'ul', 'ol' # if current tag is a list tag, expect only li tag
                  if(tag_name == 'li')
                    node << parse(code, tag_name)
                  end
                when 'table'
                  if(tag_name == 'tr')
                    node << parse(code, tag_name)
                  end
                when 'tr'
                  if(tag_name == 'th' || tag_name == 'td')
                    node << parse(code, tag_name)
                  end
                else # if current tag is not a list tag
                  if(ignore_bbcode_in_children)
                    node << Node::Text.new(:text => match_data[0], :ignore_whitespace => true)
                  else
                    case tag_name
                    when 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'b', 'i', 'u', 's', 'code', 'left', 'center', 'right', 'ul', 'ol', 'table'
                      node << parse(code, tag_name)
                    when 'url', 'email', 'img', 'size', 'color', 'quote'
                      if(tag[1] == '=' && tag.size > 2) # param is present
                        param = remove_wrapping_quotes(tag[2..(tag.size)].join(' '))
                        node << parse(code, tag_name, {:param => param})
                      else
                        node << parse(code, tag_name)
                      end
                    else
                      node << Node::Text.new(:text => match_data[0])
                    end
                  end
                end
              end
            end
          end
        end
        node
      end
    end
  end
end

Dir.glob(File.join(File.dirname(__FILE__), 'parser/*.rb')).each {|f| require f }  