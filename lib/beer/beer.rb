class Beer
  def initialize(config)
    self.configure(config)
  end

  def configure(config)
    @locations = config["locations"]
  end


  def beer?(location = :all)
    if location == :all
      return @locations.find_all { |l| beer_day_for_location? l[1] }.map { |l| l[0] }
    else
      if @locations.has_key? location
        return [location] if beer_day_for_location?(@locations[location])
      end
    end

    false
  end

  def place(location)
    if @locations.has_key? location
      return @locations[location]['place']
    end

    "Unknown location"
  end

  def name(location)
    if @locations.has_key? location
      return @locations[location]['display-name']
    end

    "Unknown group"
  end

  def show_beer?(location)
    if @locations.has_key? location
      now = Time.now

      hour = (I18n.l now, :format => '%H').to_i
      min = (I18n.l now, :format => '%M').to_i

      return hour == @locations[location]['announce-hour'] && min == @locations[location]['announce-min']
    end

    false
  end

  private

  def beer_day_for_location?(location)
    dow = location['day-of-week']
    week = get_week(location)

    beer_day? dow, week
  end

  def beer_day?(dow, week)
    current_week_num = (I18n.l Time.now, :format => '%V').to_i
    current_dow = (I18n.l Time.now, :format => '%u').to_i

    valid_week = false

    if week == :every
      valid_week = true
    end

    if week == :odd
      valid_week = current_week_num % 2 == 1
    end

    if week == :even
      valid_week = current_week_num % 2 == 0
    end

    (dow == current_dow) && valid_week
  end

  def get_week(location)
    week = :every

    if location.has_key? 'week'
      if location['week'] == 'odd'
        week = :odd
      end
      if location['week'] == 'even'
        week = :even
      end
    end

    week
  end
end
