function press_return(id) {
	var e = jQuery.Event("keypress");
	e.which = 13;
	e.keyCode = 13;
	$(id).trigger(e);
}

function on_enter(id, fn) {
	$(id).on('keypress', function(e) {
		// TODO have to disable this too when repl disabled?
		if(e.which == 13) {
			fn();
		};
	});
}

// see https://stackoverflow.com/a/3955238
function repl_clear() {
	var repl = document.getElementById("replstdout");
	while (repl.lastChild) {
		repl.removeChild(repl.lastChild);
	}
}

function repl_autorun(lines) {
	// clear terminal when loading a new script
	if (lines[0].startsWith(':l')) {
		setTimeout(repl_clear, 1000)
	}
	// use timeouts + recursion to create a loop with delay each iteration
	// see https://stackoverflow.com/a/3583740
	var i = 0;
	function runLines() {
		setTimeout(function () {
			$('#replstdin').val(lines[i]); // TODO strip trailing newline here?
			// $('#replstdin').focus();
			setTimeout(function() { press_return('#replstdin'); }, 500)
			i++;
			if (i<lines.length) { runLines(); }
		}, 1000)
	}
	$('#replstdin').focus();
	runLines();
}

function repl_autoload(script) { repl_autorun([':load ' + script, ':show']); }

function repl_enable() {
	document.getElementById('replstdin').disabled = false;
	document.getElementById('replstdin').focus();
	document.getElementById('runkill').innerHTML = 'Run';
}

function repl_disable() {
	document.getElementById('replstdin').disabled = true;
	document.getElementById('runkill').innerHTML = 'Kill';
	document.getElementById('runkill').focus();
}

function repl_write(filename) {
	var filename = $('#filename').val()
	if (filename == '') {
		$('#filename').focus();
	} else {
		repl_autorun([':write ' + filename]);
	}
}

function openTab(evt, tabName) {
	var i, tabcontent, tablinks;
	tabcontent = document.getElementsByClassName("tabcontent");
	for (i = 0; i < tabcontent.length; i++) {
		tabcontent[i].style.display = "none";
	}
	tablinks = document.getElementsByClassName("tablinks");
	for (i = 0; i < tablinks.length; i++) {
		tablinks[i].className = tablinks[i].className.replace(" active", "");
	}
	document.getElementById(tabName).style.display = "block";
	evt.currentTarget.className += " active";
}

// present a text file as a download to the user
// have to create a temporary link and click it apparently
// see https://stackoverflow.com/a/15832662
// see https://stackoverflow.com/questions/13405129/javascript-create-and-save-file
function download_file(name, text) {
	var file = new Blob([text], {type: 'text/plain'});
	var link = document.createElement("a");
	link.download = name;
	link.href = URL.createObjectURL(file);
	document.body.appendChild(link);
	link.click();
	document.body.removeChild(link);
	delete link;
}

$(document).ready(function(){

	// TODO would explicit disconnect help?
	var socket = io.connect('http://' + document.domain + ':' + location.port);

	// send a line to the repl when you click the button or press enter
	function run_line(line) {
		socket.emit('replstdin', $('#replstdin').val());
		$('#replstdin').val('');
		//repl_disable();
	}
	$('#runkill').on('click', function() {
		$('#replstdin').focus();
		if (document.getElementById('runkill').innerHTML == 'Kill') {
			socket.emit('replkill');
		} else {
			run_line($('#replstdin').val())
		}
	});
	on_enter('#replstdin', function() {
		run_line($('#replstdin').val());
	});

	// TODO replinput should be:
	//        disabled right after you run something?
	//        re-enabled after shortcut prints something, even a line break
	//        ... except not while it's still printing continuous lines
	socket.on('replbusy', function(msg) {
		repl_disable();
	});
	socket.on('replready', function(msg) {
		repl_enable();
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
			ro.appendChild(content);
			ro.appendChild(document.createElement('br'));
			ro.appendChild(document.createElement('br'));
			// not sure why, but it doesn't scroll all the way without animation
			// see https://stackoverflow.com/a/10777978
			$('#replstdout').animate({scrollTop: 100000}, 100);
		} else {
			ro.appendChild(document.createTextNode(msg));
			// don't want to animate all lines though because it locks scrollbar temporarily
			$('#replstdout').scrollTop(100000);
		}
	});

	// upload scripts
	// TODO other files too like fasta
	// see https://www.accelebrate.com/blog/file-uploads-web-sockets-part-3-of-3/
	$('#uploadbutton').on('click', function(e) {
		var files = document.getElementById('upload').files;
		for (var x=0; x < files.length; x++) {
			var reader = new FileReader();
			var name = files[x].name;
			reader.addEventListener('loadend', function() {
				socket.emit('upload', {fileName: name, fileData: reader.result});
				repl_autoload(name);
			});
			reader.readAsArrayBuffer(files[x]);
		}
	});

	// request script download
	$('#dlscript').on('click', function() {
		var filename = $('#filename').val()
		if (filename && filename != "") {
			// TODO auto-save with repl here?
			// TODO set repl to point to newly saved script too?
			socket.emit('reqscript', {fileName: filename});
		} else {
			$('#filename').focus()
		}
	});

	// respond when script is sent
	socket.on('dlscript', function(data) {
		download_file(data['scriptName'], data['scriptText'])
	});

	// same as script download, except simpler because no name
	$('#dlresult').on('click', function() { socket.emit('reqresult'); });
	socket.on('dlresult', function(data) {
		download_file(data['resultName'], data['resultText'])
	});

	// submit a comment
	$('#commentbutton').on('click', function() {
		socket.emit('comment', $('#commentfield').val());
		$('#commentfield').val('')
		$('#commentfield').attr("placeholder", "Comment submitted. Leave another one if you want.")
		// TODO can I set the placeholder to say comment recieved?
	});

	// autorun repl with :load to load a previous script
	// TODO same issue with it disappearing as the save one below...
	$('#loadbutton').on('click', function() {
		repl_autoload($('#loadmenu').val());
	});

    // autorun repl input with :write to save a script
	$('#savebutton').on('click', repl_write);
	on_enter('#filename', repl_write);

	window.onbeforeunload = confirmExit;
	function confirmExit(){
		alert("Leave the page? ShortCut demo will be reset.");
		return false;
	}
	window.addEventListener('beforeunload', function(event) {
		socket.disconnect();
	}, false);

	// show intro tab when page first loaded
	// TODO go back to this way once the site is set up
	// document.getElementById('Intro').style.display = "block";
	// document.getElementById('introbutton').className += " active";

	document.getElementById('Collaborate').style.display = "block";
	document.getElementById('collabbutton').className += " active";
});
