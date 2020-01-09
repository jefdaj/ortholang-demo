{% import "macros.jinja" as macros with context %}

# Using the website

<div style="float: right;">
  <img class="centeredimg" src="/static/server.png" style="width:150px;"></img>
</div>

This website is intended primarily as a demo. It's run from a standard desktop
computer, and is updated and/or restarted frequently during development.
For anything compute-intensive you probably want to [install OrthoLang][1] on your
own hardware instead.

Most searches can be done on a laptop, but it depends what you want to do and how big your genomes are. You can also contact Jeff (use the
comment box or find my email [here][4]) about collaborating, running your
search on the [Berkeley high-performance compute cluster][2], or installing
OrthoLang at your institution.

The terminal on the right is similar to the standard command line interface you
will get if you install OrthoLang on your computer, except:

* Long-running scripts might be killed to keep the server responsive
* Terminal niceties like tab completion and progress bars are missing
* Uploading and downloading files + scripts is a little awkward

Edit scripts written by other guest users on the `guest` tab,
or make an account to save your own privately.

## Terminal Controls

<img src="{{ url_for('static', filename='controls.png') }}" style="width: 80%;"></img>

1. Type commands in the command line and press enter or click `Run` to run them.
   While a command is running this will grey out and `Run` will change to `Kill`,
   which kills the script if you decide it was taking too long.

2. Load an existing script, either one of the examples or something you wrote earlier.
   You can also upload a script along with any files it requires.

3. Save/download stuff. `Download result` has the latest result you evaluated,
   and `Download script` has the last version of the script you saved.

4. Comment box. Tell Jeff if there's something broken, something you want to see or are confused about,
   or anything else.

## Example Code

There are two types of interactive code blocks.
Complete scripts with `Load` buttons like this:

{{ macros.load_script(user, 'examples/scripts/load03.ol') }}

... and examples of other commands you would type in the terminal.
The `Run` button just types them for you.
They can include loading scripts, but also anything else you might do live:
redefine variables, look at depdencies, etc.

{{ macros.run_example([':load examples/scripts/load03.ol', 'sample 10 genes_of_interest', ':type']) }}


# Using the command line program

OrthoLang itself is a command-line language interpreter, like Python or R or Bash. It will run anywhere supported by [Nix][5], which currently means Linux or MacOS but not Windows. Paste this in a terminal to install everything:

``` .bash
curl https://raw.githubusercontent.com/jefdaj/ortholang/master/install.sh | bash
```

There are also some pre-recorded demos. They tend to be for longer, more
complicated or compute-intensive things and involve using OrthoLang in its
native Linux terminal environment rather than on the website.

{{ macros.asciicast('test.cast') }}

<!--
TODO:
- setting up an editing environment
- interpreter basics
- setting where files go

-->

[1]: https://github.com/jefdaj/ortholang
[2]: https://research-it.berkeley.edu/services/high-performance-computing
[3]: /user
[4]: http://niyogilab.berkeley.edu/lab-directory
[5]: https://nixos.org/nix
