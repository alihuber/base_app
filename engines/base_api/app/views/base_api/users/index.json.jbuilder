json.array! @users do |user|
  json.id user.id
  json.type user.type
  json.email user.email
  json.createdAt user.created_at
  json.updatedAt user.updated_at
end
