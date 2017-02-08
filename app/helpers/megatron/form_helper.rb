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
        type: "url",
        placeholder: "Web address",
        pattern: ".\\.[a-zA-Z]{2,}"
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
      tag :input, html_options
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
      base_input_tag(name, value, options, :email)
    end

    # Passowrd inputs
    def password_input_tag(name, value = nil, options = {})
      base_input_tag(name, value, options, :password)
    end

    def text_input_tag(name, value = nil, options = {})
      base_input_tag(name, value, options, :text)
    end

    def url_input_tag(name, value = nil, options = {})
      base_input_tag(name, value, options, :url)
    end

    def tel_input_tag(name, value = nil, options = {})
      base_input_tag(name, value, options, :tel)
    end

    def textarea_tag(name, value = nil, options = {})
      base_input_tag(name, value, options, :textarea)
    end

    def number_input_tag(name, value = nil, options = {})
      base_input_tag(name, value, options, :number)
    end

    def search_input_tag(name, value = nil, options = {})
      base_input_tag(name, value, options, :search)
    end

    def card_number_tag(name, value=nil, options={})
      base_input_tag(name, value, options, :card_number)
    end

    def card_month_tag(name, value=nil, options={})
      base_input_tag(name, value, options, :card_month)
    end

    def card_year_tag(name, value=nil, options={})
      base_input_tag(name, value, options, :card_year)
    end

    def card_cvc_tag(name, value=nil, options={})
      base_input_tag(name, value, options, :card_cvc)
    end

    def select_input_tag(name, option_tags=nil, options={}, &block)
      if option_tags.is_a? Hash
        options = option_tags
        option_tags = nil
      end

      option_tags ||= extract_block(&block) if block_given?

      base_input_tag(name, option_tags, options, :select)
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

    def base_input_tag(name, value, options, type)
      if value.is_a? Hash
        options = value
        value = nil
      end

      options = (INPUT_OPTIONS[type]||{}).deep_merge options
      options[:type] ||= type

      label = options.delete(:label)
      options[:placeholder] = label if label

      tag = base_tag(name, value, options, type)

      if label
        tag = tag + content_tag(:span, class: 'label-placeholder') { label }
      end

      content_tag(:label, class: 'label-wrapper') { tag }

    end
  end
end
