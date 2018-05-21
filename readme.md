shortcut-web
============

A relatively simple demo server for [ShortCut][1]!

Install
-------

First, you need `shortcut` on your `PATH`.

Then run the server the [Nix][2] way:

```.bash
nix-shell requirements.nix --command ./shortcut.py
```

... or the regular Python way:

```.bash
virtualenv .venv
source .venv/bin/activate
pip install -r requirements.txt
./shortcut.py
```

Finally, visit `localhost:5000` in your browser.

Note: do *not* install actual websockets stuff (gevent, eventlets, etc) as that seems to break it.

Files
-----

The server will put tmpfiles in `./tmpdirs`. Consider linking that to `/tmp` or
a ramdisk if IO becomes an issue. (It shouldn't, unless your users upload and
work on eukaryotic genomes)

It will also save user comments in `./comments`.

[1]: https://github.com/jefdaj/shortcut
[2]: https://nixos.org/nix
