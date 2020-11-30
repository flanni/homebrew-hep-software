class Lhapdf < Formula
  desc "PDF interpolation and evaluation"
  homepage "https://lhapdf.hepforge.org/"
  url "https://www.hepforge.org/archive/lhapdf/LHAPDF-6.3.0.tar.gz"
  sha256 "ed4d8772b7e6be26d1a7682a13c87338d67821847aa1640d78d67d2cef8b9b5d"

  depends_on "python"
  
  def install
    ENV['PYTHONPATH']="/usr/local/lib/root:/usr/local/Cellar/pythia8/8.303/lib"
    ENV['PATH']="/Library/Frameworks/Python.framework/Versions/Current/bin/:/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin"
    args = %W[
      --enable-python
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def caveats; <<~EOS
    PDFs may be downloaded and installed with

      lhapdf install CT10nlo

    At runtime, LHAPDF searches #{share}/LHAPDF
    and paths in LHAPDF_DATA_PATH for PDF sets.

  EOS
  end

  test do
    system "#{bin}/lhapdf", "help"
    system "python", "-c", "import lhapdf; lhapdf.version()"
  end
end
