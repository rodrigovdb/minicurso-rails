json.extract! person, :id, :name, :birth_date, :email, :phone, :created_at, :updated_at
json.url person_url(person, format: :json)
