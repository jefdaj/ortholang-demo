detourrr-demo
=============

An interactive web demo + tutorial for [Detourrr][1].
Try the live version at [detourrr.pmb.berkeley.edu](https://shortcut.pmb.berkeley.edu)!

Install
-------

The easiest way is as a NixOS service.
Just add it to your `/etc/nixos/configuration.nix`:

```.nix
{
  imports =
    [ ...
      /home/jefdaj/detourrr-demo/service.nix
    ];

  ...

  services.detourrrDemo = {
    enable      = true;
    user        = "jefdaj"; # TODO swtich to dedicated user
    scratchDir  = "/tmp/detourrr-demo";
    logPath     = "/tmp/detourrr-demo.log";
    dataDir     = "/mnt/data/data";
    commentsDir = "/mnt/data/comments";
    uploadsDir  = "/mnt/data/uploads";
    port        = 45772;
  };

  ...

}
```

You can also run it standalone.
First, you need `detourrr` on your `PATH`.

Then run the server the [Nix][2] way:

```.bash
nix-shell requirements.nix --command ./detourrr_demo.py
```

... or the regular Debian + Python way:

```.bash
# TODO need python-twisted-bin too?
sudo apt-get install python-dev
virtualenv .venv
source .venv/bin/activate
pip install -r requirements.txt
./detourrr_demo.py
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

[1]: https://github.com/jefdaj/detourrr
[2]: https://nixos.org/nix
