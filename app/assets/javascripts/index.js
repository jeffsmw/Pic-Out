var reenableSearch = function(){
  $('#search-button').attr('disabled',false);
}

var lightbox = function(){
  $('#lightbox').fadeToggle(200);
}

$(function(){
  // $('.image-btn #btn2').on('click', function (e){
  //   console.log(this);
  // });

  // $( "a" ).click(function( event ) {
  //   event.preventDefault();
  //   $( "<div>" )
  //     .append( "default " + event.type + " prevented" )
  //     .appendTo( "#log" );
  // });
  //

  $('.image-btn').on('click'), function(e) {
    e.preventDefault();
  }
})
