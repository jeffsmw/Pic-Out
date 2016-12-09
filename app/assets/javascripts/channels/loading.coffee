App.loading = App.cable.subscriptions.create "LoadingChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # alert(data['message'])
    # $('#chat_log').append('<img src="'+data['message']+'" height="100" width="100">')
    $('#chat_log').append(data['message']+'<br />')
    # console.log(data)


  speak: (data_request)->
    @perform 'speak', message: data_request

$(document).on 'keypress', '[data-behavior~=loading_speaker]', (event) ->
  if event.keyCode is 13 # return/enter = send
    App.loading.speak event.target.value
    event.target.value = ''
    event.preventDefault()
