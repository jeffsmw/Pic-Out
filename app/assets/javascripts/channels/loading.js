App.loading = App.cable.subscriptions.create("LoadingChannel", {
  connected: function() {},
  disconnected: function() {},
  received: function(data) {
    $('#footer').slideUp(200);
    $('#info').slideUp(400);
    $('#jumbotron').slideUp(800);
    $('#channel').append(
      '<img src="'+data['thumb']+
      '" class="search-image" onClick="lightbox(this.src)" data-slug="'+data['message']+'" data-link="'+data['restaurant']+'"/>'
    );
    $('.search-image').on('click', function(){
      $('#lightbox-image').attr('src', this.src);
      $('#btn1').show();
      $('#btn1').attr('href', ('/restaurants/' + this.dataset.link));
      $('#btn2').attr('href', ('https://www.instagram.com/p/' + this.dataset.slug));
      $('#lightbox').fadeIn(200);
    })
  },
  speak: function(data_request) {
    return this.perform('speak', {
      message: data_request
    });
  }
});
