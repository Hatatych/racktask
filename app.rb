require_relative 'time_formatter'

class App
  def call(env)
    @query = Rack::Utils.parse_nested_query(env['QUERY_STRING'])
    @path = env['REQUEST_PATH']
    if url_valid?
      handle_valid_request
    else
      handle_invalid_request
    end
  end

  private

  def url_valid?
    return false if !@query.key?('format') || @path != '/time'

    true
  end

  def handle_invalid_request
    Rack::Response.new(["Wrong url\n"], 404, headers).finish
  end

  def handle_valid_request
    format = TimeFormatter.new(@query['format'])
    if format.valid?
      Rack::Response.new([format.call], 200, headers).finish
    else
      Rack::Response.new(["Wrong format: #{format.errors.inspect}\n"], 400, headers).finish
    end
  end

  def headers
    { 'Content-Type' => 'text/plain' }
  end
end
