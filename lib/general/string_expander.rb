class String
  def format_string_with_hash(params)
    result = self

    unless params.nil?
      params.each do |key, val|
        match = key.to_s.upcase
        result = result.gsub(/#{match}/, val)
      end
    end

    result
  end
end
