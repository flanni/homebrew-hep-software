class Atlas < Formula
  desc "Package for Automatically Tuned Linear Algebra Software (ATLAS) libraries"
  homepage "https://sourceforge.net/projects/math-atlas"
  url "https://sourceforge.net/projects/math-atlas/files/Stable/3.10.3/atlas3.10.3.tar.bz2"
  sha256 "2688eb733a6c5f78a18ef32144039adcd62fabce66f2eb51dd59dde806a6d2b7"

  depends_on "lapack"
  
  def install
    ENV['PATH']="/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin"
    args = %W[
      -b 64 
      --prefix=#{prefix}
    ]
    
    mkdir "build" do
      system "./configure", *args
      system "make"
      system "make", "check" if build.with? "test"
      system "make", "install"
    end
  end
end
