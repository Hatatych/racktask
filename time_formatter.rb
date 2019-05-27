class TimeFormatter
  PERMITTED_FORMATS = %w[year month day hour min sec].freeze
  attr_reader :errors, :result

  def call(formats)
    @formats = formats.split(',')
    return format_time if formats_valid?

    false
  end

  private

  def formats_valid?
    @errors = []
    @formats.each { |format| @errors << format unless PERMITTED_FORMATS.include?(format) }
    return false if @errors.any?

    true
  end

  def format_time
    filtered_formats = []
    @formats.each { |format| filtered_formats << Time.now.send(format.to_sym) }
    @result = filtered_formats.join('-') + "\n"
    true
  end
end
