class TimeFormatter
  def call(formats)
    @formats = formats
    format_time
  end

  private

  def format_time
    filtered_formats = []
    @formats.each { |format| filtered_formats << Time.now.send(format.to_sym) }
    filtered_formats.join('-') + "\n"
  end
end
