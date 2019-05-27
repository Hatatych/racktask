class TimeFormatter
  PERMITTED_FORMATS = %w[year month day hour min sec].freeze

  def call(formats)
    @formats = formats.split(',')
    return 200, format_time if formats_valid?

    [400, "Unknown format: #{@errors.inspect}\n"]
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
    filtered_formats.join('-') + "\n"
  end
end
