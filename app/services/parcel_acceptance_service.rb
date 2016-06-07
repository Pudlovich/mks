class ParcelAcceptanceService

  def initialize(parcel, status, author=nil, additional_info=nil)
    @parcel = parcel
    @status = status
    @author = author
    @additional_info = additional_info
  end

  def call
    return false unless valid_request
    Parcel.transaction do
      Operation.create!(parcel: @parcel, kind: operation_kind, user: @author, additional_info: @additional_info)
      true
    end
  end

  private

  def valid_request
    (['accepted', 'rejected'].include? @status) && (@parcel.status != @status)
  end

  def operation_kind
    return 'order_accepted' if @status == 'accepted'
    return 'order_rejected' if @status == 'rejected'
  end
end
