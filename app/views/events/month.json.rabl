object false

node :days do
  days = []
  from = @date.beginning_of_month
  to   = @date.end_of_month

  days_count = to.day() - from.day() + 1
  before_offset = from.wday - 1
  before_offset = 6 if before_offset < 0

  def is_weekend date
    if date.wday == 6 || date.wday == 0
      true
    else
      false
    end
  end

  def is_today date
    if date == Date.today
      true
    else
      false
    end
  end

  before_offset.times do |day|
    days << {
      day: nil,
      events: 0,
      before: true,
      weekend: false,
      today:false
    }
  end

  days_count.times do |day|
    date = from + day
    events = @events.clone.to_a.delete_if{ |e| !e.filter date }.count

    days << {
      day: date.day(),
      events: events,
      before: false,
      weekend: is_weekend(date),
      today: is_today(date)
    }
  end

  days
end

node :month do
  @date.month()
end

node :year do
  @date.year()
end

node :info do
  'Evennts on month'
end

node :success do
  true
end
