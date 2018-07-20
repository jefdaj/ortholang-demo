# generated using pypi2nix tool (version: 1.8.1)
# See more at: https://github.com/garbas/pypi2nix
#
# COMMAND:
#   pypi2nix -r requirements.txt -V 2.7 -E libffi
#

{ pkgs ? import <nixpkgs> {}
}:

let

  inherit (pkgs) makeWrapper;
  inherit (pkgs.stdenv.lib) fix' extends inNixShell;

  pythonPackages =
  import "${toString pkgs.path}/pkgs/top-level/python-packages.nix" {
    inherit pkgs;
    inherit (pkgs) stdenv;
    python = pkgs.python27Full;
    # patching pip so it does not try to remove files when running nix-shell
    overrides =
      self: super: {
        bootstrapped-pip = super.bootstrapped-pip.overrideDerivation (old: {
          patchPhase = old.patchPhase + ''
            sed -i               -e "s|paths_to_remove.remove(auto_confirm)|#paths_to_remove.remove(auto_confirm)|"                -e "s|self.uninstalled = paths_to_remove|#self.uninstalled = paths_to_remove|"                  $out/${pkgs.python35.sitePackages}/pip/req/req_install.py
          '';
        });
      };
  };

  commonBuildInputs = with pkgs; [ libffi ];
  commonDoCheck = false;

  withPackages = pkgs':
    let
      pkgs = builtins.removeAttrs pkgs' ["__unfix__"];
      interpreter = pythonPackages.buildPythonPackage {
        name = "python27Full-interpreter";
        buildInputs = [ makeWrapper ] ++ (builtins.attrValues pkgs);
        buildCommand = ''
          mkdir -p $out/bin
          ln -s ${pythonPackages.python.interpreter}               $out/bin/${pythonPackages.python.executable}
          for dep in ${builtins.concatStringsSep " "               (builtins.attrValues pkgs)}; do
            if [ -d "$dep/bin" ]; then
              for prog in "$dep/bin/"*; do
                if [ -f $prog ]; then
                  ln -s $prog $out/bin/`basename $prog`
                fi
              done
            fi
          done
          for prog in "$out/bin/"*; do
            wrapProgram "$prog" --prefix PYTHONPATH : "$PYTHONPATH"
          done
          pushd $out/bin
          ln -s ${pythonPackages.python.executable} python
          ln -s ${pythonPackages.python.executable}               python2
          popd
        '';
        passthru.interpreter = pythonPackages.python;
      };
    in {
      __old = pythonPackages;
      inherit interpreter;
      mkDerivation = pythonPackages.buildPythonPackage;
      packages = pkgs;
      overrideDerivation = drv: f:
        pythonPackages.buildPythonPackage (drv.drvAttrs // f drv.drvAttrs //                                            { meta = drv.meta; });
      withPackages = pkgs'':
        withPackages (pkgs // pkgs'');
    };

  python = withPackages {};

  generated = self: {

    "Automat" = python.mkDerivation {
      name = "Automat-0.7.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/4a/4f/64db3ffda8828cb0541fe949354615f39d02f596b4c33fb74863756fc565/Automat-0.7.0.tar.gz"; sha256 = "cbd78b83fa2d81fe2a4d23d258e1661dd7493c9a50ee2f1a5b2cac61c1793b0e"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      # self."Twisted"
      self."attrs"
      self."six"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/glyph/Automat";
        license = licenses.mit;
        description = "Self-service finite-state machines for the programmer on the go.";
      };
    };



    "Flask" = python.mkDerivation {
      name = "Flask-1.0.2";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/4b/12/c1fbf4971fda0e4de05565694c9f0c92646223cff53f15b6eb248a310a62/Flask-1.0.2.tar.gz"; sha256 = "2271c0070dbcb5275fad4a82e29f23ab92682dc45f9dfbc22c02ba9b9322ce48"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Jinja2"
      self."Werkzeug"
      self."click"
      self."itsdangerous"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://www.palletsprojects.com/p/flask/";
        license = licenses.bsdOriginal;
        description = "A simple framework for building complex web applications.";
      };
    };



    "Flask-HTTPAuth" = python.mkDerivation {
      name = "Flask-HTTPAuth-3.2.4";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/f3/b4/1a477f481239620e15392049912bc9b16ea9e2cbf559cf0b55789e685e08/Flask-HTTPAuth-3.2.4.tar.gz"; sha256 = "f71b7611f385fbdf350e8c430eed17b41c3b2200dc35eae19c1734264b68e31d"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Flask"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/miguelgrinberg/flask-httpauth/";
        license = licenses.mit;
        description = "Basic and Digest HTTP authentication for Flask routes";
      };
    };



    "Flask-Misaka" = python.mkDerivation {
      name = "Flask-Misaka-0.4.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/3d/19/71e8dc5c537f6a4e3b9ae2836f442a8643c2ce900eafd2484ef18ad87cb3/Flask-Misaka-0.4.1.tar.gz"; sha256 = "1dad09a312aafc3783dd4228bcc60708e339494c1653d6bb8e1936b5c4fdeaac"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Flask"
      self."misaka"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/singingwolfboy/flask-misaka/";
        license = licenses.mit;
        description = "A pleasant interface between the Flask web framework and the Misaka Markdown parser.";
      };
    };



    "Flask-SocketIO" = python.mkDerivation {
      name = "Flask-SocketIO-3.0.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/78/db/4346643cb8396d82d2513837ab959d7cc9e7b6e6268fb355453aabe11375/Flask-SocketIO-3.0.1.tar.gz"; sha256 = "034c36bad808f93efd5b0aeafd740dc314b0a848f17e9ec6c387c74b3f22dfe7"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Flask"
      self."python-socketio"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/miguelgrinberg/Flask-SocketIO/";
        license = licenses.mit;
        description = "Socket.IO integration for Flask applications";
      };
    };



    "Flask-Twisted" = python.mkDerivation {
      name = "Flask-Twisted-0.1.2";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/dd/b1/28ff09ffe40631c80e74890038755dfc9481c13fc48856671cb8a5521eab/Flask-Twisted-0.1.2.tar.gz"; sha256 = "a8d0fa513374d630e0a4cda50a67cb4b329051bf8b228c43844f8aceb457d917"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Flask"
      self."Twisted"
      self."observable"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/cravler/flask-twisted/";
        license = licenses.mit;
        description = "Simple integration of Flask and Twisted";
      };
    };



    "Jinja2" = python.mkDerivation {
      name = "Jinja2-2.10";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/56/e6/332789f295cf22308386cf5bbd1f4e00ed11484299c5d7383378cf48ba47/Jinja2-2.10.tar.gz"; sha256 = "f84be1bb0040caca4cea721fcbbbbd61f9be9464ca236387158b0feea01914a4"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."MarkupSafe"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://jinja.pocoo.org/";
        license = licenses.bsdOriginal;
        description = "A small but fast and easy to use stand-alone template engine written in pure python.";
      };
    };



    "MarkupSafe" = python.mkDerivation {
      name = "MarkupSafe-1.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/4d/de/32d741db316d8fdb7680822dd37001ef7a448255de9699ab4bfcbdf4172b/MarkupSafe-1.0.tar.gz"; sha256 = "a6be69091dac236ea9c6bc7d012beab42010fa914c459791d627dad4910eb665"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/pallets/markupsafe";
        license = licenses.bsdOriginal;
        description = "Implements a XML/HTML/XHTML Markup safe string for Python";
      };
    };



    "PyHamcrest" = python.mkDerivation {
      name = "PyHamcrest-1.9.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/a4/89/a469aad9256aedfbb47a29ec2b2eeb855d9f24a7a4c2ff28bd8d1042ef02/PyHamcrest-1.9.0.tar.gz"; sha256 = "8ffaa0a53da57e89de14ced7185ac746227a8894dbd5a3c718bf05ddbd1d56cd"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."six"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/hamcrest/PyHamcrest";
        license = licenses.bsdOriginal;
        description = "Hamcrest framework for matcher objects";
      };
    };



    "Pygments" = python.mkDerivation {
      name = "Pygments-2.2.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/71/2a/2e4e77803a8bd6408a2903340ac498cb0a2181811af7c9ec92cb70b0308a/Pygments-2.2.0.tar.gz"; sha256 = "dbae1046def0efb574852fab9e90209b23f556367b5a320c0bcb871c77c3e8cc"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://pygments.org/";
        license = licenses.bsdOriginal;
        description = "Pygments is a syntax highlighting package written in Python.";
      };
    };



    "Twisted" = python.mkDerivation {
      name = "Twisted-18.7.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/90/50/4c315ce5d119f67189d1819629cae7908ca0b0a6c572980df5cc6942bc22/Twisted-18.7.0.tar.bz2"; sha256 = "95ae985716e8107816d8d0df249d558dbaabb677987cc2ace45272c166b267e4"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Automat"
      self."PyHamcrest"
      self."attrs"
      self."constantly"
      self."hyperlink"
      self."idna"
      self."incremental"
      self."zope.interface"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://twistedmatrix.com/";
        license = licenses.mit;
        description = "An asynchronous networking framework written in Python";
      };
    };



    "Werkzeug" = python.mkDerivation {
      name = "Werkzeug-0.14.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/9f/08/a3bb1c045ec602dc680906fc0261c267bed6b3bb4609430aff92c3888ec8/Werkzeug-0.14.1.tar.gz"; sha256 = "c3fd7a7d41976d9f44db327260e263132466836cef6f91512889ed60ad26557c"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://www.palletsprojects.org/p/werkzeug/";
        license = licenses.bsdOriginal;
        description = "The comprehensive WSGI web application library.";
      };
    };



    "attrs" = python.mkDerivation {
      name = "attrs-18.1.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/e4/ac/a04671e118b57bee87dabca1e0f2d3bda816b7a551036012d0ca24190e71/attrs-18.1.0.tar.gz"; sha256 = "e0d0eb91441a3b53dab4d9b743eafc1ac44476296a2053b6ca3af0b139faf87b"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."six"
      self."zope.interface"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://www.attrs.org/";
        license = licenses.mit;
        description = "Classes Without Boilerplate";
      };
    };



    "cffi" = python.mkDerivation {
      name = "cffi-1.11.5";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/e7/a7/4cd50e57cc6f436f1cc3a7e8fa700ff9b8b4d471620629074913e3735fb2/cffi-1.11.5.tar.gz"; sha256 = "e90f17980e6ab0f3c2f3730e56d1fe9bcba1891eeea58966e89d352492cc74f4"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."pycparser"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://cffi.readthedocs.org";
        license = licenses.mit;
        description = "Foreign Function Interface for Python calling C code.";
      };
    };



    "click" = python.mkDerivation {
      name = "click-6.7";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/95/d9/c3336b6b5711c3ab9d1d3a80f1a3e2afeb9d8c02a7166462f6cc96570897/click-6.7.tar.gz"; sha256 = "f15516df478d5a56180fbf80e68f206010e6d160fc39fa508b65e035fd75130b"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/mitsuhiko/click";
        license = licenses.bsdOriginal;
        description = "A simple wrapper around optparse for powerful command line utilities.";
      };
    };



    "constantly" = python.mkDerivation {
      name = "constantly-15.1.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/95/f1/207a0a478c4bb34b1b49d5915e2db574cadc415c9ac3a7ef17e29b2e8951/constantly-15.1.0.tar.gz"; sha256 = "586372eb92059873e29eba4f9dec8381541b4d3834660707faf8ba59146dfc35"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/twisted/constantly";
        license = licenses.mit;
        description = "Symbolic constants in Python";
      };
    };



    "docopt" = python.mkDerivation {
      name = "docopt-0.6.2";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"; sha256 = "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://docopt.org";
        license = licenses.mit;
        description = "Pythonic argument parser, that will make you smile";
      };
    };



    "hyperlink" = python.mkDerivation {
      name = "hyperlink-18.0.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/41/e1/0abd4b480ec04892b1db714560f8c855d43df81895c98506442babf3652f/hyperlink-18.0.0.tar.gz"; sha256 = "f01b4ff744f14bc5d0a22a6b9f1525ab7d6312cb0ff967f59414bbac52f0a306"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."idna"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/python-hyper/hyperlink";
        license = licenses.mit;
        description = "A featureful, immutable, and correct URL for Python.";
      };
    };



    "idna" = python.mkDerivation {
      name = "idna-2.7";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/65/c4/80f97e9c9628f3cac9b98bfca0402ede54e0563b56482e3e6e45c43c4935/idna-2.7.tar.gz"; sha256 = "684a38a6f903c1d71d6d5fac066b58d7768af4de2b832e426ec79c30daa94a16"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/kjd/idna";
        license = licenses.bsdOriginal;
        description = "Internationalized Domain Names in Applications (IDNA)";
      };
    };



    "incremental" = python.mkDerivation {
      name = "incremental-17.5.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/8f/26/02c4016aa95f45479eea37c90c34f8fab6775732ae62587a874b619ca097/incremental-17.5.0.tar.gz"; sha256 = "7b751696aaf36eebfab537e458929e194460051ccad279c72b755a167eebd4b3"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      # self."Twisted"
      self."click"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/twisted/incremental";
        license = licenses.mit;
        description = "UNKNOWN";
      };
    };



    "itsdangerous" = python.mkDerivation {
      name = "itsdangerous-0.24";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/dc/b4/a60bcdba945c00f6d608d8975131ab3f25b22f2bcfe1dab221165194b2d4/itsdangerous-0.24.tar.gz"; sha256 = "cbb3fcf8d3e33df861709ecaf89d9e6629cff0a217bc2848f1b41cd30d360519"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/mitsuhiko/itsdangerous";
        license = licenses.bsdOriginal;
        description = "Various helpers to pass trusted data to untrusted environments and back.";
      };
    };



    "misaka" = python.mkDerivation {
      name = "misaka-2.1.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/47/c2/ba9c82ae0ec62bcec62d690e715be6ead4457f83000f4ef6e919f77a8e5f/misaka-2.1.0.tar.gz"; sha256 = "87637d90f5f52595d07ed1be93d0576d32632d125694b96b8e4ce55cd4c019fb"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."cffi"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/FSX/misaka";
        license = licenses.mit;
        description = "A CFFI binding for Hoedown, a markdown parsing library.";
      };
    };



    "observable" = python.mkDerivation {
      name = "observable-0.3.2";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/cc/88/448d24481afa4861d7b095014aab2ffac120137accdc8f76494fd315f2dc/observable-0.3.2.tar.gz"; sha256 = "1c9fe3e05d3047e900d39f98a514611a29bb81c1aa459c5d7fad669743712d4e"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/timofurrer/pyobservable";
        license = "";
        description = "event system for python";
      };
    };



    "psutil" = python.mkDerivation {
      name = "psutil-5.4.6";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/51/9e/0f8f5423ce28c9109807024f7bdde776ed0b1161de20b408875de7e030c3/psutil-5.4.6.tar.gz"; sha256 = "686e5a35fe4c0acc25f3466c32e716f2d498aaae7b7edc03e2305b682226bcf6"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/giampaolo/psutil";
        license = licenses.bsdOriginal;
        description = "Cross-platform lib for process and system monitoring in Python.";
      };
    };



    "pycparser" = python.mkDerivation {
      name = "pycparser-2.18";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/8c/2d/aad7f16146f4197a11f8e91fb81df177adcc2073d36a17b1491fd09df6ed/pycparser-2.18.tar.gz"; sha256 = "99a8ca03e29851d96616ad0404b4aad7d9ee16f25c9f9708a11faf2810f7b226"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/eliben/pycparser";
        license = licenses.bsdOriginal;
        description = "C parser in Python";
      };
    };



    "python-engineio" = python.mkDerivation {
      name = "python-engineio-2.2.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/07/09/682c70c33e727aac028fca7216bb0b6efcd276e67118d1df417f778a3af1/python-engineio-2.2.0.tar.gz"; sha256 = "d35c50db73bf372f82975dc87f18f1cbfab7d5bed2dfc2553ae784579502a461"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."six"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/miguelgrinberg/python-engineio/";
        license = licenses.mit;
        description = "Engine.IO server";
      };
    };



    "python-socketio" = python.mkDerivation {
      name = "python-socketio-2.0.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/23/28/a446c8d6a32449b933d4ec39572bc26c0f42cc955563b28a03bbb328f452/python-socketio-2.0.0.tar.gz"; sha256 = "bde24ef6132a3c2e1b24e77847b31d331abdf8da8c711f0ef9cee4785000e023"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."python-engineio"
      self."six"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/miguelgrinberg/python-socketio/";
        license = licenses.mit;
        description = "Socket.IO server";
      };
    };



    "six" = python.mkDerivation {
      name = "six-1.11.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"; sha256 = "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://pypi.python.org/pypi/six/";
        license = licenses.mit;
        description = "Python 2 and 3 compatibility utilities";
      };
    };



    "zope.interface" = python.mkDerivation {
      name = "zope.interface-4.5.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/ac/8a/657532df378c2cd2a1fe6b12be3b4097521570769d4852ec02c24bd3594e/zope.interface-4.5.0.tar.gz"; sha256 = "57c38470d9f57e37afb460c399eb254e7193ac7fb8042bd09bdc001981a9c74c"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/zopefoundation/zope.interface";
        license = licenses.zpl21;
        description = "Interfaces for Python";
      };
    };

  };
  localOverridesFile = ./requirements_override.nix;
  overrides = import localOverridesFile { inherit pkgs python; };
  commonOverrides = [

  ];
  allOverrides =
    (if (builtins.pathExists localOverridesFile)
     then [overrides] else [] ) ++ commonOverrides;

in python.withPackages
   (fix' (pkgs.lib.fold
            extends
            generated
            allOverrides
         )
   )
