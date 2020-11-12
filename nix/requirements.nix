# generated using pypi2nix tool (version: 1.8.1)
# See more at: https://github.com/garbas/pypi2nix
#
# COMMAND:
#   pypi2nix -r requirements_locked.txt -V 2.7 -E libffi
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
    # removed because patchPhase is gone (or renamed?)
    # patching pip so it does not try to remove files when running nix-shell
    # overrides =
    #   self: super: {
    #     bootstrapped-pip = super.bootstrapped-pip.overrideDerivation (old: {
    #       patchPhase = old.patchPhase + ''
    #         sed -i               -e "s|paths_to_remove.remove(auto_confirm)|#paths_to_remove.remove(auto_confirm)|"                -e "s|self.uninstalled = paths_to_remove|#self.uninstalled = paths_to_remove|"                  $out/${pkgs.python35.sitePackages}/pip/req/req_install.py
    #       '';
    #     });
    #   };
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
      name = "Automat-20.2.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/80/c5/82c63bad570f4ef745cc5c2f0713c8eddcd07153b4bee7f72a8dc9f9384b/Automat-20.2.0.tar.gz"; sha256 = "7979803c74610e11ef0c0d68a2942b152df52da55336e0c9d58daf1831cbdf33"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      # removed to prevent infinite recursion:
      # self."Twisted"
      self."attrs"
      self."six"
      # pypi2nix 1.8.1 misses these:
      self."setuptools-scm"
      self."m2r"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/glyph/Automat";
        license = licenses.mit;
        description = "Self-service finite-state machines for the programmer on the go.";
      };
    };



    "Flask" = python.mkDerivation {
      name = "Flask-1.1.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/2e/80/3726a729de758513fd3dbc64e93098eb009c49305a97c6751de55b20b694/Flask-1.1.1.tar.gz"; sha256 = "13f9f196f330c7c2c5d7a5cf91af894110ca0215ac051b5844701f2bfd934d52"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Jinja2"
      self."Werkzeug"
      self."click"
      self."itsdangerous"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://palletsprojects.com/p/flask/";
        license = licenses.bsdOriginal;
        description = "A simple framework for building complex web applications.";
      };
    };



    "Flask-HTTPAuth" = python.mkDerivation {
      name = "Flask-HTTPAuth-4.1.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/79/a0/ff7dc053f03c49f1614a79171d15f58cc7d824c85b1ba11d0df6ef3aa92b/Flask-HTTPAuth-4.1.0.tar.gz"; sha256 = "9e028e4375039a49031eb9ecc40be4761f0540476040f6eff329a31dabd4d000"; };
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
      name = "Flask-Misaka-1.0.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/3d/47/e3830ccdaffbfeebf7d95048498bacdc1e9bcaa7d679113dcd521e3ef7d7/Flask-Misaka-1.0.0.tar.gz"; sha256 = "f423c3beb5502742a57330a272f81d53223f6f99d45cc45b03926e3a3034f589"; };
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
      name = "Flask-SocketIO-4.2.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/46/a7/13b3cae86d5458ce07a5ad0510e5999f73313b2b8db3cf96f48c2acbb51e/Flask-SocketIO-4.2.1.tar.gz"; sha256 = "2172dff1e42415ba480cee02c30c2fc833671ff326f1598ee3d69aa02cf768ec"; };
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
      name = "Jinja2-2.11.2";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/64/a7/45e11eebf2f15bf987c3bc11d37dcc838d9dc81250e67e4c5968f6008b6c/Jinja2-2.11.2.tar.gz"; sha256 = "89aab215427ef59c34ad58735269eb58b1a5808103067f7bb9d5836c651b3bb0"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."MarkupSafe"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://palletsprojects.com/p/jinja/";
        license = licenses.bsdOriginal;
        description = "A very fast and expressive template engine.";
      };
    };



    "MarkupSafe" = python.mkDerivation {
      name = "MarkupSafe-1.1.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/b9/2e/64db92e53b86efccfaea71321f597fa2e1b2bd3853d8ce658568f7a13094/MarkupSafe-1.1.1.tar.gz"; sha256 = "29872e92839765e546828bb7754a68c418d927cd064fd4708fab9fe9c8bb116b"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://palletsprojects.com/p/markupsafe/";
        license = licenses.bsdOriginal;
        description = "Safely add untrusted strings to HTML/XML markup.";
      };
    };



    "PyHamcrest" = python.mkDerivation {
      name = "PyHamcrest-1.10.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/d9/6b/fb2e701f25303c620149923d98085c6d7b052d112044764cbf00cc07469e/PyHamcrest-1.10.1.tar.gz"; sha256 = "f7ae19ddfd71f11a421bcec9608d708c0fab816db98b51fdbc672a6d99a30874"; };
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
      name = "Pygments-2.5.2";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/cb/9f/27d4844ac5bf158a33900dbad7985951e2910397998e85712da03ce125f0/Pygments-2.5.2.tar.gz"; sha256 = "98c8aa5a9f778fcd1026a17361ddaf7330d1b7c62ae97c3bb0ae73e0b9b6b0fe"; };
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
      name = "Twisted-19.10.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/0b/95/5fff90cd4093c79759d736e5f7c921c8eb7e5057a70d753cdb4e8e5895d7/Twisted-19.10.0.tar.bz2"; sha256 = "7394ba7f272ae722a74f3d969dcf599bc4ef093bc392038748a490f1724a515d"; };
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
        homepage = "https://twistedmatrix.com/";
        license = licenses.mit;
        description = "An asynchronous networking framework written in Python";
      };
    };



    "Werkzeug" = python.mkDerivation {
      name = "Werkzeug-1.0.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/10/27/a33329150147594eff0ea4c33c2036c0eadd933141055be0ff911f7f8d04/Werkzeug-1.0.1.tar.gz"; sha256 = "6c80b1e5ad3665290ea39320b91e1be1e0d5f60652b964a3070216de83d2e47c"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://palletsprojects.com/p/werkzeug/";
        license = licenses.bsdOriginal;
        description = "The comprehensive WSGI web application library.";
      };
    };



    "attrs" = python.mkDerivation {
      name = "attrs-20.3.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/f0/cb/80a4a274df7da7b8baf083249b0890a0579374c3d74b5ac0ee9291f912dc/attrs-20.3.0.tar.gz"; sha256 = "832aa3cde19744e49938b91fea06d69ecb9e649c93ba974535d08ad92164f700"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."six"
      self."zope.interface"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://www.attrs.org/";
        license = licenses.mit;
        description = "Classes Without Boilerplate";
      };
    };



    "cffi" = python.mkDerivation {
      name = "cffi-1.14.3";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/cb/ae/380e33d621ae301770358eb11a896a34c34f30db188847a561e8e39ee866/cffi-1.14.3.tar.gz"; sha256 = "f92f789e4f9241cd262ad7a555ca2c648a98178a953af117ef7fad46aa1d5591"; };
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
      name = "click-7.1.2";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"; sha256 = "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://palletsprojects.com/p/click/";
        license = licenses.bsdOriginal;
        description = "Composable command line interface toolkit";
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



    "docutils" = python.mkDerivation {
      name = "docutils-0.16";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/2f/e0/3d435b34abd2d62e8206171892f174b180cd37b09d57b924ca5c2ef2219d/docutils-0.16.tar.gz"; sha256 = "c2de3a60e9e7d07be26b7f2b00ca0309c207e06c100f9cc2a94931fc75a478fc"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://docutils.sourceforge.net/";
        license = licenses.publicDomain;
        description = "Docutils -- Python Documentation Utilities";
      };
    };



    "hyperlink" = python.mkDerivation {
      name = "hyperlink-20.0.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/b7/bf/ecacc60e63d65f7449457bbd8163141c51c4af7aeff7958ec061b8faf915/hyperlink-20.0.1.tar.gz"; sha256 = "47fcc7cd339c6cb2444463ec3277bdcfe142c8b1daf2160bdd52248deec815af"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."idna"
      self."typing"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/python-hyper/hyperlink";
        license = licenses.mit;
        description = "A featureful, immutable, and correct URL for Python.";
      };
    };



    "idna" = python.mkDerivation {
      name = "idna-2.10";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"; sha256 = "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"; };
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
      # removed to prevent infinite recursion:
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
      name = "itsdangerous-1.1.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/68/1a/f27de07a8a304ad5fa817bbe383d1238ac4396da447fa11ed937039fa04b/itsdangerous-1.1.0.tar.gz"; sha256 = "321b033d07f2a4136d3ec762eac9f16a10ccd60f53c0c91af90217ace7ba1f19"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://palletsprojects.com/p/itsdangerous/";
        license = licenses.bsdOriginal;
        description = "Various helpers to pass data to untrusted environments and back.";
      };
    };



    "m2r" = python.mkDerivation {
      name = "m2r-0.2.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/39/e7/9fae11a45f5e1a3a21d8a98d02948e597c4afd7848a0dbe1a1ebd235f13e/m2r-0.2.1.tar.gz"; sha256 = "bf90bad66cda1164b17e5ba4a037806d2443f2a4d5ddc9f6a5554a0322aaed99"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."docutils"
      self."mistune"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/miyakogi/m2r";
        license = licenses.mit;
        description = "Markdown and reStructuredText in a single file.";
      };
    };



    "misaka" = python.mkDerivation {
      name = "misaka-2.1.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/fa/87/b1020510a00aba1b936477e54180b143df654c565b84936b0b3e85272cf2/misaka-2.1.1.tar.gz"; sha256 = "62f35254550095d899fc2ab8b33e156fc5e674176f074959cbca43cf7912ecd7"; };
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



    "mistune" = python.mkDerivation {
      name = "mistune-0.8.4";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/2d/a4/509f6e7783ddd35482feda27bc7f72e65b5e7dc910eca4ab2164daf9c577/mistune-0.8.4.tar.gz"; sha256 = "59a3429db53c50b5c6bcc8a07f8848cb00d7dc8bdb431a4ab41920d201d4756e"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/lepture/mistune";
        license = licenses.bsdOriginal;
        description = "The fastest markdown parser in pure Python";
      };
    };



    "observable" = python.mkDerivation {
      name = "observable-1.0.3";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/24/57/013c2610cf93f9ae87e522be17d679bcba0e7cee2cd8da4dc8efddef1138/observable-1.0.3.tar.gz"; sha256 = "97fe8e9d8c2a6185cee3661fa5fba9ce38c7ba388894132940cd6a81633626d9"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/timofurrer/observable";
        license = licenses.mit;
        description = "minimalist event system";
      };
    };



    "pexpect" = python.mkDerivation {
      name = "pexpect-4.7.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/1c/b1/362a0d4235496cb42c33d1d8732b5e2c607b0129ad5fdd76f5a583b9fcb3/pexpect-4.7.0.tar.gz"; sha256 = "9e2c1fd0e6ee3a49b28f95d4b33bc389c89b20af6a1255906e90ff1262ce62eb"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."ptyprocess"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://pexpect.readthedocs.io/";
        license = licenses.isc;
        description = "Pexpect allows easy control of interactive console applications.";
      };
    };



    "psutil" = python.mkDerivation {
      name = "psutil-5.6.7";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/73/93/4f8213fbe66fc20cb904f35e6e04e20b47b85bee39845cc66a0bcf5ccdcb/psutil-5.6.7.tar.gz"; sha256 = "ffad8eb2ac614518bbe3c0b8eb9dffdb3a8d2e3a7d5da51c5b974fb723a5c5aa"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/giampaolo/psutil";
        license = licenses.bsdOriginal;
        description = "Cross-platform lib for process and system monitoring in Python.";
      };
    };



    "ptyprocess" = python.mkDerivation {
      name = "ptyprocess-0.6.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/7d/2d/e4b8733cf79b7309d84c9081a4ab558c89d8c89da5961bf4ddb050ca1ce0/ptyprocess-0.6.0.tar.gz"; sha256 = "923f299cc5ad920c68f2bc0bc98b75b9f838b93b599941a6b63ddbc2476394c0"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/pexpect/ptyprocess";
        license = "";
        description = "Run a subprocess in a pseudo terminal";
      };
    };



    "pycparser" = python.mkDerivation {
      name = "pycparser-2.20";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"; sha256 = "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"; };
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
      name = "python-engineio-3.13.2";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/e7/f5/64651d4ef2fc8921de33c010a8531916a5bdabd87cd0da66ea6b56c52239/python-engineio-3.13.2.tar.gz"; sha256 = "36b33c6aa702d9b6a7f527eec6387a2da1a9a24484ec2f086d76576413cef04b"; };
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
      name = "python-socketio-4.6.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/6e/e2/515be319ec39bdf9d3344fb591b60f787b52e413fbb0cb3b5362d83bf037/python-socketio-4.6.0.tar.gz"; sha256 = "358d8fbbc029c4538ea25bcaa283e47f375be0017fcba829de8a3a731c9df25a"; };
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


    "setuptools-scm" = python.mkDerivation {
      name = "setuptools-scm-3.3.3";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/83/44/53cad68ce686585d12222e6769682c4bdb9686808d2739671f9175e2938b/setuptools_scm-3.3.3.tar.gz";
        sha256 = "bd25e1fb5e4d603dcf490f1fde40fb4c595b357795674c3e5cb7f6217ab39ea5";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/pypa/setuptools_scm/";
        license = licenses.mit;
        description = "the blessed package to manage your versions by scm tags";
      };
    };


    "six" = python.mkDerivation {
      name = "six-1.15.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"; sha256 = "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/benjaminp/six";
        license = licenses.mit;
        description = "Python 2 and 3 compatibility utilities";
      };
    };



    "typing" = python.mkDerivation {
      name = "typing-3.7.4.3";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/05/d9/6eebe19d46bd05360c9a9aae822e67a80f9242aabbfc58b641b957546607/typing-3.7.4.3.tar.gz"; sha256 = "1187fb9c82fd670d10aa07bbb6cfcfe4bdda42d6fab8d5134f04e8c4d0b71cc9"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://docs.python.org/3/library/typing.html";
        license = licenses.psfl;
        description = "Type Hints for Python";
      };
    };



    "zope.interface" = python.mkDerivation {
      name = "zope.interface-5.2.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/84/21/80cdc749908ebf2719a9063eddcc02b668fbc62d200c1f1a4d92aaaba76b/zope.interface-5.2.0.tar.gz"; sha256 = "8251f06a77985a2729a8bdbefbae79ee78567dddc3acbd499b87e705ca59fe24"; };
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
