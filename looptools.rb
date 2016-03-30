class Looptools < Formula
  homepage 'http://www.feynarts.de/looptools'
  url 'http://www.feynarts.de/looptools/LoopTools-2.13.tar.gz'
  sha256 '8065eb9b7546cea34a9ad77d67f4efd440a58c6548e66e7f1761ecee41605bc3'

  depends_on 'cgal'
  option 'with-check', 'Test during installation'
  depends_on :fortran

  def install
        args = %W[
      --64
      --prefix=#{prefix}
    ]

        system "./configure", *args
        system "make"
        system "make", "check" if build.with? 'check'
        system "make", "install"

        prefix.install 'manual'
  end

  test do
    system "#{prefix}/example/fastjet_example < #{prefix}/example/data/single-event.dat"
  end
end
