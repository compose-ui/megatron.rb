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

    def extract_block(&block)
      content_tag(:foo, &block).gsub(/<\/?foo>/m, '')
    end

    def set_toggle_options( options )
      options[:data] ||= {}
      options[:data] = options[:data].merge({
        show: options.delete(:show),
        hide: options.delete(:hide),
        add_class: options.delete(:add_class),
        remove_class: options.delete(:remove_class)
      })

      options
    end

  end
end
