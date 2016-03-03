require 'formula'

class Sherpa < Formula
  
  desc "Sherpa 2.2.0"
  homepage "https://sherpa.hepforge.org/trac/wiki"
  url "http://www.hepforge.org/archive/sherpa/SHERPA-MC-2.2.0.tar.gz"
  version "2.2.0"
  sha256 "eb5dfde38f4f7a166f313d3c24d1af22c99f9934b7c50c981ff3f5aec9c467d7"


  depends_on 'hepmc'
  depends_on 'lhapdf'
  depends_on 'flanni/hep-software/pythia8'
  depends_on 'fastjet'
  depends_on 'flanni/hep-software/root6'
  depends_on :fortran
  
   def install
    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --enable-pyext
      --enable-analysis
      --enable-hepmc2=#{Formula['hepmc'].opt_prefix}
      --enable-lhapdf=#{Formula['lhapdf'].opt_prefix}
      --enable-pythia=#{Formula['flanni/hep-software/pythia8'].opt_prefix}
      --enable-root=#{Formula['flanni/hep-software/root6'].opt_prefix}
      --enable-hepevtsize=100000
    ]

    system "./configure", *args
    system "make", "install"

    prefix.install 'Manual'
  end
end


