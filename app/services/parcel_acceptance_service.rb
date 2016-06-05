class ParcelAcceptanceService

  def initialize(parcel, acceptance_status, author=nil, additional_info=nil)
    @parcel = parcel
    @acceptance_status = acceptance_status
    @author = author
    @additional_info = additional_info
  end

  def call
    return false unless valid_request
    Parcel.transaction do
      @parcel.update!(acceptance_status: @acceptance_status)
      Operation.create!(parcel: @parcel, kind: operation_kind, user: @author, additional_info: @additional_info)
      true
    end
  end

  private

  def valid_request
    (['accepted', 'rejected'].include? @acceptance_status) && (@parcel.acceptance_status != @acceptance_status)
  end

  def operation_kind
    return 'order_accepted' if @acceptance_status == 'accepted'
    return 'order_rejected' if @acceptance_status == 'rejected'
  end
end
