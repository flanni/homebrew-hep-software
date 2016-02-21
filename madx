 require 'formula'
 
 class madx < Formula
  homepage "http://madx.web.cern.ch/madx/"
  head "http://svn.cern.ch/guest/madx/trunk/madX", :using => :svn
  
  depends_on "cmake" => :build
  depends_on "python" => :build
  
   def install
    mkdir "build" do 
     system "pwd"
     args = %W[
      ..
    ]
    system "cmake", *args
    
    margs = %W[
      install
     ]
     system "make", *margs
 
     end 
  end 
end

def caveats
 "Mad-x is the forefront of computational physics in the field of particle accelerator design and simulation"
end
