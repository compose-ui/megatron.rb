module Megatron
  module FormHelper
    INPUT_OPTIONS = {
      email: {
        type: "email",
        placeholder: "Email address",
        pattern: "[^@]+@[^@]+\\.[a-zA-Z]{2,}",
        data: { message: "Please enter a valid email address." }
      },

      password: {
        type: "password",
        placeholder: "Password"
      },

      text: {
        type: "text"
      },

      tel: {
        type: "tel",
        placeholder: "Phone number"
      },

      url: {
        type: "text",
        placeholder: "Web address",
        pattern: ".+\\.[a-zA-Z]{2,}"
      },

      card_number: {
        type: "text",
        required: true,
        pattern: "[0-9 -]{13,20}",
        placeholder: "Credit Card Number",
        data: {
          stripe: "number",
          message: "Please enter a valid credit card number."
        }
      },

      card_month: {
        type: "text",
        required: true,
        pattern: "0[1-9]|1[012]",
        placeholder: "MM",
        data: {
          stripe: "exp_month",
          message: "Please enter a valid expiration month."
        }
      },

      card_year: {
        type: "text",
        required: true,
        pattern: "[0-9]{4}",
        placeholder: "YYYY",
        data: {
          stripe: "exp_year",
          message: "Please enter a valid expiration year."
        }
      },

      card_cvc: {
        type: "text",
        required: true,
        pattern: "[0-9]{3,4}",
        placeholder: "CVC",
        data: {
          stripe: "cvc",
          message: "Please enter a valid security code."
        }
      },

      select_country: {
        country_options: {
          include_blank: "Select a country",
          priority_countries: ["US", "GB", "CA"],
        },

        html_options: {}
      }
    }

    def table_form_for(record, options = {}, &block)
      form_for record, options do |f|
        table_form_tag f, &block
      end
    end

    def table_form_tag(form = nil)
      form.style = 'table' if form
      content_tag :div, class: ['table', 'table-form'] do
        yield form if block_given?
      end
    end

    def stacked_form_for(record, options = {}, &block)
      form_for record, options do |f|
        stacked_form_tag f, &block
      end
    end

    def stacked_form_tag(form = nil)
      form.style = 'stacked' if form
      content_tag :div, class: 'stacked-form' do
        yield form if block_given?
      end
    end

    def slider_input_tag(name, options={})
      options = options.stringify_keys
      classnames = options.delete('class') || ''

      if label = options.delete('label')
        label = content_tag(:span, class: 'label-text') { label }
      end

      data = options['data'] || {}
      data['input'] ||= name

      if options['position_label']
        data['position_label'] = options['position_label']
      end
      
      # Set values (and max based on values size)
      if values = options['values']
        data['values'] = values.join(',')
        options['max'] ||= values.size - 1
      end

      # Support legacy option
      options['labels'] ||= options['label']

      if labels = options['labels']
        if labels.is_a?(Array)
          data['label'] = labels.join(';')
          options['max'] ||= labels.size - 1
        elsif labels.is_a?(Hash)
          labels.each do |label, value|
            data['label-'+dasherize(label.to_s.downcase)] = value.join(';')
            options['max'] ||= value.size - 1
          end
        end
      end

      if labels == false
        data['label'] = 'false'
      end

      if labels = options['external_labels']
        if labels.is_a?(Hash)
          labels.each do |label, value|
            data['external-label-'+dasherize(label.to_s.downcase)] = value.join(';')
          end
        end
      end

      if before = options['before']
        if before.is_a?(String)
          data['before-label'] = before
        else
          before.each do |key, value|
            data["before-label-#{key}"] = value
          end
        end
      end

      if mark = options['mark']
        data['mark'] = mark.join(',')
      end

      if after = options['after']
        if after.is_a?(String)
          data['after-label'] = after
        else
          after.each do |key, value|
            data["after-label-#{key}"] = value
          end
        end
      end

      if line_labels = options['line_labels']
        data['line_labels'] = []
        line_labels.each do |k, v|
          data['line_labels'] << "#{k}:#{v}"
        end
        data['line_labels'] = data['line_labels'].join(';')
      end

      options['value'] ||= options['min'] || 0

      html_options = {"class" => classnames, "type" => "range", "min" => options['min'], "max" => options['max'], "value" => options['value'] }.update('data' => data)

      content_tag(:label) {
        concat label if label
        concat tag :input, html_options
      }
    end
    alias :range_input_tag :slider_input_tag

    # Country select
    def select_country_tag(name, options = {}, country_options = {})
      country_options.reverse_merge! INPUT_OPTIONS[:select_country][:country_options]

      options = INPUT_OPTIONS[:select_country][:html_options].deep_merge options

      content_tag(:label) do
        country_select :user, :country, country_options, options
      end
    end

    # Email inputs
    def email_input_tag(name, value = nil, options = {})
      input_tag(:email, name, value, options)
    end

    # Passowrd inputs
    def password_input_tag(name, value = nil, options = {})
      input_tag(:password, name, value, options)
    end

    def text_input_tag(name, value = nil, options = {})
      input_tag(:text, name, value, options)
    end

    def url_input_tag(name, value = nil, options = {})
      input_tag(:url, name, value, options)
    end

    def tel_input_tag(name, value = nil, options = {})
      input_tag(:tel, name, value, options)
    end

    def textarea_tag(name, value = nil, options = {})
      input_tag(:textarea, name, value, options)
    end

    def number_input_tag(name, value = nil, options = {})
      input_tag(:number, name, value, options)
    end

    def search_input_tag(name, value = nil, options = {})
      input_tag(:search, name, value, options)
    end

    def card_number_tag(name, value=nil, options={})
      input_tag(:card_number, name, value, options)
    end

    def card_month_tag(name, value=nil, options={})
      input_tag(:card_month, name, value, options)
    end

    def card_year_tag(name, value=nil, options={})
      input_tag(:card_year, name, value, options)
    end

    def card_cvc_tag(name, value=nil, options={})
      input_tag(:card_cvc, name, value, options)
    end

    def radio_button_input_tag(name, value, checked = false, options = {})

      if checked.is_a? Hash
        options = checked
        checked = false
      end

      options[:type] = 'radio'

      tick_wrapper( name, options ) do
        radio_button_tag(name, value, checked, options)
      end

    end

    def checkbox_input_tag(name, checked = false, options = {})
      value = true

      if checked.is_a? Hash
        options = checked
        checked = false
      end

      options[:type] = 'checkbox'

      tick_wrapper( name, options ) do
        concat tag :input, name: name, type: :hidden, value: false
        concat check_box_tag(name, value, checked, options)
      end
    end

    def select_input_tag(name, option_tags=nil, options={}, &block)
      if option_tags.is_a? Hash
        options = option_tags
        option_tags = nil
      end

      options[:label] ||= options.delete(:label_placeholder)

      option_tags ||= extract_block(&block) if block_given?

      input_tag(:select, name, option_tags, options)
    end

    private

    def extract_block(&block)
      content_tag(:foo, &block).gsub(/<\/?foo>/m, '')
    end

    def base_tag(name, value, options, type)
      case type
      when :select
        value = value.html_safe if value
        select_tag(name, value, options)
      when :textarea
        text_area_tag(name, value, options)
      else
        text_field_tag(name, value, options)
      end
    end

    def input_tag(type, name, value, options=nil)
      type.to_sym! if type.is_a?( String ) 

      if value.is_a? Hash
        options = value
        value = nil
      end

      options = (INPUT_OPTIONS[type]||{}).deep_merge options
      options[:type] ||= type

      label_options = { 
        data: { input: options[:type] }
      }

      if label_placeholder = options.delete(:label_placeholder)
        options[:placeholder] = label_placeholder
        label_placeholder = content_tag(:span, class: 'placeholder-label-text') { label_placeholder }
        label_options[:class] = 'placeholder-label'
      end

      if !label_placeholder && label_text = options.delete(:label)
        label_text = content_tag(:span, class: 'label-text') { label_text }
      end

      content_tag(:label, label_options) {
        concat label_text
        concat base_tag(name, value, options, type) 
        concat label_placeholder
      }

    end

    private

    def tick_wrapper( name, options, &block )

      tag = extract_block(&block)
      type = options[:type]

      tick = content_tag(:span, class: 'tick') {''}
      label = content_tag(:span, class: 'label-text') { options.delete(:label) || name }

      content_tag(:label, data: { input: type }) {
        concat tag.html_safe
        concat tick
        concat content_tag(:span, class: 'label-text-wrapper') { label }
      }
    end

  end
end
