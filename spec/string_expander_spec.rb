require 'general/string_expander'

describe 'Expand string' do
  context 'nil params' do
    it 'should leave string untouched' do
      'Hi there. This is a string with a KEY and a VALUE in it.'.format_string_with_hash(nil).should eq('Hi there. This is a string with a KEY and a VALUE in it.')
    end
  end
  context 'no params' do
    it 'should leave string untouched' do
      'Hi there. This is a string with a KEY and a VALUE in it.'.format_string_with_hash({}).should eq('Hi there. This is a string with a KEY and a VALUE in it.')
    end
  end
  context 'one param' do
    it 'should leave string untouched' do
      'Hi there. This is a string with a KEY and a VALUE in it.'.format_string_with_hash({:key => 'foo'}).should eq('Hi there. This is a string with a foo and a VALUE in it.')
    end
  end
  context 'all params' do
    it 'should leave string untouched' do
      'Hi there. This is a string with a KEY and a VALUE in it.'.format_string_with_hash({:key => 'foo', :value => 'bar'}).should eq('Hi there. This is a string with a foo and a bar in it.')
    end
  end
  context 'excess params' do
    it 'should leave string untouched' do
      'Hi there. This is a string with a KEY and a VALUE in it.'.format_string_with_hash({:key => 'foo', :value => 'bar', :there => 'zot'}).should eq('Hi there. This is a string with a foo and a bar in it.')
    end
  end
end
