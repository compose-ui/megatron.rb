module Megatron
  module TimeHelper

    def toggle_time_tag(date, options={})
      options[:toggle] = true
      options[:class] = 'time-toggle'
      options[:data] ||= {}
      options[:data]['timeago'] = options.delete(:timeago_style) || 'long'
      options[:icon] = 'sync-circle'

      content_tag(:span, class: 'time-wrapper') {
        time_tag(date, options)
      }
    end

    def time_ago_tag(date, options={})
      options[:timeago] = true
      options[:class] = 'timeago has-tooltip'
      options[:data] ||= {}
      options[:data]['timeago-style'] = options.delete(:timeago_style) || 'long'
      options['aria-label'] = date.sub('T',' ').sub('+00:00', ' UTC')
      
      time_tag(date, options)
    end

    def time_tag(date, options={})
      iso_date = DateTime.parse(date.to_s).new_offset(0).iso8601

      options[:datetime] = iso_date

      icon = use_svg(options.delete(:icon)) if options[:icon]
      
      unless options.delete(:toggle) || options.delete(:timeago)
        options[:class] = 'has-tooltip'
        options['aria-label'] = time_ago_in_words(iso_date) + ' ago'
      end

      content_tag(:time, options) {
        concat content_tag(:span, class: 'date-text') {
          ('<span class="date">' + iso_date.sub('T','</span> <span class="time">').sub('+00:00','</span> <span class="timezone">UTC</span>')).html_safe
        }
        concat ' '
        concat icon
      }

    end

    def timeago_tag(date, options={})
      date = DateTime.parse(date.to_s).iso8601

      options[:class] = 'timeago'

      options[:data] ||= {}
      options[:data]['timeago-style'] = options.delete(:timeago_style)

      content_tag(:time, options) { date }
    end
  end
end
