require 'csv'
require 'duration'
require 'json'

class Duration
  def to_f
    to_i.to_f
  end
end

class Record
  attr_reader :row

  def initialize(row)
    @row = row
  end

  def date
    row[:date]
  end

  def bedtime_at
    date + row[:s_bedtime].minutes
  end

  def up_at
    bedtime_at + bed_duration.to_i.seconds
  end

  def bedtime_at_minutes
    row[:s_bedtime]
  end

  def up_at_minutes
    row[:s_bedtime] + bed_duration.to_i / 60
  end

  def slept_at
    date + row[:s_asleep_time].minutes
  end

  def woke_at
    date + row[:s_awake_time].minutes
  end

  def sleep_duration
    Duration.new(row[:s_duration])
  end

  def bed_duration
    Duration.new(row[:s_light] + row[:s_deep] + row[:s_awake])
  end

  def wake_count
    row[:s_awakenings].to_i
  end

  def wakings
    case wake_count
    when 0
      "no wakings"
    when 1
      "1 waking"
    else
      "#{wake_count} wakings"
    end
  end

  def deep_duration
    Duration.new(row[:s_deep])
  end

  def walked_miles
    row[:m_distance] * 0.0006214
  end

  def step_count
    row[:m_steps]
  end

  def slept?
    !row[:s_bedtime].nil?
  end

  def summarize
    puts "-"*40
    puts f(date).center(40)
    puts "-"*40

    if slept?
      show "In bed", "#{f(bedtime_at)} -> #{f(up_at)} (%s asleep)" % percent(sleep_duration, bed_duration)
      show "Slept for", "#{f(sleep_duration)} (%s)" % percent(sleep_duration, Duration.new(8.hours))
      show "Quality", "#{wakings}, %s deep" % percent(deep_duration, sleep_duration)
    else
      puts
      puts "NO SLEEP".center(40)
      puts
    end
    show "Walked", "#{("%.1f" % walked_miles)} mi (#{percent(step_count, 10000)})"
    puts
  end

  private
  def show label, val
    puts "% 15s:  %s" % [label, val]
  end

  def f val
    case val
    when Duration
      val.format "%h %~h, %m %~m"
    when Date
      val.inspect
    when Time
      val.strftime("%H:%M")
    when Integer
      val
    else
      raise NotImplementedError, "can't format #{val.inspect}"
    end
  end

  def percent num, denom
    "%.0f%%" % (100 * num.to_f / denom.to_f)
  end
end

csv = CSV.new(
  #File.read(File.expand_path("~/Downloads/2012-2.csv")),
  File.read(File.expand_path("~/Downloads/2013-1.csv")),
  headers: true,
  header_converters: :symbol
)
csv.convert do |field|
  if field =~ /^\d{8}$/
    DateTime.parse(field).to_date
  else
    field
  end
end
csv.convert(:numeric)
results = csv.read

records = results.map do |row|
  #puts row.each{|k,v| p [k,v]}
  Record.new(row)
end

records.each &:summarize

encodable = records.map do |r|
  {
    sleep: r.bedtime_at_minutes,
    up_at: r.up_at_minutes
  }
end

puts JSON.dumps encodable
