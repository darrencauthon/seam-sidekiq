# Seam::ActiveRecord

Active Record support for seam.

## Installation

Add this line to your application's Gemfile:

    gem 'seam-active_record'

You'll also need to add the following migration script:

```ruby
class CreateSeamEfforts < ActiveRecord::Migration
  def change
    create_table :seam_efforts do |t|
      t.string :effort_id
      t.string :next_step
      t.datetime :next_execute_at
      t.boolean :complete
      t.text :data

      t.timestamps
    end
  end
end
```

## Usage

In an initializer or some other sort of your application's setup, call

```
Seam::ActiveRecord.setup
```

Now your workflows will be run through an ActiveRecord model, ```SeamEffort```.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
