module ParcelStatusHelper
  def parcel_status_human(parcel)
    if parcel.operations.last.place.present?
      "#{parcel.operations.last.place} - #{translate_kind(parcel.operations.last.kind).downcase}"
    else
      translate_kind(parcel.operations.last.kind)
    end
  end
end
