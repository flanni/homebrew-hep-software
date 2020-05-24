require 'formula'

class Pythia8 < Formula
  
  desc "Pythia 8.302"
  homepage "http://pythia8.hepforge.org"
  url "http://home.thep.lu.se/~torbjorn/pythia8/pythia8302.tgz"
  version "8.302"
  sha256 "7372e4cc6f48a074e6b7bc426b040f218ec4a64b0a55e89da6af56933b5f5085"


  depends_on 'hepmc3'
  depends_on 'lhapdf'
  depends_on 'boost'
  depends_on 'fastjet'
  

#  patch :DATA
  
  def install
    ENV['PATH']="/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin"    
    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --with-fastjet3=#{Formula['fastjet'].opt_prefix}
      --with-hepmc3=#{Formula['hepmc3'].opt_prefix}
      --with-lhapdf6=#{Formula['lhapdf'].opt_prefix}
      --with-boost=#{Formula['boost'].opt_prefix}
      --with-python-config="/Library/Frameworks/Python.framework/Versions/3.8/bin/python3.8-config"
    ]

    system "./configure", *args
    system "make", "install"

    prefix.install 'examples'

  end

  test do
    ENV['PYTHIA8DATA'] = "#{prefix}/xmldoc"

    system "make -C #{prefix}/examples/ main01"
    system "#{prefix}/examples/main01.exe"
    system "make -C #{prefix}/examples/ main41"
    system "#{prefix}/examples/main41.exe"
  end
end
