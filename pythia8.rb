require 'formula'

class Pythia8 < Formula
  
  desc "Pythia 8.212"
  homepage "http://pythia8.hepforge.org"
  url "http://home.thep.lu.se/~torbjorn/pythia8/pythia8212.tgz"
  version "8.212"
  sha256 "f8fb4341c7e8a8be3347eb26b00329a388ccf925313cfbdba655a08d7fd5a70e"


  depends_on 'hepmc'

  depends_on 'lhapdf'

  depends_on 'boost'
  
  depends_on 'root6'
  
  option 'with-vincia', 'Enable VINCIA plugin (http://vincia.hepforge.org)'
  if build.with? 'vincia'

    resource 'vincia' do
      url 'http://www.hepforge.org/archive/vincia/vincia-1.1.03.tgz'
      sha1 'df389d134284ecdd51073a7a62d71bb9eedb79e6'
    end

    depends_on 'wget' => :build
    depends_on :fortran
    cxxstdlib_check :skip
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-shared
      --with-hepmc=#{Formula['hepmc'].opt_prefix}
      --with-lhapdf6=#{Formula['lhapdf'].opt_prefix}
<<<<<<< HEAD
      --with-boost=#{Formula['boost'].opt_prefix}
=======
    --with-boost=#{Formula['boost'].opt_prefix}
>>>>>>> b1df1542bb942e295a315b1d205ad4ba894f35b7
      --with-root=#{Formula['root6'].opt_prefix}
    ]

    system "./configure", *args
    system "make", "install"

    prefix.install 'examples'

    if build.with? 'vincia'
      resource('vincia').stage do
        # Must tell VINCIA where to find Pythia 8 and libgfortran
        ENV['PYTHIA8'] = buildpath
        libgfortran = `$FC --print-file-name libgfortran.dylib`.chomp
        system "make", "FLIBS=-L#{File.dirname libgfortran} -lgfortran"

        (lib/'archive').install Dir['lib/archive/*']
        include.install Dir['include/*']
        (prefix/'xmldoc').install Dir['xmldoc/*']
        prefix.install 'README.TXT' => 'README.vincia'
        (share/'vincia').install 'antennae', 'tunes'
      end
    end
  end

  test do
    ENV['PYTHIA8DATA'] = "#{prefix}/xmldoc"

    system "make -C #{prefix}/examples/ main01"
    system "#{prefix}/examples/main01.exe"
    system "make -C #{prefix}/examples/ main41"
    system "#{prefix}/examples/main41.exe"
  end

  def caveats; <<-EOS.undent
    It is recommended to 'brew install sacrifice' now, as
    the easiest way to generate Pythia 8 events.

    Otherwise, programs can be built against the Pythia 8
    libraries by making use of 'pythia8-config'.

    EOS
  end
end
<<<<<<< HEAD

  
=======
>>>>>>> b1df1542bb942e295a315b1d205ad4ba894f35b7
