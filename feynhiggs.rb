require 'formula'

class FeynHiggs < Formula

  desc "FeynHiggs 2.11.3"
  homepage "http://wwwth.mpp.mpg.de/members/heinemey/feynhiggs/cFeynHiggs.html"
  url "http://wwwth.mpp.mpg.de/members/heinemey/feynhiggs/newversion/FeynHiggs-2.11.3.tar.gz"
  version "2.11.3"
  sha256 "570746c34efbbfba45b39ea7110b0069354747138ad149204f09819548b87f6a"


  def install
    args = %W[
      --64
      --prefix=#{prefix}
      --enable-slhapara
      --enable-full-g-2
    ]

    system "./configure", *args
    system "make", "install"

  end
  
end
