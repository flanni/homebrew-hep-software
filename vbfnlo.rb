class Vbfnlo < Formula
  homepage 'https://www.itp.kit.edu/vbfnlo/wiki/doku.php?id=overview'
  url 'https://www.itp.kit.edu/vbfnlo/wiki/lib/exe/fetch.php?media=download:vbfnlo-2.7.1.tgz'
  sha256 '497690977ed72f1342ab97e9a330fff38f2e9b5ceeef38834cf4b209f3212d58'
  version '2.7.1'
  
  depends_on 'lhapdf'
  depends_on 'hepmc'
  depends_on 'gls'
  depends_on 'looptools'
  depends_on 'madgraph'

  depends_on :fortran

  def install
        args = %W[
      --prefix=#{prefix}
      --with-LHAPDF=#{Formula['lhapdf'].opt_prefix}
      --with-LOOPTOOLS=#{Formula['looptools'].opt_prefix}
      --with-hepmc=#{Formula['hepmc'].opt_prefix}
      --with-FEYNHIGGS=#{Formula['feynhiggs'].opt_prefix}
      --with-gsl=#{Formula['gsl'].opt_prefix}
      --enable-kk
      --enable-spin2
      --enable-NLO
      --enable-madgraph
    ]

        system "./configure", *args
        system "make"
        system "make", "install"

        prefix.install 'doc'
  end

end
