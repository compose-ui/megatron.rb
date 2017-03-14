module Megatron
  module ToggleNavHelper
    class ToggleNav < Megatron::Helper

      def initialize(tag = :div, options = {})

        if tag.is_a? Hash
          options = tag
          tag = :div
        end

        options[:tag] = tag

        @options = options
        @options[:name] ||= "radio-group-#{rand(10000)}-#{rand(10000)}"
        @count = 0
      end

      def display(body)
        options = @options
        options.delete(:name)

        display_tag options.delete(:tag), options, body 
      end

      def display_tag(tag, options, body )
        options[:class] = "toggle-nav #{@options[:class]}"
        content_tag(tag, options) { body }
      end

      def option(label = nil, options = {}, &block)

        if label.is_a? Hash
          options = label
          label = options.delete(:label)
        end

        checked = options.delete(:checked) || false
        name = options.delete(:name) || @options[:name]
        label_text = content_tag(:span, class: 'label-text') { label } if label

        label_class = "#{options.delete(:class)} toggle-nav-label"
        label_id = "#{name}_#{@count += 1}"

        # The label should have an active class
        # when the radio is active
        options[:add_class] = "active; ##{label_id}& #{options[:add_clss]}"

        options = set_toggle_options(options)

        content_tag(:label, class: label_class, id: label_id ) {
          concat radio_button_tag(name, true, checked, options)
          concat extract_block(&block) if block_given?
          concat label_text
        }
      end
    end

    class ToggleRow < ToggleNav
      def display_tag(tag, options, body )

        options[:class] = "toggle-row #{@options[:class]}"
        label = content_tag(:span, class: 'toggle-row-label-text') { options.delete(:label) } if options[:label]

        content_tag(tag, options) {
          concat label
          concat content_tag('div', class: 'toggle-row-panel') { body }
        }
      end
    end
  end
end
