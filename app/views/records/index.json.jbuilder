json.array!(@records) do |record|
  json.extract! record, :id, :score, :phase_id, :easiness
  json.url record_url(record, format: :json)
end
