var $window = $(window);
var $document = $(document);

//Status vars

var $status = "idle";
var $mustBindKey = true;

var DwItApi = {
  resolveUrl: function(url, completion, error) {
    if ($status != "idle") return;
    else $status = "busy";

    $.ajax({
      method: "POST",
      url: "scraper",
      dataType: 'json',
      data: { url: url }
    }).done(completion).fail(error).always(function() {
      $status = "idle";
    });
  }
}

$document.ready(function() {
  keysBinding();
});

function keysBinding() {
  if ($mustBindKey == false) return;

  $mustBindKey = true;
  $('input.holo').bind("enterKey",function(e){
    var url = $(this).val();
    $(this).blur();
    scrollToStart();
    performRequest(url);
  });
  $('input.holo').keyup(function(e){
      if(e.keyCode == 13) {
          $(this).trigger("enterKey");
      }
  });
}

// UI states

function scrollToStart() {
  $('html, body').animate({
    scrollTop: ($("div.field-container").offset().top - 30)
  }, 800);
}

function showSpinner() {
  $('.spinner').css("visibility", "visible");
  var duration = $('#download').is(':hidden') ? 0 : 400;
  $('#download').slideUp(duration);
  duration = $('#error').is(':hidden') ? 0 : 400;
  $('#error').slideUp(duration);
}

function hideSpinner() {
  $('.spinner').css("visibility", "hidden");
}

function showErrorMessage(error) {
  $('h2.error-title').text(error);
  $('#error').slideDown({
    duration: 500
  });
}

function showDownloadDetails(video) {
  $('.result-name').text(video.title);
  $('.result-link').attr('href', "");
  $('.result-link').attr('download', "");
  $('.download-text').html(createDownloadLinks(video.title, video.video_links));
  $('#download').css("background-image", "url(\"" + video.thumbnail + "\")");

  $('#download').slideDown({
    duration: 500,
    progress: function(animation, progress, remainingMs) {
      changeOpacity('.video-info', progress);
      transformY('.video-info', -(1-progress)*100);
    },
    complete: function() {
      changeOpacity('.video-info', 1);
      transformY('.video-info', 0);
    }
  });
}

function createDownloadLinks(title, links) {
  var linksHtml = "";
  for (var i in links) {
    var filename = title + "." + links[i].extension;
    linksHtml += '<a class="result-link" download="'+ filename +'" href='+ links[i].url +'>'+ links[i].height + ' (.'+ links[i].extension +')</a>&nbsp;&nbsp;&nbsp;';
  }
  return linksHtml;
}

function changeOpacity(id, opacity) {
  $(id).css('opacity', opacity);
  $(id).css('filter','alpha(opacity='+ (opacity*100) +')');
}

// URL resolve stuff

function performRequest(url) {
  showSpinner();
  DwItApi.resolveUrl(url, function(result) {
    if (result.status == "wait") {
      setTimeout("performRequest('"+ url +"');", 200);
    }
    else if (result.status == "success") {
      hideSpinner();
      showDownloadDetails(result.video);
    }
    else {
      hideSpinner();
      showErrorMessage(result.message);
    }
  }, function() {
    hideSpinner();
    showErrorMessage("something went wrong");
  });
}

// While scrolling animations

var $previousScroll = 0;

$window.scroll(function() {
    var text_offset = (-1 * $window.scrollTop())*2;
    transformY(".welcome-container", text_offset);
    animateMediaIcons($window.scrollTop());
});

function animateMediaIcons(offset) {
  var tags = ["#youtube", "#vimeo", "#vine"];
  for (i = 0; i < 3; i++) {
    if (offset >= (60*i) || offset < $previousScroll) {
      var iconOffset = -1 * (offset-(60*i));
      if (iconOffset <= 0) {
        transformY(tags[i], iconOffset);
        continue;
      }
    }
    transformY(tags[i], 0);
  }

  $previousScroll = offset;
}

function transformY(id, offset) {
  $(id).css("-webkit-transform", "translateX(0) translateY("+ offset +"px)");
  $(id).css("transform", "translateX(0) translateY("+ offset +"px)");
}
