var lightbox = function(_src){
  $('#lightbox-image').attr('src', _src);
  $('#lightbox').fadeIn(200);
};

var closeLightbox = function(){
  $('#lightbox').fadeOut(200);
}

var reenableSearch = function(){
  $('#search-button').attr('disabled',false);
}
