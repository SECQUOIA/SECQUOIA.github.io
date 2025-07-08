# Ruby-FFI https://github.com/ffi/ffi/wiki

## Description

Ruby-FFI is a gem for programmatically loading dynamically-linked native
libraries, binding functions within them, and calling those functions
from Ruby code. Moreover, a Ruby-FFI extension works without changes
on CRuby (MRI), JRuby, Rubinius and TruffleRuby. [Discover why you should write your next extension
using Ruby-FFI](https://github.com/ffi/ffi/wiki/why-use-ffi).

## Features

* Intuitive DSL
* Supports all C native types
* C structs (also nested), enums and global variables
* Callbacks from C to Ruby
* Automatic garbage collection of native memory
* Usable in Ractor: [How-to-use-FFI-in-Ruby-Ractors](https://github.com/ffi/ffi/wiki/Ractors)

## Synopsis

```ruby
require 'ffi'

module MyLib
  extend FFI::Library
  ffi_lib 'c'
  attach_function :puts, [ :string ], :int
end

MyLib.puts 'Hello, World using libc!'
```

For less minimalistic and more examples you may look at:

* the `samples/` folder
* the examples on the [wiki](https://github.com/ffi/ffi/wiki)
* the projects using FFI listed on the wiki: https://github.com/ffi/ffi/wiki/projects-using-ffi

## Requirements

When installing the gem on CRuby (MRI), you will need:
* A C compiler (e.g., Xcode on macOS, `gcc` or `clang` on everything else)
Optionally (speeds up installation):
* The `libffi` library and development headers - this is commonly in the `libffi-dev` or `libffi-devel` packages

The ffi gem comes with a builtin libffi version, which is used, when the system libffi library is not available or too old.
Use of the system libffi can be enforced by:
```
gem install ffi -- --enable-system-libffi        # to install the gem manually
bundle config build.ffi --enable-system-libffi   # for bundle install
```
or prevented by `--disable-system-libffi`.

On Linux systems running with [PaX](https://en.wikipedia.org/wiki/PaX) (Gentoo, Alpine, etc.), FFI may trigger `mprotect` errors. You may need to disable [mprotect](https://en.wikibooks.org/wiki/Grsecurity/Appendix/Grsecurity_and_PaX_Configuration_Options#Restrict_mprotect.28.29) for ruby (`paxctl -m [/path/to/ruby]`) for the time being until a solution is found.

On FreeBSD systems pkgconf must be installed for the gem to be able to compile using clang. Install either via packages `pkg install pkgconf` or from ports via `devel/pkgconf`.

On JRuby and TruffleRuby, there are no requirements to install the FFI gem, and `require 'ffi'` works even without installing the gem (i.e., the gem is preinstalled on these implementations).

## Installation

From rubygems:

    [sudo] gem install ffi

From a Gemfile using git or GitHub

    gem 'ffi', github: 'ffi/ffi', submodules: true

or from the git repository on github:

    git clone git://github.com/ffi/ffi.git
    cd ffi
    git submodule update --init --recursive
    bundle install
    rake install

### Install options:

* `--enable-system-libffi` : Force usage of system libffi
* `--disable-system-libffi` : Force usage of builtin libffi
* `--enable-libffi-alloc` : Force closure allocation by libffi
* `--disable-libffi-alloc` : Force closure allocation by builtin method

## License

The ffi library is covered by the BSD license, also see the LICENSE file.
The specs are covered by the same license as [ruby/spec](https://github.com/ruby/spec), the MIT license.

## Credits

The following people have submitted code, bug reports, or otherwise contributed to the success of this project:

* Alban Peignier <[email removed]>
* Aman Gupta <[email removed]>
* Andrea Fazzi <[email removed]>
* Andreas Niederl <[email removed]>
* Andrew Cholakian <[email removed]>
* Antonio Terceiro <[email removed]>
* Benoit Daloze <[email removed]>
* Brian Candler <[email removed]>
* Brian D. Burns <[email removed]>
* Bryan Kearney <[email removed]>
* Charlie Savage <[email removed]>
* Chikanaga Tomoyuki <[email removed]>
* Hongli Lai <[email removed]>
* Ian MacLeod <[email removed]>
* Jake Douglas <[email removed]>
* Jean-Dominique Morani <[email removed]>
* Jeremy Hinegardner <[email removed]>
* Jesús García Sáez <[email removed]>
* Joe Khoobyar <[email removed]>
* Jurij Smakov <[email removed]>
* KISHIMOTO, Makoto <[email removed]>
* Kim Burgestrand <[email removed]>
* Lars Kanis <[email removed]>
* Luc Heinrich <[email removed]>
* Luis Lavena <[email removed]>
* Matijs van Zuijlen <[email removed]>
* Matthew King <[email removed]>
* Mike Dalessio <[email removed]>
* NARUSE, Yui <[email removed]>
* Park Heesob <[email removed]>
* Shin Yee <[email removed]>
* Stephen Bannasch <[email removed]>
* Suraj N. Kurapati <[email removed]>
* Sylvain Daubert <[email removed]>
* Victor Costan
* [email removed]
* ctide <[email removed]>
* emboss <[email removed]>
* hobophobe <[email removed]>
* meh <[email removed]>
* postmodern <[email removed]>
* [email removed] <[email removed]>
* Wayne Meissner <[email removed]>
