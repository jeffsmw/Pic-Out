class EventsController < ApplicationController
  def new
    @event = Event.new
    respond_to do |format|
      format.js { render :new }
      format.html { render :new }
    end
  end

  def create
    event_params = params.require(:event).permit(:title,
                                                 :date,
                                                 :time,
                                                 :address,
                                                 :description,
                                                 :min)
    @event = Event.new event_params
    @event.creator = current_user.id

    if @event.save
      participants = params[:participants][0].gsub(', ', ',')
      pArray = participants.split(',')
      send_invites(pArray)
    else
      flash.now[:alert] = 'Your event was not created'
      render :new
    end

    respond_to do |format|
      format.js { render :show }
      format.html { render :show }
    end
  end

  def show
    @event = Event.find_by(id: params[:id])
    @attending = Invitation.where(event_id: @event.id).where(answer: true).count
    @invite = Invitation.where(user: current_user, event: @event.id)
    respond_to do |format|
      format.js { render :show }
      format.html { render :show }
    end
  end

  def update
    @event = Event.find_by(id: params[:id])

    u = Invitation.where(user_id: current_user.id).find_by(event_id: @event.id)
    if u.answer == false
      u.answer = true
      u.save
    else
      u.answer = false
      u.save
    end

    @attending = Invitation.where(event_id: @event.id).where(answer: true).count
    @invite = Invitation.where(user: current_user, event: @event.id)

    respond_to do |format|
      format.js { render :show }
      format.html { render :show }
    end
  end

  def send_invites(array)
    array.each do |a|
      unless User.find_by(email: a).nil?
        user = User.find_by(email: a)
        invite = Invitation.create(event_id: @event.id, user_id: user.id, answer: false)
        invite.save
      end
    end
  end
end
