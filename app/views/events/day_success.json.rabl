object false

child @events, root: "events", object_root: false do
  attributes :id, :name, :started_at

  node :period do |event|
    event.humanize_period
  end
end

node :events, :if => @events.count == 0 do
  []
end

node :info do
  'Evennts on day'
end

node :success do
  true
end
