require 'formula'
 
class MadX < Formula

  desc "Mad-X"
  homepage "http://madx.web.cern.ch/madx/"
  url "http://madx.web.cern.ch/madx/releases/5.02.08/madx-src.tgz"
  version "5.02.08"
  sha256 "a264d30322c37be7ca80f66c3bd4d85147d935d0d286dcebb3609a444a82a580"

  head "http://svn.cern.ch/guest/madx/trunk/madX", :using => :svn
 
  depends_on "cmake" => :build
  depends_on "python" => :build
 
  def install
    mkdir "build" do 
      system "pwd"
      system "cmake", ".."
      system "make", "install"
      prefix.install "doc"
    end 
  end 
end

def caveats
  "Mad-x is the forefront of computational physics in the field of particle accelerator design and simulation"
end
