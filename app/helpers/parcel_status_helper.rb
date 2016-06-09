module ParcelStatusHelper
  def parcel_status_human(parcel)
    operation_summary(parcel.operations.last)
  end

  def operation_summary(operation)
    if operation.place.present?
      "#{operation.place} - #{translate_kind(operation.kind).downcase}"
    else
      translate_kind(operation.kind)
    end
  end
end
