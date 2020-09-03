class EventMailer < ApplicationMailer
  def santa_email(participant, santa)
    @participant = participant
    @santa = santa
    mail(
      to: participant.email,
      subject: 'Découvre ton secret santa ;)'
    )
  end
end