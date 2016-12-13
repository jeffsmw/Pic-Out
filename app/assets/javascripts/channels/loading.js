App.loading = App.cable.subscriptions.create("LoadingChannel", {
  connected: function() {},
  disconnected: function() {},
  received: function(data) {
    return $('#channel').append(
      '<img src="'+data['thumb']+
      '" class="search-image" onClick="lightbox(this.src)"/>'
    );
  },
  speak: function(data_request) {
    return this.perform('speak', {
      message: data_request
    });
  }
});
