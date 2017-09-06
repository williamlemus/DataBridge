# DataBridge
DataBridge is a lightweight ORM built using Ruby.

### Key Features

- SQLRecord#save will automatically decide to create a new row or update depending on whether the id exists in the database.


### Example Usage

In order to use DataBridge, a model class should be created as show(using the example contained in lib):

```ruby
class Team < SQLRecord
  self.finalize!
end
```

Calling finalize will ensure that attribute accessors are created for each of the columns of the database table.


### Available methods

The follow methods can be used on the SQLRecord:
* save
* update
* insert
* find
* all

Also, the following associations can be created:
* belongs_to
* has_many
* has_one_through

## Running the included Example
1. `git clone https://github.com/williamlemus/DataBridge.git`
2. cd DataBridge
3. cat teams.sql | sqlite3 teams.db
4. pry
5. load 'lib/demo_tables.rb'
6. Use pry to test out the various commands on the Team, City and/or Player models.
