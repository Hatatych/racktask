class App
  PERMITTED_PARAMS = %w[year month day hour min sec].freeze

  def call(env)
    @query = Rack::Utils.parse_nested_query(env['QUERY_STRING'])
    @body = []
    validate_params
    [@status, headers, @body]
  end

  private

  def validate_params
    if !@query.key?('format')
      @status = 404
      @body << "Wrong url\n"
    elsif !check_format
      @status = 400
      @body << "Unknown time format: #{@errors.inspect}\n"
    else
      @status = 200
      generate_response
    end
  end

  def check_format
    @errors = []
    @params = @query['format'].split(',')
    @params.each { |param| @errors << param unless PERMITTED_PARAMS.include?(param) }
    return false if @errors.any?

    true
  end

  def generate_response
    filtered_params = []
    @params.each { |param| filtered_params << Time.now.send(param.to_sym) }
    @body << filtered_params.join('-') + "\n"
  end

  def headers
    { 'Content-Type' => 'text/plain' }
  end
end
