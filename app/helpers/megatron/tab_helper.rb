module Megatron
  module TabHelper
    class Tabs < BlockHelpers::Base
      def tab(text, href, options = {})
        options[:class] = add_class(options[:class], "tab")
        here_if = options.delete(:here_if) || {}
        here_if[:path] ||= href
        options[:class] = add_class(options[:class], "here") if test_current_page(here_if)

        content_tag :a, class: options[:class], href: href do
          text
        end
      end

      def tab_button(text, href)
        content_tag :a, class: %w{tab-btn btn medium}, href: href do
          text
        end
      end

      def display(body)
        content_tag(:nav, class: 'tabs') { body }
      end
    end

    class BoxTabs < Tabs
      def display(body)
        content_tag(:nav, class: 'box-tabs') { body }
      end
    end
  end
end
