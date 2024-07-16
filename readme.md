# Custom Active Record Framework

## Project Overview

This project is a custom-built prototype of an Active Record framework, similar to the one used in Ruby on Rails. The framework includes various methods for interacting with a database in an object-oriented manner. The project also includes test cases written with RSpec to ensure the correctness of the implemented features.

## Features

- Define and manage database tables as Ruby classes.
- Automatically generate getter and setter methods for table columns.
- Establish associations between different models.
- Execute SQL queries to interact with the database.
- Include RSpec tests for all implemented methods and features.

## Project Structure

- **lib/**: Contains the implementation of the Active Record framework.
  - `db_connection.rb`: Handles the database connection.
  - `01_sql_object.rb`: Core implementation of the SQLObject class.
  - `02_searchable.rb`: Adds search functionality.
  - `03_associatable.rb`: Handles associations between models.
  - `04_associatable2.rb`: Additional association features.
- **spec/**: Contains the RSpec test cases for the framework.
  - `00_attr_accessor_object_spec.rb`: Tests for attribute accessor methods.
  - `01_sql_object_spec.rb`: Tests for the SQLObject class.
  - `02_searchable_spec.rb`: Tests for search functionality.
  - `03_associatable_spec.rb`: Tests for associations.
  - `04_associatable2_spec.rb`: Tests for additional association features.

## Installation and Setup

1. **Clone the Repository:**

   ```sh
   git clone https://github.com/yourusername/custom-active-record.git
   cd custom-active-record
   ```

2. **Install Dependencies:**

Ensure you have Bundler installed, then run:
`bundle install`

3. **Database Setup:**

Set up your SQLite3 database using the provided `cats.sql` script. Ensure that the database file `cats.db` is created with all the necessary tables by running:
`sqlite3 cats.db < cats.sql`

4. **Running Tests:**

Run `rspec` to ensure everything is working correctly

## Contributing

1. Fork the repository.
2. Create a new branch (git checkout -b feature-branch).
3. Make your changes.
4. Commit your changes (git commit -am 'Add new feature').
5. Push to the branch (git push origin feature-branch).
6. Create a new Pull Request.
