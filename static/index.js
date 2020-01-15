var SOCKET = null;

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

function repl_autorun(lines, clear_first=true) {
	// clear terminal when loading a new script
	if (lines[0].startsWith(':l')) {
		setTimeout(repl_clear, 1000)
	}
	// awkward, but necessary for assigning genome table entries to variables:
	if (!clear_first) {
	  lines[0] = $('#replstdin').val() + lines[0];
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

function repl_autoload(script) { repl_autorun([':load ' + script]); }

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
	  add_script_to_load_menu(filename)
	}
}

function add_script_to_load_menu(filename) {
	$('#loadmenu').prepend('<option selected="selected" value="' + filename + '">' + filename + '</option>');
}

function openTab(evt, tabName) {
	// used to open the tabs as you click on them
	// TODO why can't this be replaced with the ByName version below?
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
	SOCKET.emit('settab', {'tabName': tabName});
}

function openTabByName(tabname) {
	// used to open the current tab on page load/refresh
	document.getElementById(tabname).style.display = "block";
	document.getElementById(tabname.toLowerCase() + 'button').className += " active";
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

function filters_match(filters, element_text) {
	var words = filters.split(' ');
	for (var w=0; w < words.length; w++) {
				if (element_text.indexOf(words[w]) == -1) {
								return false;
				}
	}
	return true;
}

function hide_element(element) {
	$(element).hide()
	var toc = $(element).attr('id') + '_toc'
	toc = document.getElementById(toc)
	if (toc !== null) { toc.style.display = "none"; }
}

function show_element(element) {
	$(element).show()
	var toc = $(element).attr('id') + '_toc'
	toc = document.getElementById(toc)
	if (toc !== null) { toc.style.display = "block"; }
}

// hide examples or module reference blocks that don't match the current filter
// based on: http://jsfiddle.net/reyjose/40u0var6/
function filter_searchable(box_id, element_selector){
	var filters = document.getElementById(box_id).value.toLowerCase();
	// console.log(filters);
	$(element_selector).each(function(){
			var text = $(this).text().toLowerCase();
			// console.log(text);
			filters_match(filters, text) ? show_element(this): hide_element(this);
	});
}

function filter_tutorial()    { filter_searchable('tutorialsearch'  , '#tutorial > .tutorialsection') };
function filter_data()        { filter_searchable('datasearch'      , '.datablock'                  ) };
function filter_modules()     { filter_searchable('modulesearch'    , '.moduleblock'                ) };
function filter_scripts()     { filter_searchable('scriptsearch'    , '#scripts > .codeblock'       ) };
function filter_userscripts() { filter_searchable('userscriptsearch', '#userscripts > .codeblock'   ) };

function login() {
	window.location.href = '/user';
	// supposedly this makes it wait for the page to load first
	$(function () {
		$('#usertabbutton').click();
	});
}

// Submits an invalid authentication header, causing the user to be 'logged out'
// based on: https://stackoverflow.com/a/30308402
function logout() {
	$.ajax({
		type: "GET",
		url: "/user",
		dataType: 'json',
		async: true,
		username: "guest",
		password: "logmeout",
		data: '{ "hack to clear http auth" }'
	})
	//In our case, we WANT to get access denied, so a success would be a failure.
	.done(function(){
		alert('Error!')
	})
	//Likewise, a failure *usually* means we succeeded.
	//set window.location to redirect the user to wherever you want them to go
	.fail(function(){
		window.location = "/";
	});
}

// TODO update to the new method
$(function(){

	// TODO would explicit disconnect help?
	SOCKET = io.connect('https://' + document.domain + ':' + location.port);

	// send a line to the repl when you click the button or press enter
	function run_line(line) {
		SOCKET.emit('replstdin', $('#replstdin').val());
		$('#replstdin').val('');
		//repl_disable();
	}
	$('#runkill').on('click', function() {
		$('#replstdin').focus();
		if (document.getElementById('runkill').innerHTML == 'Kill') {
			SOCKET.emit('replkill');
		} else {
			run_line($('#replstdin').val())
		}
	});
	on_enter('#replstdin', function() {
		run_line($('#replstdin').val());
	});

	// TODO replinput should be:
	//        disabled right after you run something?
	//        re-enabled after ortholang prints something, even a line break
	//        ... except not while it's still printing continuous lines
	SOCKET.on('replbusy', function(msg) {
		repl_disable();
	});
	SOCKET.on('replready', function(msg) {
		repl_enable();
	});

	// display server info
	SOCKET.on('serverload', function(nfo) {
		var txt = 'users:  ' + nfo.users + '<br/>'
			+ 'cpu:    ' + nfo.cpu   + '%<br/>'
			+ 'memory: ' + nfo.memory + '%';
		$('#serverload').html(txt);
	});

	appendReplStdoutLine = function(line) {
		var ro = document.getElementById('replstdout');
		if(line.indexOf('<img') != -1){
			// hack to display images in the repl
			var template = document.createElement('template');
			line = line.trim()
			template.innerHTML = line;
			var content = template.content.firstChild;
			ro.appendChild(content);
			ro.appendChild(document.createElement('br'));
			ro.appendChild(document.createElement('br'));
			// not sure why, but it doesn't scroll all the way without animation
			// see https://stackoverflow.com/a/10777978
			$('#replstdout').animate({scrollTop: 100000}, 100);
		} else {
			ro.appendChild(document.createTextNode(line));
			// don't want to animate all lines though because it locks scrollbar temporarily
			$('#replstdout').scrollTop(100000);
		}
	};

	// display a chunk of output sent from the repl
	SOCKET.on('replstdout', function(msg) {

		// this seems necessary to map over lines without adding an extra newline at the end
		var lines = msg.split('\n');
		lines = lines.map(function(l) { return(l + '\n'); });
		if (!msg.endsWith('\n')) {
			lines[lines.length-1] = lines[lines.length-1].slice(0, -1)
		}

		lines.map(appendReplStdoutLine);
	});

	// upload scripts
	// see https://www.accelebrate.com/blog/file-uploads-web-sockets-part-3-of-3/
	$('#uploadbutton').on('click', function(e) {
		var files = document.getElementById('upload').files;
		for (var x=0; x < files.length; x++) {
			var r = new FileReader();
			r.fileName = files[x].name;
			r.onloadend = function(e) {
				var n = e.target.fileName;
				SOCKET.emit('upload', {fileName: n, fileData: e.target.result});
				// if the file is an ol script, add it to the load menu
    			var ext = n.substring(n.lastIndexOf('.') + 1);
				if (ext == 'ol') {
					add_script_to_load_menu(n);
				}
			};
			r.readAsArrayBuffer(files[x]);
		}
	});

	// request script download
	$('#dlscript').on('click', function() {
		var filename = $('#filename').val()
		if (filename && filename != "") {
			// TODO auto-save with repl here?
			// TODO set repl to point to newly saved script too?
			SOCKET.emit('reqscript', {fileName: filename});
		} else {
			$('#filename').focus()
		}
	});

	// respond when script is sent
	SOCKET.on('dlscript', function(data) {
		download_file(data['scriptName'], data['scriptText'])
	});

	// same as script download, except simpler because no name
	$('#dlresult').on('click', function() { SOCKET.emit('reqresult'); });
	SOCKET.on('dlresult', function(data) {
		download_file(data['resultName'], data['resultText'])
	});

	SOCKET.on('replclear', function(data) {
		repl_clear();
	});


	// submit a comment
	$('#commentbutton').on('click', function() {
		SOCKET.emit('comment', $('#commentfield').val());
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

	// TODO any need to confirm exit now that named sessions resume?
	// window.onbeforeunload = confirmExit;
	// function confirmExit(){
		// alert("Leave the page? OrthoLang demo will be reset.");
		// return false;
	// }

	window.addEventListener('beforeunload', function(event) {
		SOCKET.disconnect();
	}, false);

	// tells the thread to bring back the current tab when page refreshed (or first loaded)
	SOCKET.emit('pagerefreshed');
	SOCKET.on('opentab', function(data) {
		openTabByName(data['tabName']);
	});

	filter_tutorial();
	filter_data();
	filter_modules();
	filter_scripts();
	filter_userscripts();

	$('#tutorialsearch'  ).keyup(filter_tutorial   );
	$('#datasearch'      ).keyup(filter_data       );
	$('#modulesearch'    ).keyup(filter_modules    );
	$('#scriptsearch'    ).keyup(filter_scripts    );
	$('#userscriptsearch').keyup(filter_userscripts);

	$('#loginbutton').on('click', login);
	$('#logoutbutton').on('click', logout);

	// TODO start on the collaborator tab if the user has a custom one?
	// document.getElementById('Collaborate').style.display = "block";
	// document.getElementById('collabbutton').className += " active";
});
