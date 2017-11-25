module RequestSpecHelper
  def parsed_json
    JSON.parse(response.body)
  end
end
