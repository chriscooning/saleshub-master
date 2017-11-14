class Services::Surveys < ::Services::Base
  def build
    Survey.new
  end

  def create(author, attributes)
    author.surveys.create(attributes)
  end
end