class TimeFormatter
  PERMITTED_FORMATS = %w[year month day hour min sec].freeze
  attr_reader :errors

  def initialize(formats)
    @formats = formats.split(',')
  end

  def call
    return format_time if valid?

    nil
  end

  def valid?
    @errors = []
    @formats.each { |format| @errors << format unless PERMITTED_FORMATS.include?(format) }
    return false if @errors.any?

    true
  end

  private

  def format_time
    filtered_formats = []
    @formats.each { |format| filtered_formats << Time.now.send(format.to_sym) }
    @result = filtered_formats.join('-') + "\n"
  end
end
