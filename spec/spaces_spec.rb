require 'database_helpers'
require 'spaces'

describe Space do
  describe 'space' do
    it 'can be created' do
      test_user = create_test_user
      name = 'Makers BNB'
      description = 'Lovely space to stay'
      price = 99
      user_id = test_user['user_id']

      space = Space.create(
        name: name,
        description: description,
        price: price,
        user_id: user_id
      )

      expect(space).to be_a Space
      expect(space.name).to eq name
      expect(space.description).to eq description
      expect(space.price).to eq price
      expect(space.user_id).to eq user_id.to_i
    end
  end

  describe 'dates' do
    it 'a date range can be created' do
      test_user = create_test_user
      name = 'Makers BNB'
      description = 'Lovely space to stay'
      price = 99
      user_id = test_user['user_id']

      space = Space.create(
        name: name,
        description: description,
        price: price,
        user_id: user_id
      )

      start_date = '2018-01-01'
      end_date = '2018-01-02'
      available = Space.create_availability(
        space_id: space.space_id,
        start_date: start_date,
        end_date: end_date
      )

      expect(available['start_date']).to eq(start_date)
      expect(available['end_date']).to eq(end_date)
    end

    it 'will return a date range' do
      test_user = create_test_user
      space = create_test_space(user_id: test_user['user_id'])

      start_date = '2018-01-01'
      end_date = '2018-01-02'
      Space.create_availability(
        space_id: space.space_id,
        start_date: start_date,
        end_date: end_date
      )

      available = Space.check_availability(space_id: space.space_id).first

      expect(available['start_date']).to eq(start_date)
      expect(available['end_date']).to eq(end_date)
      expect(available['space_id']).to eq(space.space_id.to_s)
    end

    it 'can report all confirmed booked dates' do
      test_user = create_test_user
      space = create_test_space(user_id: test_user['user_id'])

      start_date = '2018-01-01'
      end_date = '2018-01-02'
      Space.create_availability(
        space_id: space.space_id,
        start_date: start_date,
        end_date: end_date
      )

      

    end
  end

  describe '.all' do
    it 'shows all spaces' do
      DatabaseConnection.query("
        INSERT INTO users (user_id, name, email, password)
        VALUES(15, 'Test User', 'test@user.com', 'password');")
      space_a = DatabaseConnection.query("
        INSERT INTO spaces (name, description, price, user_id)
        VALUES('Makers!', 'Great!', 49.99, 15)
        RETURNING space_id, name, description, price, user_id")
      DatabaseConnection.query("
        INSERT INTO spaces (name, description, price, user_id)
        VALUES('The Ritz Flat', 'Snazzy!', 89.99, 15)
        RETURNING space_id, name, description, price, user_id")
      spaces = Space.all

      expect(spaces.ntuples).to eq 2
      expect(spaces[0]['space_id']).to eq space_a[0]['space_id']
      expect(spaces[0]['user_id']).to eq '15'
      expect(spaces[0]['description']).to eq 'Great!'
      expect(spaces[0]['price']).to eq '49.99'
    end
  end
end
