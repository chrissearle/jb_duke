class String
  def format_string_with_hash(params)
    result = self

    params.each do |key, val|
      match = key.to_s.upcase
      result = result.gsub(/#{match}/, val)
    end

    result
  end
end
