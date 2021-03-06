require 'rails_helper'

RSpec.describe Search do
  it 'returns empty list when query is empty' do
    search = Search.new('')
    expect(search.results).to eq([])
    expect(search.errors).to eq([])
  end

  it 'adds an error if a field is not supported' do
    search = Search.new('unknown:1')
    expect(search.results).to eq([])
    expect(search.errors).to eq(['Unsupported field `unknown`.'])
  end

  it 'sets up where clauses for supported fields' do
    search = Search.new('id:1')
    expect(search.where_clauses).to eq({'id' => '1'})
  end

  it 'adds name queries for tags and domains if name is a field' do
    search = Search.new('name:thing')
    expect(search.where_clauses).to eq({
      'name' => 'thing',
      'tags' => { 'name' => 'thing' },
      'domains' => { 'name' => 'thing' },
    })
  end

  it 'supports multiple queries' do
    search = Search.new('ticket_type:bug id:2')
    expect(search.where_clauses).to eq({
      'ticket_type' => 'bug',
      'id' => '2'
    })
  end

  it 'finds user by ID' do
    user = create(:user)
    search = Search.new("id:#{user.id}", [User])
    expect(search.results.length).to eq(1)
  end

  it 'finds user by external_id' do
    user = create(:user)
    search = Search.new("external_id:#{user.external_id}", [User])
    expect(search.results.length).to eq(1)
  end

  it 'ignores all query options that are missing colon' do
    create(:user)
    search = Search.new('thing', [User])
    expect(search.results).to eq([])
    expect(search.errors)
      .to include('Queries must be in the form <field>:<value>.')
  end

  it 'finds users by tag' do
    user = create(:user)
    create(:tag, taggable: user, name: 'test')
    search = Search.new('name:test', [User.left_outer_joins(:tags)])
    expect(search.results).to eq([user])
  end
end
