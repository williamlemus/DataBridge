# DataBridge
DataBridge is a lightweight ORM built using Ruby.

## Running the included Example
1. `git clone https://github.com/williamlemus/DataBridge.git`
2. cd DataBridge
3. cat teams.sql | sqlite3 teams.db
4. pry
5. load 'lib/demo_tables.rb'
6. Use pry to test out the various commands on the Team, City and/or Player models.

### Key Features

- SQLRecord#save will automatically decide to create a new row or update depending on whether the id exists in the database.
- First and last records can be retrieved using first and last.
- Associations can be used in place of mapping relationships on the database, leveraging the power of method chaining in Ruby.


### Example Usage

In order to use DataBridge, a model class should be created as show(using the example contained in lib):

```ruby
class Team < SQLRecord
  self.finalize!
end
```

Calling finalize will ensure that attribute accessors are created for each of the columns of the database table. The class should be in the singular of the table name(for example, a teams table will have a Team model class). The methods available are listed below.


### Available methods

The follow methods can be used on the SQLRecord:
* save
  - This will save the Model object to the database, or update it if it already exists, so it can be used in place of insert and update.
* update
  - This will update the row into the database
* insert
  - This will insert the row into the database
* find(id)
  - A class method that is given an id, will return the row as a Model instance.
* all
  - A class method that will return all the records as an array of Model class objects.
* first
  - A class method that will return the first result in the table.
* last
  - A class method that will return the first result in the table.

Also, the following associations can be created:
* belongs_to
  - Creates a one-to-one relationship between models. In the example database, a team belongs to a city. calling the city method will return a city model object of the city the team belongs to.
* has_many
  - Creates a one-to-many relationship between models. In the example database, a city has many teams. Calling the teams method on a city will return an array of all the teams that are in the city.
* has_one_through
  - creates a one-to-one relationship going through a belongs to association. For example, a player belongs to a team. Through the team, the player also belongs to a city. To create a city method on a player, we create a has_one_through relationship, where the through parameter is the team relationship, and the source would be city.

  ```ruby
  class Player < SQLRecord
    belongs_to :team
    has_one_through :city, :team, :city
    # ...
    self.finalize!
  end
  ```
