Time::DATE_FORMATS[:us_regular] = "%B %d at %I:%M %p"
Time::DATE_FORMATS[:time_only] = "%I:%M %p"
Time::DATE_FORMATS[:date_only_ordinal] = lambda { |date| date.strftime("%B #{ActiveSupport::Inflector.ordinalize(date.day)}, %Y") }
Time::DATE_FORMATS[:short_ordinal] = lambda { |date| date.strftime("%B #{ActiveSupport::Inflector.ordinalize(date.day)} at %I:%M %p") }
Time::DATE_FORMATS[:long_ordinal] = lambda { |date| date.strftime("%B #{ActiveSupport::Inflector.ordinalize(date.day)}, %Y at %I:%M %p") }
Time::DATE_FORMATS[:month_abbrev] = lambda { |date| date.strftime("%b") }
Time::DATE_FORMATS[:month_abbrev_with_year] = lambda { |date| date.strftime("%b %Y") }
Time::DATE_FORMATS[:slashes] = '%m/%d/%Y'
Time::DATE_FORMATS[:slashes_with_time] = '%m/%d/%Y at %I:%M %p'
Time::DATE_FORMATS[:wday_and_date] = lambda { |date| 
  if date.year == Time.now.year
    date.strftime('%a, %b %d')
  else
    date.strftime('%a, %b %d, %Y')
  end
}