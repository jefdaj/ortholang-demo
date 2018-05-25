shortcut-web
============

A relatively simple demo server for [ShortCut][1]!

Install
-------

First, you need `shortcut` on your `PATH`.

Then run the server the [Nix][2] way:

```.bash
nix-shell requirements.nix --command ./shortcut_demo.py
```

... or the regular Debian + Python way:

```.bash
# TODO need python-twisted-bin too?
sudo apt-get install python-dev
virtualenv .venv
source .venv/bin/activate
pip install -r requirements.txt
./shortcut_demo.py
```

Finally, visit `localhost:5000` in your browser.

Note: do *not* install actual websockets stuff (gevent, eventlets, etc) as that seems to break it.

Serve
-----

This is a terrible idea from a security perspective,
but the fastest way to access it from elsewhere on the local network is:

```.bash
sudo sysctl -w net.ipv4.conf.all.route_localnet=1
sudo iptables -t nat -I PREROUTING -p tcp --dport 8080 -j DNAT --to 127.0.0.1:5000
```

Replace `8080` with whatever port you want.

Files
-----

The server will put tmpfiles in `./tmpdirs`. Consider linking that to `/tmp` or
a ramdisk if IO becomes an issue. (It shouldn't, unless your users upload and
work on eukaryotic genomes)

It will also save user comments in `./comments`.

[1]: https://github.com/jefdaj/shortcut
[2]: https://nixos.org/nix
