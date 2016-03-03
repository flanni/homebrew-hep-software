require 'formula'

class Sherpa < Formula
  
  desc "Sherpa 2.2.0"
  homepage "https://sherpa.hepforge.org/trac/wiki"
  url "http://www.hepforge.org/archive/sherpa/SHERPA-MC-2.2.0.tar.gz"
  version "2.2.0"
  sha256 "13e76bb8ea00a5abe80d8145bb330c0c1107e020772749b3e20aaa4a2a03ac3d"


  depends_on 'hepmc'

  depends_on 'lhapdf'

  depends_on 'flanni/hep-software/pythia8'
  
  depends_on 'fastjet'
  
  depends_on 'root6'
  
  
   def install
    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --enable-pyext
      --enable-analysis
      --enable-hepmc2=#{Formula['hepmc'].opt_prefix}
      --enable-lhapdf=#{Formula['lhapdf'].opt_prefix}
      --enable-pythia=#{Formula['pythia8'].opt_prefix}
      --enable-root=#{Formula['root6'].opt_prefix}
      --enable-hepevtsize=100000
    ]

    system "./configure", *args
    system "make", "install"

    prefix.install 'Manual'
  end
end


