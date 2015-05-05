require 'rails_helper'

RSpec.describe Newsletter::Engine do
  it "can set table prefix to empty" do
    Newsletter.table_prefix = nil
    conf = Newsletter::Settings.new(
      'spec/support/files/newsletter_empty_table_prefix.yml')
    Newsletter.initialize_with_config(conf)
    expect(Newsletter.table_prefix).to eq ''
  end
end
