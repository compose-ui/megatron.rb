module Megatron
  module SectionHelper
    class Section < Megatron::Helper

      def initialize( title=nil )
        @title = title
        @children = { cards: [] }

        heading( title ) if title
      end

      def display( body )
        content_tag( :section, class: 'section' ) { 
          concat info
          concat content_tag(:div, class: 'section-content') { body }
        }
      end

      def add_card(card)
        @children[cards].push card
      end

      def heading( text = nil, &block )
        @children[:heading] = get_tag(:header, :h2, text, { class: 'section-heading' }, &block )
        nil
      end

      def description( text = nil, &block )
        @children[:description] = get_tag(:div, :p, text, { class: 'section-description' }, &block )
        nil
      end

      def card( text = nil, &block )
        content_tag(:section, class: 'section-card') {
          concat title( text ) if text
          concat extract_block &block
        }
      end

      def title( text, options={} )
        content_tag(:header, class: "card-title #{options[:class]}") { 
          content_tag(:h2) { text }
        }
      end

      def content(options={}, &block )
        content_tag(:section, class: "card-section #{options[:class]}", &block)
      end

      def footer( options={}, &block )
        content_tag(:footer, class: "card-footer #{options[:class]}", &block)
      end

      private

      def get_tag( tag, wrapper, text, options, &block )
        text = if block_given?
          extract_block &block
        else
          content_tag(wrapper){ text }
        end

        content_tag(tag, options ) { text }
      end

      def info
        if @children[:heading]
          content_tag(:div, class: 'section-info') { 
            concat @children[:heading]
            concat @children[:description]
          }
        end
      end
    end
  end
end
