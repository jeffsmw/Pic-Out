App.loading = App.cable.subscriptions.create("LoadingChannel", {
  connected: function() {},
  disconnected: function() {},
  received: function(data) {
    return $('#search-results').append(
      // '<a href="https://www.instagram.com/p/'+ data['message']+
      // '"><img src="'+data['thumb']+
      // '" height="100" width="100"/></a>'
      '<img src="'+data['thumb']+
      '" height="100" width="100" onClick="lightbox(this.src)"/>'
    );
  },
  speak: function(data_request) {
    return this.perform('speak', {
      message: data_request
    });
  }
});
