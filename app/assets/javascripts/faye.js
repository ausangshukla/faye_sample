$(function() {
  var faye = new Faye.Client('http://localhost:9292/faye');
  faye.disable("websocket")
  Faye.Logging.logLevel = 'debug'
	  
  faye.subscribe('/messages/new', function (data) {
	  eval(data);
  });
  
  
  faye.bind("transport:down", function() {
    console.log("##### transport:down");
  });
  return faye.bind("transport:up", function() {
	  console.log("##### transport:up");
  });
  
});