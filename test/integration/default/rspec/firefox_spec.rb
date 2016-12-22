require 'rspec_helper'

describe 'Firefox Grid' do
  before(:all) do
    Selenium::WebDriver::Firefox.path = 'C:\Program Files (x86)\Mozilla Firefox\firefox.exe'
    profile = Selenium::WebDriver::Firefox::Profile.new
    profile.proxy = Selenium::WebDriver::Proxy.new(http: nil)
    @selenium = Selenium::WebDriver.for :firefox, profile: profile
  end

  after(:all) do
    @selenium.quit
  end

  it 'Should return display resolution of 1366 x 768' do
    @selenium.get 'http://www.whatismyscreenresolution.com/'
    element = @selenium.find_element(:id, 'resolutionNumber')
    expect(element.text).to eq(res)
  end
end
