describe 'Rack application response' do
  before { visit '/' }

  it 'has a env string on title tag' do
    expect(page.title).to match /^\(test\).*/
  end

  it 'has a env ribbon on body tag' do
    expect(
      page.find('body').find('.github-fork-ribbon').has_content?('test')
    ).to be_truthy
  end
end
