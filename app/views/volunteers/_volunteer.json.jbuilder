json.extract! volunteer, :id, :username, :password, :full_name, :email, :phone_number, :address, :skills, :interests, :total_hours, :created_at, :updated_at
json.url volunteer_url(volunteer, format: :json)
