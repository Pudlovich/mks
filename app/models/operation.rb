class Operation < ActiveRecord::Base
  belongs_to :user
  belongs_to :parcel

  validates :kind, :parcel, presence: true
  validate :operation_dealing_with_parcels_has_a_place

  scope :newest_first, -> { order(created_at: :desc) }

  delegate :email, to: :user, prefix: :author

  enum kind: {
    order_created: 0,
    order_accepted: 1,
    order_rejected: 2,
    parcel_picked_up: 3,
    parcel_in_sorting_facility: 4,
    parcel_in_transit: 5,
    parcel_in_delivery: 6,
    parcel_delivered: 7
  }

  private

  def operation_dealing_with_parcels_has_a_place
    unless place.present? || ['order_created', 'order_accepted', 'order_rejected'].include?(kind)
      errors.add(:place, :blank)
    end
  end
end
