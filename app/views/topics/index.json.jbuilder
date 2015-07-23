json.array!(@topics) do |topic|
  json.extract! topic, :id, :tid, :slary, :area, :pubtime
  json.url topic_url(topic, format: :json)
end
