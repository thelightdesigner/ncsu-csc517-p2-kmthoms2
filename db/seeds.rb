Admin.find_or_create_by(username: "admin") do |admin|
  admin.password = "admin123"
  admin.full_name = "System Admin"
  admin.email = "admin@example.com"
end
