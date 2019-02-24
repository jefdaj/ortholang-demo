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
    -p 80 \
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
  -p 80 \
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
