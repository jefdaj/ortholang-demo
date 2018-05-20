function autofill_repl(text) {
	i = $('#replinput');
	i.val(text); // TODO strip trailing newline here?
	i.focus();
}

$(document).ready(function(){
	var socket = io.connect('http://' + document.domain + ':' + location.port);

	// random numbers test:
	//connect to the socket server.
	var numbers_received = [];
	//receive details from server
	socket.on('newnumber', function(msg) {
		console.log("Received number" + msg.number);
		//maintain a list of ten numbers
		if (numbers_received.length >= 33){
			numbers_received.shift()
		}            
		numbers_received.push(msg.number);
		numbers_string = '<code>';
		for (var i = 0; i < numbers_received.length; i++){
			numbers_string = numbers_string + numbers_received[i].toString() + '<br/>';
		}
		numbers_string = numbers_string + '</code>'
		$('#reploutput').html(numbers_string);
	});

	// TODO would explicit disconnect help?
	// TODO figure out timeouts
	// var socket = io.connect('http://localhost:5000');

	// send a line to the repl when you click send
	$('#runstop').on('click', function() {
		socket.emit('repl input', $('#replinput').val());
		$('#replinput').val('')
	});
	$('#replinput').on('keypress', function(e) {
		if(e.which == 13) {
			socket.emit('repl input', $('#replinput').val());
			$('#replinput').val('');
		};
	});

	// display a line of output sent from the repl
	// TODO don't add the >> unless it was a line of input (don't send those from server at all?)
	socket.on('repl output', function(msg) {
		$('#reploutput').append(msg);
	});

	// submit a comment
	$('#commentbutton').on('click', function() {
		socket.emit('comment', $('#commentfield').val());
		$('#commentfield').val('')
		$('#commentfield').attr("placeholder", "Comment submitted. Leave another one if you want.")
		// TODO can I set the placeholder to say comment recieved?
	});

	// autofill repl with :load to load a previous script
	// TODO same issue with it disappearing as the save one below...
	$('#loadbutton').on('click', function() {
		autofill_repl(':load ' + $('#loadmenu').val())
	});

	// autofill repl input with :write to save a script
	$('#savebutton').on('click', function() {
		filename = $('#filename').val()
		if (filename != '') {
			autofill_repl(':write ' + filename)
		}
	});
	$('#filename').on('keypress', function(e) {
		if(e.which == 13) {
			// TODO have to strip out the newline or it auto-triggers the repl too?
			// TODO or maybe block default action so it doesn't get added at first
			autofill_repl(':write ' + $('#filename').val())
		};
	});

});
