require 'formula'

class Chaplin < Formula
  
  desc "Chaplin 1.2"
  homepage "http://chaplin.hepforge.org"
  url "http://chaplin.hepforge.org/code/chaplin-1.2.tar"
  version "1.2"
  sha256 "f17c2d985fd4e4ce36cede945450416d3fa940af68945c91fa5d3ca1d76d4b49"

  depends_on :fortran


  def install
    args = %W[
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "install"

  end

end
