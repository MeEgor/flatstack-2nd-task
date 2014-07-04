class Event < ActiveRecord::Base
  belongs_to :user

  validates :name, presence: true
  validates :started_at, presence: true

  def filter date
    # if true then filter this event
    case self.period
    when 0
      date == self.started_at ? true : false
    when 1
      date >= self.started_at ? true : false
    when 2
      date >= self.started_at && (date - self.started_at) % 7 == 0 ? true : false
    when 3
      date.day == self.started_at.day ? true : false
    when 4
      date >= self.started_at && date.day == self.started_at.day && date.month == self.started_at.month ? true : false
    else
      true
    end
  end

  def humanize_period
    case self.period
    when 0
      'Одиночное событие'
    when 1
      'Каждый день'
    when 2
      'Каждую неделю'
    when 3
      'Каждый месяц'
    when 4
      'Каждый год'
    end
  end
end
