Vim Color Scheme Test Ruby
==========================

Why
----

The original script by maverick.woo (
https://code.google.com/p/vimcolorschemetest/ ) is written in Perl and
the build works on Windows systems. I wanted to add some new features,
but as I'm not very confident with Perl I preferred to start over with a
new Ruby version instead of forking his project.

What it does
----

The script loads all your colorschemes from your default vim directory
(~/.vim/colors), and writes into the output dir an HTML file for each
colorscheme, with a render of a Ruby file using this colorscheme.  It
also writes a different copy for each language present in the samples/
directory. It also builds an index page for each language, with a
showcase of how the colorschemes render the sample code.

What it needs to run
----

* ruby
* macvim

What still needs to be done
----

* Separate light and dark colorschemes
* Make this work with versions of vim different from MacVim
* Add the vim colorschemes to the project dir
* Add links to download the vim colorschemes

Notes
----

ATM, the script uses a vim server named VIMCOLORS and sends it remote
commands. This was made to make it faster, because opening a single
macvim instance for each script required too much time. However, the
--remote-send command of vim doesn't wait for previous remote-sends to
be completed, so I had to add a "sleep 1" command in the script to
prevent it from messing up the execution flow. Any hint to solve this is
greatly appreciated.

* The ruby source code being shown is from Rails source:
  https://github.com/rails/rails/blob/master/activerecord/examples/simple.rb

* The python source code being shown is from Django source:
  https://code.djangoproject.com/browser/django/trunk/tests/modeltests/basic/models.py





