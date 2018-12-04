require 'pg'
require_relative 'DatabaseConnection'

# this class is class
class User
  attr_reader :user_id, :name, :email

  def initialize(user_id:, name:, email:)
    @user_id = user_id
    @name = name
    @email = email
  end

  def self.create(name:, email:, password:)
    result = DatabaseConnection.query("
      INSERT INTO users (name, email, password)
      VALUES('#{name}', '#{email}', '#{password}')
      RETURNING user_id, name, email;
      ")
    User.new(
      user_id: result[0]['user_id'],
      name: result[0]['name'],
      email: result[0]['email']
    )
  end


  def self.retrieve(user_id:)
    return nil unless user_id
    result = DatabaseConnection.query("
      SELECT *
      FROM users
      WHERE user_id = '#{user_id}';
      ")
    User.new(
      user_id: result[0]['user_id'],
      name: result[0]['name'],
      email: result[0]['email']
    )
  end

  def self.authenticate(email:, password:)
    result = DatabaseConnection.query("SELECT * FROM users WHERE email = '#{email}' AND password = '#{password}'").first
    return if result == nil
    User.new(
      user_id: result['user_id'],
      name: result['name'],
      email: result['email']
    )
  end

end
