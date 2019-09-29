class Lhapdf < Formula
  desc "PDF interpolation and evaluation"
  homepage "https://lhapdf.hepforge.org/"
  url "https://www.hepforge.org/archive/lhapdf/LHAPDF-6.2.3.tar.gz"
  sha256 "d6e63addc56c57b6286dc43ffc56d901516f4779a93a0f1547e14b32cfd82dd1"

  depends_on "python"
  
  def install
    ENV['PATH']="/usr/local/bin:${PATH}"
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
