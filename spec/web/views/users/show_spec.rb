RSpec.describe Web::Views::Users::Show, type: :view do
  let(:exposures) { { format: :html, user: user } }
  let(:user) { User.new(first_name: 'Penelope', email: 'penelope@cruz.com') }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/users/show.html.erb') }
  let(:view)      { described_class.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    expect(view.format).to eq exposures.fetch(:format)
  end

  it 'exposes #user' do
    expect(view.user).to eq user
  end
end
