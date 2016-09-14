module Megatron
  module IconHelper
    ICON_OPTIONS = {
      config_file: File.expand_path('../../../config/esvg.yml', File.dirname(__FILE__)),
      path: File.expand_path('../../assets/esvg/megatron', File.dirname(__FILE__))
    }

    def iconset
      svg_icons(ICON_OPTIONS)
    end

    def icon(name, options={}, &block)
      i = iconset.use(name, options).html_safe

      if options[:wrapper]
        i = content_tag(:span, class: options[:wrapper].strip) do
          i
        end
      end

      if options[:label]
        i += %Q{<span class="icon-label align-middle">#{options[:label]}</span>}.html_safe
      end

      if block
        i += content_tag('span', class: 'align-middle', &block)
      end

      i
    end

    def text_icon(name, options={}, &block)
      options = set_icon_classes(options, class: 'text-icon', wrapper: 'icon-wrapper')
      icon(name.to_s, options, &block)
    end

    def nav_icon(name, options={}, &block)
      options[:wrapper] = "nav-icon"
      text_icon(name, options, &block)
    end

    def icon_label(name, options={}, &block)
      text_icon(name, options) + content_tag('span', class: 'align-middle', &block)
    end

    def set_icon_classes(options, defaults={})
      options[:class] = (options[:class] || '') << " #{defaults[:class]}"

      if options[:wrapper]
        options[:wrapper] = '' unless options[:wrapper].is_a?(String)
        options[:wrapper] = (options[:wrapper] || '') << " #{defaults[:wrapper]}"
      end

      # Automate adding color classes, blue becomes blue-text
      # This should allow us to change it later more easily if necessary
      if options[:color]
        if options[:color].to_s.start_with?('#')
          options[:style] ||= ''
          options[:style] << " color: #{options[:color].strip}"
        else
          options[:class] << " #{options[:color].to_s.strip}-text"
        end
      end

      # Automate adding size classes, x-small becomes x-small-text
      # This should allow us to change it later more easily if necessary
      if options[:size]
        options[:class] << " #{dasherize(options[:size].to_s.strip)}-text"
      end

      options
    end

    def dasherize(input)
      input.gsub(/[\W,_]/, '-').gsub(/-{2,}/, '-')
    end

    def default_class(classnames, default)
      if classnames.nil? || !classnames.is_a?(String)
        classnames = ''
      end
      classnames.to_s << " #{default}"
    end

    def deployment_text_icon(type, options={}, &block)
      options[:color] ||= type
      options[:fallback] ||= 'deployment'
      text_icon("deployment-#{type}", options, &block)
    end
  end
end
