class Operation < ActiveRecord::Base
  belongs_to :user
  belongs_to :parcel

  validates :kind, :parcel, presence: true
  validate :operation_dealing_with_parcels_has_a_place
  validate :creation_is_parcels_first_operation
  validate :operation_is_permitted_for_parcel

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

  after_create :set_correct_parcel_status

  private

  def operation_dealing_with_parcels_has_a_place
    unless place.present? || ['order_created', 'order_accepted', 'order_rejected'].include?(kind)
      errors.add(:place, :blank)
    end
  end

  def creation_is_parcels_first_operation
    if kind == 'order_created' && parcel.operations.count != 0
      errors.add(:kind, :invalid)
    end
  end

  def operation_is_permitted_for_parcel
    unless parcel && allowed_states[kind].include?(parcel.status)
      errors.add(:kind, :invalid_for_this_parcel)
    end
  end

  def allowed_states
    # defines, what states should the parcel be in for the operation to be permitted
    # as people (and computers) make errors, it's possible to skip some operations.
    # it's not possible to go back, though
    {
      'order_created' => ['pending'],
      'order_accepted' => ['pending', 'rejected'],
      'order_rejected' => ['pending', 'accepted'],
      'parcel_picked_up' => ['pending', 'accepted'],
      'parcel_in_sorting_facility' => ['pending', 'accepted', 'in_transit'],
      'parcel_in_transit' => ['pending', 'accepted', 'in_transit'],
      'parcel_in_delivery' => ['pending', 'accepted', 'in_transit'],
      'parcel_delivered' => ['pending', 'accepted', 'in_transit']
    }
  end

  def set_correct_parcel_status
    parcel.update(status: new_parcel_status[kind])
  end

  def new_parcel_status
    # defines, which parcel status should be ensured after the operation
    {
      'order_created' => 'pending',
      'order_accepted' => 'accepted',
      'order_rejected' => 'rejected',
      'parcel_picked_up' => 'in_transit',
      'parcel_in_sorting_facility' => 'in_transit',
      'parcel_in_transit' => 'in_transit',
      'parcel_in_delivery' => 'in_transit',
      'parcel_delivered' => 'delivered'
    }
  end
end
