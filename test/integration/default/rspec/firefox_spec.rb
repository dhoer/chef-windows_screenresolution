require 'rspec_helper'

describe 'Firefox Grid' do
  before(:all) do
    @selenium = Selenium::WebDriver.for :firefox
  end

  after(:all) do
    @selenium.quit
  end

  res = '1366 x 768'

  it "Should return display resolution of #{res}" do
    @selenium.get 'http://www.whatismyscreenresolution.com/'
    element = @selenium.find_element(:id, 'resolutionNumber')
    expect(element.text).to eq(res)
  end
end
