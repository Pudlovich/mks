class OrderMailer < ApplicationMailer
  def order_created_mail(parcel)
    @parcel = parcel
    mail(to: @parcel.sender_info.email, subject: 'MKS Express - potwierdzenie zamówienia')
  end

  def order_rejected_mail(parcel)
    @parcel = parcel
    mail(to: @parcel.sender_info.email, subject: 'MKS Express - odrzucono zlecenie')
  end

  def order_accepted_sender_mail(parcel)
    @parcel = parcel
    mail(to: @parcel.sender_info.email, subject: 'MKS Express - przyjęto zlecenie')
  end

  def order_accepted_recipient_mail(parcel)
    @parcel = parcel
    mail(to: @parcel.recipient_info.email, subject: 'MKS Express - utworzono zamówienie')
  end

  def parcel_sent_mail(parcel)
    @parcel = parcel
    mail(to: @parcel.recipient_info.email, subject: 'MKS Express - nadano przesyłkę')
  end

  def parcel_in_delivery_mail(parcel)
    @parcel = parcel
    mail(to: @parcel.recipient_info.email, subject: 'MKS Express - przesyłka w doręczeniu')
  end

  def parcel_delivered_sender_mail(parcel)
    @parcel = parcel
    mail(to: @parcel.sender_info.email, subject: 'MKS Express - doręczono przesyłkę')
  end

  def parcel_delivered_recipient_mail(parcel)
    @parcel = parcel
    mail(to: @parcel.recipient_info.email, subject: 'MKS Express - potwierdzenie odbioru przesyłki')
  end
end
