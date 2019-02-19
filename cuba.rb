class Cuba < Formula
  homepage 'http://www.feynarts.de/cuba'
  url 'http://www.feynarts.de/cuba/Cuba-4.2.tar.gz'
  sha256 '6b75bb8146ae6fb7da8ebb72ab7502ecd73920efc3ff77a69a656db9530a5eef'



  def install
        args = %W[
      --prefix=#{prefix}
    ]

        system "./configure", *args
        system "make"
        system "make", "install"

        prefix.install 'demo'
  end

end
