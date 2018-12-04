class Space

  attr_reader :space_id, :name, :description, :price, :user_id

  def initialize(space_id:, name:, description:, price:, user_id:)
    @space_id = space_id.to_i
    @name = name
    @description = description
    @price = price.to_f
    @user_id = user_id.to_i
  end

  def self.create(name:, description:, price:, user_id:)
    result = DatabaseConnection.query("INSERT INTO spaces (name, description, price, user_id) VALUES('#{name}', '#{description}', '#{price}', '#{user_id}') RETURNING space_id, name, description, price, user_id")
    Space.new(space_id: result[0]['space_id'], name: result[0]['name'], description: result[0]['description'], price: result[0]['price'], user_id: result[0]['user_id'])
  end

  def self.create_availability(space_id:, start_date:, end_date:)
    result = DatabaseConnection.query("INSERT INTO space_dates (space_id, start_date, end_date) VALUES('#{space_id}', '#{start_date}', '#{end_date}')")
  end

end
