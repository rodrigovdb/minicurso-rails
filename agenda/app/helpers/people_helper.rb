module PeopleHelper
  def date_to_br(date)
    return if date.nil?

    date.strftime('%d/%m/%Y')
  end
end
