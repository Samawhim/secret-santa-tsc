class EventsController < ApplicationController

  def show
    @event = Event.find(params[:id])
    @participants = make_santas(@event.participants.all)
  end

  def new
    @event = Event.new
    @event.participants.build
    @event.participants.build
    @event.participants.build
    @participant = Participant.new
  end
  
  def create
    @events = Event.all
    @event = Event.new(event_params)
    if @event.save # && @participants.count > 3
      flash[:alert] = "L'événement s'est bien crée. Un email vous a été envoyé"
      @participants = make_santas(@event.participants.all)
      @participants.each do |participant|
        # EventMailer.with(participant: participant.id).santa_email(participant, participant.santa).deliver_now
        EventMailer.santa_email(participant, participant.santa).deliver_now
      end
      @event.destroy
      redirect_to root_path
    else
      flash[:alert] = "L'événement ne s'est pas sauvegardé"
      render :new and return
    end
  end

  def delete
    @participant = Participant.find(params[:id])
    @participant.destroy

    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { head :no_content }
      format.js { render layout: false }
    end
  end

  private
  
  def make_santas(list_of_participants)
    participants = list_of_participants.to_a
    santas = participants.dup 
    
    participants.each do |participant|
      n = rand(santas.count)
      participant.santa = santas[n]
      santas.delete_at(n)
    end

    participants.each do |participant|
      next if can_be_santa_of_person?(participant.santa, participant) 

      candidates = participants.select do |candidate|
        can_be_santa_of_person?(candidate.santa, participant) && can_be_santa_of_person?(participant.santa, candidate)
      end

      n = rand(candidates.count)
      other_participant = candidates[n]
      actual_santa = participant.santa
      participant.santa = other_participant.santa
      other_participant.santa = actual_santa
    end

    return participants
  end

  def can_be_santa_of_person?(santa, person)
    santa.email != person.email && santa.name != person.name
  end

  def event_params
    params.require(:event).permit(:title, :max_price, participants_attributes:[:name, :email])
  end
end