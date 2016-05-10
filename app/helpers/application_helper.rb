module ApplicationHelper
  def number_to_kg(number)
    #delegated to a helper so the format is DRY and constant through the application
    number_with_precision(number, precision: 1)+' kg'
  end

  def number_to_cm(number)
    #delegated to a helper so the format is DRY and constant through the application
    number_with_precision(number, precision: 0)+' cm'
  end
end
