shortcut-demo
=============

An interactive web demo + tutorial for [ShortCut][1].
Try the live version at [shortcut.pmb.berkeley.edu](https://shortcut.pmb.berkeley.edu)!

Install as a NixOS service
--------------------------

This is the easiest way to set it up, but requires NixOS.
Probably a good choice if you're making a dedicated server.
Just add something like this to your `/etc/nixos/configuration.nix`:

```.nix
{
  imports =
    [ ...
      /home/jefdaj/shortcut-demo/service.nix
    ];

  ...

  services.shortcutDemo = {
    enable      = true;
    user        = "jefdaj";
    scratchDir  = "/tmp/shortcut-demo";
    logPath     = "/tmp/shortcut-demo.log";
    examplesDir = "/mnt/data/examples";
    commentsDir = "/mnt/data/comments";
    uploadsDir  = "/mnt/data/uploads";
    port        = 45772;
  };

  ...

}
```

Install using Nix on another distro
-----------------------------------

You can also run it on another linux distro, or probably Mac OSX.
First, nix-build `shortcut` and add it to your `PATH`.
Note that you still need Nix for this.

Then run the server the [Nix][2] way:

```.bash
nix-shell requirements.nix --command \
  ./shortcut-demo.py \
    -l /tmp/shortcut-demo.log \
    -e examples \
    -c comments \
    -t /tmp/shortcut-demo \
    -p 5000 \
    -s /mnt/data/shortcut-users' \
    -a /mnt/data/shortcut-users/passwords.txt
```

... or the regular Debian + Python way:

```.bash
# TODO need python-twisted-bin too?
sudo apt-get install python-dev
virtualenv .venv
source .venv/bin/activate
pip install -r requirements.txt
./shortcut-demo.py \
  -l /tmp/shortcut-demo.log \
  -e examples \
  -c comments \
  -t /tmp/shortcut-demo \
  -p 5000 \
  -s /mnt/data/shortcut-users' \
  -a /mnt/data/shortcut-users/passwords.txt
```

Finally, visit `localhost:5000` in your browser.

Gotchas:

* do *not* install actual websockets stuff (gevent, eventlets, etc) as that seems to break it
* when updating `requirements.nix` you might have to manually remove
  some dependencies on `self."Twisted"` to fix an infinite recursion bug

Serve
-----

This is a terrible idea from a security perspective,
but the fastest way to access it from elsewhere on the local network is:

```.bash
sudo sysctl -w net.ipv4.conf.all.route_localnet=1
sudo iptables -t nat -I PREROUTING -p tcp --dport 5000 -j DNAT --to 127.0.0.1:80
```

Replace `5000` with whatever port you want.

Files
-----

The server will put tmpfiles in `./tmpdirs`. Consider linking that to `/tmp` or
a ramdisk if IO becomes an issue. It will also save user comments in `./comments`.

Updating the docs
-----------------

This part is a little awkward. It uses the `shortcut` submodule to generate `templates/reference.md`
and check the example scripts. Do something like:

``` .bash
git submodule update --init --recursive
nix-shell docs.nix --command 'stack build && stack exec docs'
```

TODOs
-----

layout:

- [ ] try highlighting the user tab a different color
- [ ] expand/fix repl sizing on different screens
- [ ] fix shortcut terminal width to match screen?
- [ ] mobile version that only shows the docs half + a warning about that?

docs:

- [x] update the guest page to be less pushy
- [x] fix first table in reference.md
- [ ] update reference.md to match current shortcut
- [ ] inputs, outputs -> collapsed into type
- [ ] add a macro to type :help <fnname>, and use it to make all the functions into links

repl:

- [x] blur the background properly (separate css element for it i guess)
- [x] try making the background orange too
- [x] have clients ping the server periodically so their guest repls can be removed on disconnect
- [x] send repl commands to server and back before showing, so collaborative editing can work
- [ ] make sure all errors are visible in the web repl
  - [ ] parse errors not showing up on site; it just silently fails
- [ ] loading a new script should also kill the currently running one
- [ ] should clicking a function name kill the currently running one too? yeah
- [ ] separate signal for the progress bar updates, which should be displayed in the command bar

files:

- [ ] pre-download all the blastdbget databases
- [ ] pre-run all the example scripts and use a shared shake cache (see shortcut todo)
- [ ] new user login needs dir created with examples symlink (done?)
- [ ] zip untyped result lists before downloading (make those first)

shortcut:

- [ ] bug: show when script is empty causes a crash
- [x] check that no seqid hashes are slipping through to the user-facing output
- [ ] :type should include the thing and a colon before the type
- [ ] add shared shake cache for multi-user setups (mainly the demo)
- [ ] allow result to be a list, and allow the list to be untyped
- [ ] :help should show a list of possible fuzzy matches + completions if nothing matches exactly
- [ ] should allow multiple results in an untyped list
- [ ] zip function that takes an untyped list and creates a zip
- [ ] result var should also be able to be a raw untyped list
- [ ] readable error when calling a fn with wrong types


[1]: https://github.com/jefdaj/shortcut
[2]: https://nixos.org/nix
