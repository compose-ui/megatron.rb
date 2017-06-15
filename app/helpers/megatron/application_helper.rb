module Megatron
  module ApplicationHelper
    def link_up(href = nil, options = {}, html_options = nil, &block)
      here_if = options.delete(:here_if) || {}
      here_if[:path] = href if here_if.blank?
      options[:class] = add_class(options[:class], "here") if test_current_page(here_if)

      link_to(href, options, &block)
    end

    def options_from_args(args)
      if args.last.is_a? Hash
        args.pop
      else
        {}
      end
    end

    def add_class(string, *classes)
      string ||= ''
      string << " #{classes.join(' ')}"
      string
    end

    def test_current_page(criteria)
      return false unless criteria.present?

      test_params = criteria.delete(:params) || {}
      [:controller, :action, :path].each do |k|
        test_params[k] ||= criteria[k] if criteria[k].present?
      end

      fullpath = parse_url(request.fullpath)
      check_params = params.to_unsafe_hash.symbolize_keys.merge(path: fullpath)

      test_params.all? {|k, v| test_here_key_value(k, v, check_params) }

    end

    def parse_url(path)
      URI.parse(path.gsub(/(\?.+)/, '')).path
    end

    def test_here_key_value(key, value, check_params = params)
      if value.is_a?(Hash)
        value.all? {|k,v| params[k].present? && test_here_key_value(k, v, params[k]) }
      elsif value.is_a?(Array)
        value.detect {|v| test_here_key_value(key, v) }.present?
      elsif value.is_a?(Regexp)
        (check_params[key] =~ value) != nil
      else
        value_to_check = key == :path ? parse_url(value) : value
        check_params[key] == value_to_check
      end
    end

    def dasherize(input)
      input.gsub(/[\W,_]/, '-').gsub(/-{2,}/, '-')
    end

    def get_root_url
      ENV["ROOT_URL"] || '/'
    end

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
end
