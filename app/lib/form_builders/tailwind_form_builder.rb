module FormBuilders
  class TailwindFormBuilder < ActionView::Helpers::FormBuilder
    # Same list of dynamically-generated field helpers as in Rails:
    #   actionview/lib/action_view/helpers/form_helper.rb
    [
      :text_field,
      :password_field,
      :text_area,
      :color_field,
      :search_field,
      :telephone_field,
      :phone_field,
      :date_field,
      :time_field,
      :datetime_field,
      :datetime_local_field,
      :month_field,
      :week_field,
      :url_field,
      :email_field,
      :number_field,
      :range_field,
      :file_field
    ].each do |field_method|
      class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
          def #{field_method}(method, options = {})
            if options.delete(:tailwindified)
              super
            else
              text_like_field(#{field_method.inspect}, method, options)
            end
          end
      RUBY_EVAL
    end

    def submit(value = nil, options = {})
      value, options = nil, value if value.is_a?(Hash)
      value ||= submit_default_value

      super(value, {class: apply_classes(button_classes, options.delete(:class))}.merge(options))
    end

    def check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
      custom_options, opts = partition_custom_options(options)

      field_classes = apply_custom_classes(
        apply_default_or_error_classes(
          check_box_classes,
          check_box_default_classes,
          check_box_error_classes,
          method
        ),
        custom_options[:field_classes]
      )

      field = super(method, {class: field_classes}.merge(opts), checked_value, unchecked_value)

      label = label(method, {
        class: "block pt-xs"
      }.merge(custom_options[:label] || {}), opts)

      @template.content_tag("div", field + label, {class: custom_options[:wrapper_classes] || "mt-2 flex items-center gap-x-1"})
    end

    def collection_check_boxes(method, collection, value_method, text_method, options = {}, html_options = {}, &)
      extra_html_options = {
        class: check_box_classes(method)
      }.merge(html_options)

      super(method, collection, value_method, text_method, options, extra_html_options, &)
    end

    def label(method, text = nil, options = {}, &)
      custom_label_options, label_options = partition_custom_label_options(options)
      return if custom_label_options[:skip]

      super(method, text, {
        class: apply_classes(
          label_classes,
          custom_label_options[:class],
          label_default_classes,
          label_error_classes,
          method
        )
      }.merge(label_options), &)
    end

    def select(method, choices = nil, options = {}, html_options = {}, &)
      label, html_opts = select_or_collection_select(method, choices, options, html_options, &)
      field = super(method, choices, options, html_opts, &)

      if label.present?
        label + field
      else
        field
      end
    end

    def collection_select(method, collection, value_method, text_method, options = {}, html_options = {})
      label, html_opts = select_or_collection_select(method, collection, value_method, text_method, options, html_options)
      field = super(method, collection, value_method, text_method, options, html_opts)

      if label.present?
        label + field
      else
        field
      end
    end

    def combobox(method, options_or_src, **kwargs, &)
      custom_options, html_opts = partition_custom_options(kwargs)

      # Looking for CSS classes? They're overridden in app/assets/stylesheets/application.tailwind.css

      label = label(method, custom_options[:label], html_opts)
      field = super(method, options_or_src, **html_opts.merge(
        dialog_label: custom_options.dig(:label, :text) || method.to_s.humanize,
        input: html_opts.without(:include_blank, :render_in),
        include_blank: (html_opts[:include_blank] == true) ? "None" : html_opts[:include_blank]
      ), &)

      if label.present?
        label + field
      else
        field
      end
    end

    private

    def text_like_field(field_method, object_method, options = {})
      custom_options, options = partition_custom_options(options)

      label = label(object_method, custom_options[:label], options) do |builder|
        label = @template.content_tag("span", custom_options[:label] || builder.translation)

        hint = hint(object_method, custom_options)
        errors = errors(object_method, custom_options)

        [label, hint, *errors].compact.reduce(:+)
      end

      field = send(field_method, object_method, {
        class: apply_classes(
          text_like_field_classes,
          custom_options[:field_classes],
          text_like_field_default_classes,
          text_like_field_error_classes,
          object_method
        ),
        title: errors_for(object_method)&.join(" ")
      }.compact.merge(options).merge({tailwindified: true}))

      if label.present? || hints.present?
        @template.content_tag(
          "div",
          label + field,
          class: apply_classes(field_wrapper_classes, custom_options[:wrapper_classes])
        )
      else
        field
      end
    end

    def select_or_collection_select(method, *args, html_options, &block)
      custom_options, html_opts = partition_custom_options(html_options)

      label = label(method, custom_options[:label], html_options)

      [label, {class: class_names(
        "mt-1 rounded-md shadow-sm focus:ring focus:ring-success focus:ring-opacity-50",
        (custom_options[:field_classes] if custom_options[:field_classes].present?),
        ("block w-full" unless custom_options[:inline]),
        apply_default_or_error_classes(method)
      )}.merge(html_opts)]
    end

    def hint(method, options)
      hint = options[:hint]
      return unless options[:hint]

      @template.content_tag("span", hint, class: "text-sm")
    end

    def errors(method, options)
      errors = errors_for(method).presence
      return unless errors

      errors.map do |error|
        @template.content_tag("span", error, class: "text-sm")
      end
    end

    def apply_classes(base_classes, custom_classes = nil, default_classes = nil, error_classes = nil, object_method = nil)
      validation_classes = if object_method && errors_for(object_method).present?
        error_classes
      else
        default_classes
      end

      class_names(base_classes, validation_classes, custom_classes)
    end

    CUSTOM_OPTS = [:inline, :label, :field_classes, :wrapper_classes, :hint].freeze
    def partition_custom_options(opts)
      (opts || {}).partition { |k, v| CUSTOM_OPTS.include?(k) }.map(&:to_h)
    end

    CUSTOM_LABEL_OPTIONS = [:text, :class, :inline, :extra_classes, :hidden, :skip, :value]
    def partition_custom_label_options(opts)
      (opts || {}).partition { |k, v| CUSTOM_LABEL_OPTIONS.include?(k) }.map(&:to_h)
    end

    def errors_for(object_method)
      return if @object.blank?

      # The story here is that Rails adds association errors onto the
      # association by name, not "_id" So errors may be on :client but the form
      # field has to be :client_id
      if /_id$/.match?(object_method.to_s)
        @object.errors[object_method].presence || @object.errors[object_method.to_s.gsub(/_id$/, "").to_sym]
      else
        @object.errors[object_method]
      end
    end

    def field_wrapper_classes
      "flex flex-col gap-2"
    end

    def text_like_field_classes
      "block w-full px-4 py-2 rounded bg-indigo-800"
    end

    def text_like_field_default_classes
      "border-2 border-indigo-400 focus:outline-none focus:ring-2 focus:ring-indigo-200 focus:border-indigo-200"
    end

    def text_like_field_error_classes
      "border-2 border-red-400 focus:outline-none focus:ring-2 focus:ring-red-200 focus:border-red-200"
    end

    def check_box_classes
      "cursor-pointer block rounded size-3.5"
    end

    def check_box_default_classes
      "focus:ring-2 focus:ring-indigo-200 checked:bg-indigo-200 checked:hover:bg-indigo-300"
    end

    def check_box_error_classes
      "focus:ring-2 focus:ring-indigo-200 checked:bg-indigo-200 checked:hover:bg-indigo-300"
    end

    def label_classes
      "flex flex-col gap-1"
    end

    def label_default_classes
      "text-white"
    end

    def label_error_classes
      "text-red-300"
    end

    def button_classes
      "button"
    end

    def class_names(*classes)
      classes.compact.join(" ")
    end
  end
end
