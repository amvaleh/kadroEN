json.extract! transaction, :id, :afterwards_url, :email, :mobile_number, :amount, :slug, :message, :description, :status, :track_number, :created_at, :updated_at
json.url transaction_url(transaction, format: :json)
