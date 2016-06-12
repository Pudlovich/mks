class OrderMailer < ApplicationMailer
  def order_created_mail(parcel)
    @parcel = parcel
    mail(bcc: [@parcel.sender_info.email, @parcel.recipient_info.email], subject: 'TEMAT MAILA')
  end

  def parcel_sent_mail(parcel)
    @parcel = parcel
    mail(to: @parcel.recipient_info.email, subject: 'TEMAT MAILA')
  end

  def parcel_in_delivery_mail(parcel)
    @parcel = parcel
    mail(to: @parcel.recipient_info.email, subject: 'TEMAT MAILA')
  end

  def parcel_delivered_mail(parcel)
    @parcel = parcel
    mail(bcc: [@parcel.sender_info.email, @parcel.recipient_info.email], subject: 'TEMAT MAILA')
  end
end
