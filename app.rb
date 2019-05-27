require_relative 'time_formatter'

class App
  PERMITTED_FORMATS = %w[year month day hour min sec].freeze

  def call(env)
    @query = Rack::Utils.parse_nested_query(env['QUERY_STRING'])
    @path = env['REQUEST_PATH']
    if url_valid?
      if formats_valid?
        @status = 200
        @body = TimeFormatter.new.call(@formats)
      else
        @status = 400
        @body = "Unknown format: #{@errors.inspect}\n"
      end
    else
      @status = 404
      @body = "Wrong url\n"
    end
    Rack::Response.new([@body], @status, headers)
  end

  private

  def url_valid?
    return false if !@query.key?('format') || @path != '/time'

    true
  end

  def formats_valid?
    @errors = []
    @formats = @query['format'].split(',')
    @formats.each { |format| @errors << format unless PERMITTED_FORMATS.include?(format) }
    return false if @errors.any?

    true
  end

  def headers
    { 'Content-Type' => 'text/plain' }
  end
end
