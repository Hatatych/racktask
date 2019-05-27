require_relative 'time_formatter'

class App
  def call(env)
    @query = Rack::Utils.parse_nested_query(env['QUERY_STRING'])
    @path = env['REQUEST_PATH']
    if url_valid?
      @status, @body = TimeFormatter.new.call(@query['format'])
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

  def headers
    { 'Content-Type' => 'text/plain' }
  end
end
