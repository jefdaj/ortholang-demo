function autofill_repl(text) {
	i = $('#replstdin');
	i.val(text); // TODO strip trailing newline here?
	i.focus();
}

$(document).ready(function(){

	// TODO would explicit disconnect help?
	var socket = io.connect('http://' + document.domain + ':' + location.port);

	// send a line to the repl when you click the button or press enter
	function run_line(line) {
		socket.emit('replstdin', $('#replstdin').val());
		$('#replstdin').val('');
		$('#replstdin').focus();
	}
	$('#runstop').on('click', function() {
		run_line($('#replstdin').val())
	});
	$('#replstdin').on('keypress', function(e) {
		if(e.which == 13) {
			run_line($('#replstdin').val())
		};
	});

	// display server info
	socket.on('serverload', function(nfo) {
		var txt = 'users:  ' + nfo.users + '<br/>'
			+ 'cpu:    ' + nfo.cpu   + '%<br/>'
			+ 'memory: ' + nfo.memory + '%';
		$('#serverload').html(txt);
	});

	// display a line of output sent from the repl
	// TODO don't add the >> unless it was a line of input (don't send those from server at all?)
	socket.on('replstdout', function(msg) {
		var ro = document.getElementById('replstdout');
		if(msg.indexOf('<img') != -1){
			// hack to display images in the repl
			var template = document.createElement('template');
			msg = msg.trim()
			template.innerHTML = msg;
			var content = template.content.firstChild;
		} else {
			var content = document.createTextNode(msg);
		}
		ro.appendChild(content);
		$('#replstdout').scrollTop(100000);
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
			autofill_repl(':write ' + $('#filename').val())
		};
	});

	window.onbeforeunload = confirmExit;
	function confirmExit(){
		alert("Leave the page? ShortCut demo will be reset.");
		return false;
	}
	window.addEventListener('beforeunload', function(event) {
		socket.disconnect();
	}, false);

});
