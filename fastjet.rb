class Fastjet < Formula
  desc "Package for jet finding in pp and ee collisions"
  homepage "http://fastjet.fr"
  url "http://fastjet.fr/repo/fastjet-3.3.4.tar.gz"
  sha256 "432b51401e1335697c9248519ce3737809808fc1f6d1644bfae948716dddfc03"

  option "with-test", "Test during installation"

  def install
    ENV['PATH']="/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin"
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-pyext
      --enable-allcxxplugins
    ]

    args << "--with-cgal=#{Formula["cgal"].opt_prefix}" if build.with? "cgal"

    system "./configure", *args
    system "make"
    system "make", "check" if build.with? "test"

    # make install fails with multiple jobs
    ENV.deparallelize
    system "make", "install"

    prefix.install "example"
  end

  test do
    ln_s prefix/"example/data", testpath
    ln_s prefix/"example/python", testpath
    system "#{prefix}/example/fastjet_example < data/single-event.dat"
    cd "python" do
      system "python", "01-basic.py"
    end
  end
end
