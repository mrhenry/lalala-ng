

exports.init = function(){

  //
  // this implements lib/moment.js
  //
  // look up timeago timestamp's and process them
  // to nice and readable strings
  // (e.g.: 2 minutes ago)
  $('.timeago').each(function(index){

    // get date-time
    var date_utc_format = $(this).text().substr(0,$(this).text().length-4);
    var date_formatted = moment.utc(date_utc_format);

    // adjust to local time
    var result = date_formatted.local();

    // write result into selector text()
    $(this).text(result.fromNow());

  });

};

