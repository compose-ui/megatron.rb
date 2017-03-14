module Megatron
  module SectionHelper
    class Section < Megatron::Helper

      def initialize
        @children = { cards: [] }
      end

      def display(body)
        content_tag(:section, class: 'section') { 
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

      def card( &block )
        content_tag(:section, { class: 'section-card' }, &block)
      end

      def title( text )
        content_tag(:header, class: 'card-title') { 
          content_tag(:h2) { text }
        }
      end

      def section( &block )
        content_tag(:section, class: 'card-section', &block)
      end

      def footer( &block )
        content_tag(:footer, class: 'card-footer', &block)
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

      def content
        if !@children[:cards].empty?
          content_tag(:div, class: 'section-content') {
            @children[:cards].each do |card|
              concat card
            end
          }
        end
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
