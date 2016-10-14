module ApplicationHelper
  def embed_svg(filename, options = {})
    group = 0
    file = File.read(Megatron::Engine.root.join('app', 'assets', 'images', 'megatron', filename))
      .gsub(/<!--.+-->/, '')
      .gsub(/^\t{2,}\s*<\/?g>/, '')
      .gsub(/width=".+?"/, 'width="312"')
      .gsub(/\sheight.+$/, '')
      .gsub(/\t/, '  ')
      .gsub(/\n{3,}/m, "\n")
      .gsub(/^\s{2}<g>.+?^\s{2}<\/g>/m) { |g| 
        g.gsub(/^\s{4,}\s+/, '    ')
      }
      .gsub(/^<g>.+?^<\/g>/m) { |g|
        group += 1
        count = 0
        g.gsub(/^\s{2}<g>/) { |g| 
          count += 1
          %Q{  <g id="group-#{group}-cube-#{count}">}
        }
      }
    # doc = Nokogiri::HTML::DocumentFragment.parse file
    # svg = doc.at_css 'svg'
    # if options[:class].present?
    #   svg['class'] = options[:class]
    # end
    file.html_safe
  end
end
