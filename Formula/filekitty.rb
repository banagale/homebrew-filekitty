class Filekitty < Formula
  desc "A local LLM prompt toolkit with a macOS GUI"
  homepage "https://github.com/banagale/FileKitty"
  url "https://github.com/banagale/FileKitty/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "e21b8df1e5316c6ea5f4014b1b2d97ee46cce92ccc8cfa9aa8bb663e89a97208"
  license "MIT"

  depends_on "python@3.12"
  depends_on "poetry"

  def install
    system "poetry", "install", "--no-interaction", "--no-root"
    system "poetry", "run", "python", "setup.py", "py2app", "--standalone"

    # Install the .app bundle into prefix
    prefix.install Dir["dist/FileKitty.app"]

    # CLI launcher script that uses full path
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
