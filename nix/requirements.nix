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

    # removed because patchPhase is gone (or renamed?) in nixos-19.09
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
      name = "Automat-0.8.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/4c/9a/3052851fa3a888d1ff32f053fba424ed929b47383fb5327855fdf70018cd/Automat-0.8.0.tar.gz"; sha256 = "269a09dfb063a3b078983f4976d83f0a0d3e6e7aaf8e27d8df1095e09dc4a484"; };
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



    "Click" = python.mkDerivation {
      name = "Click-7.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/f8/5c/f60e9d8a1e77005f664b76ff8aeaee5bc05d0a91798afd7f53fc998dbc47/Click-7.0.tar.gz"; sha256 = "5b94b49521f6456670fdb30cd82a4eca9412788a93fa6dd6df72c94d5a8ff2d7"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://palletsprojects.com/p/click/";
        license = licenses.bsdOriginal;
        description = "Composable command line interface toolkit";
      };
    };



    "Flask" = python.mkDerivation {
      name = "Flask-1.1.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/2e/80/3726a729de758513fd3dbc64e93098eb009c49305a97c6751de55b20b694/Flask-1.1.1.tar.gz"; sha256 = "13f9f196f330c7c2c5d7a5cf91af894110ca0215ac051b5844701f2bfd934d52"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [
      self."Click"
      self."Jinja2"
      self."Werkzeug"
      self."itsdangerous"
    ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://palletsprojects.com/p/flask/";
        license = licenses.bsdOriginal;
        description = "A simple framework for building complex web applications.";
      };
    };



    "Flask-HTTPAuth" = python.mkDerivation {
      name = "Flask-HTTPAuth-3.3.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/e0/95/798367396accd78a9cc7976345da7c7eed48b8e3666307839ea9e7e82890/Flask-HTTPAuth-3.3.0.tar.gz"; sha256 = "6ef8b761332e780f9ff74d5f9056c2616f52babc1998b01d9f361a1e439e61b9"; };
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
      name = "Jinja2-2.10.3";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/7b/db/1d037ccd626d05a7a47a1b81ea73775614af83c2b3e53d86a0bb41d8d799/Jinja2-2.10.3.tar.gz"; sha256 = "9fe95f19286cfefaa917656583d020be14e7859c6b0252588391e47db34527de"; };
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
      name = "Werkzeug-0.16.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/5e/fd/eb19e4f6a806cd6ee34900a687f181001c7a0059ff914752091aba84681f/Werkzeug-0.16.0.tar.gz"; sha256 = "7280924747b5733b246fe23972186c6b348f9ae29724135a6dfc1e53cea433e7"; };
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
      name = "attrs-19.3.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/98/c3/2c227e66b5e896e15ccdae2e00bbc69aa46e9a8ce8869cc5fa96310bf612/attrs-19.3.0.tar.gz"; sha256 = "f7b7ce16570fe9965acd6d30101a28f62fb4a7f9e926b3bbc9b61f8b04247e72"; };
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
      name = "cffi-1.13.2";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/2d/bf/960e5a422db3ac1a5e612cb35ca436c3fc985ed4b7ed13a1b4879006f450/cffi-1.13.2.tar.gz"; sha256 = "599a1e8ff057ac530c9ad1778293c665cb81a791421f46922d80a86473c13346"; };
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
      name = "docutils-0.15.2";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/93/22/953e071b589b0b1fee420ab06a0d15e5aa0c7470eb9966d60393ce58ad61/docutils-0.15.2.tar.gz"; sha256 = "a2aeea129088da402665e92e0b25b04b073c04b2dce4ab65caaa38b7ce2e1a99"; };
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
      name = "hyperlink-19.0.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/e0/46/1451027b513a75edf676d25a47f601ca00b06a6a7a109e5644d921e7462d/hyperlink-19.0.0.tar.gz"; sha256 = "4288e34705da077fada1111a24a0aa08bb1e76699c9ce49876af722441845654"; };
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
      name = "idna-2.8";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/ad/13/eb56951b6f7950cadb579ca166e448ba77f9d24efc03edd7e55fa57d04b7/idna-2.8.tar.gz"; sha256 = "c357b3f628cf53ae2c4c05627ecc484553142ca23264e593d327bcde5e9c3407"; };
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
      self."Click"

      # removed to prevent infinite recursion:
      #self."Twisted"
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
      name = "pycparser-2.19";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/68/9e/49196946aee219aead1290e00d1e7fdeab8567783e83e1b9ab5585e6206a/pycparser-2.19.tar.gz"; sha256 = "a988718abfad80b6b157acce7bf130a30876d27603738ac39f140993246b25b3"; };
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
      name = "python-engineio-3.10.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/78/8e/c58cf2725fd17d65b9fe818b70aff4ccce4903b47aaee6f4321727a8b8bb/python-engineio-3.10.0.tar.gz"; sha256 = "9c9a6035b4b5e5a225f426f846afa14cf627f7571d1ae02167cb703fefd134b7"; };
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
      name = "python-socketio-4.4.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/45/a0/e433c7f20c9f6729e7c67e949227283fe21e21806ce214551339e0db999a/python-socketio-4.4.0.tar.gz"; sha256 = "48cba5b827ac665dbf923a4f5ec590812aed5299a831fc43576a9af346272534"; };
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
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/83/44/53cad68ce686585d12222e6769682c4bdb9686808d2739671f9175e2938b/setuptools_scm-3.3.3.tar.gz"; sha256 = "bd25e1fb5e4d603dcf490f1fde40fb4c595b357795674c3e5cb7f6217ab39ea5"; };
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
      name = "six-1.13.0";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/94/3e/edcf6fef41d89187df7e38e868b2dd2182677922b600e880baad7749c865/six-1.13.0.tar.gz"; sha256 = "30f610279e8b2578cab6db20741130331735c781b56053c59c4076da27f06b66"; };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs;
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/benjaminp/six";
        license = licenses.mit;
        description = "Python 2 and 3 compatibility utilities";
      };
    };



    "zope.interface" = python.mkDerivation {
      name = "zope.interface-4.7.1";
      src = pkgs.fetchurl { url = "https://files.pythonhosted.org/packages/c3/05/bf3130eb799548882ce61b7c3d2dbc5d4d5cc6e821efa8786c5273d56844/zope.interface-4.7.1.tar.gz"; sha256 = "4bb937e998be9d5e345f486693e477ba79e4344674484001a0b646be1d530487"; };
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
