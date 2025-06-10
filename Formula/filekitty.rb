class Filekitty < Formula
  desc "A local LLM prompt toolkit with a macOS GUI"
  homepage "https://github.com/banagale/FileKitty"
  url "https://github.com/banagale/FileKitty/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "4ef04150098c9e90e025c7cdbdbe1ffdb2baa3ca0906bff3b25b095d332db326"
  license "MIT"

  depends_on "python@3.12"
  depends_on "poetry"

  def install
    system "poetry", "install", "--no-interaction", "--no-root"
    system "poetry", "run", "pip", "install", "wheel"  # avoid PEP 517 error
    system "poetry", "run", "python", "setup.py", "py2app"
    prefix.install Dir["dist/FileKitty.app"]

    (bin/"filekitty").write <<~EOS
      #!/bin/bash
      open "#{opt_prefix}/FileKitty.app"
    EOS
  end

  def caveats
    <<~EOS
      FileKitty.app has been installed to:
        #{opt_prefix}/FileKitty.app

      To use it:

        - Launch from Terminal:   filekitty
        - Add to Applications:    ditto #{opt_prefix}/FileKitty.app /Applications/FileKitty.app
    EOS
  end

  test do
    system "filekitty" rescue true
  end
end
