module ApplicationHelper
  def class_name(type)
    if type.to_s == 'notice'
      "alert alert-success"      
    elsif type.to_s == 'error'
      "alert alert-danger"
    else
      "alert alert-warning"
    end
  end
end
