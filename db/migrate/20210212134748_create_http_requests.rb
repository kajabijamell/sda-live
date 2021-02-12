class CreateHttpRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :http_requests do |t|
      t.text :url
      t.json :body
      t.integer :type_of_request
      t.json :response_body
      t.string :response_code
      t.integer :entity_id
      t.string :entity_type

      t.timestamps
    end
  end
end
