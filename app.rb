require_relative 'time_formatter'

class App
  def call(env)
    @query = Rack::Utils.parse_nested_query(env['QUERY_STRING'])
    @path = env['REQUEST_PATH']
    @time_formatter = TimeFormatter.new
    if url_valid?
      if @time_formatter.call(@query['format'])
        @status = 200
        @body = @time_formatter.result
      else
        @status = 400
        @body = "Wrong format: #{@time_formatter.errors.inspect}\n"
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

  def headers
    { 'Content-Type' => 'text/plain' }
  end
end
