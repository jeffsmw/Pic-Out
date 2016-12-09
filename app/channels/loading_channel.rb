class LoadingChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'loading_channel'
  end

  def unsubscribed
  end

  def speak(data)
    ActionCable.server.broadcast 'loading_channel', message: data['message']
  end
end
