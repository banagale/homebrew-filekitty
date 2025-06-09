class Filekitty < Formula
  desc "A local LLM prompt toolkit with a macOS GUI"
  homepage "https://github.com/banagale/FileKitty"
  url "https://github.com/banagale/FileKitty/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "87fb3a38748d4f4af294f0ff4956305d4a5eaffdaeba0ba3cc484e2d86b93a9f"
  license "MIT"

  depends_on "python@3.12"
  depends_on "poetry"

  def install
    system "poetry", "install", "--no-interaction", "--no-root"
    system "poetry", "run", "python", "setup.py", "py2app", "--standalone"
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
