class Filekitty < Formula
  desc "A local LLM prompt toolkit with a macOS GUI"
  homepage "https://github.com/banagale/FileKitty"
  url "https://github.com/banagale/FileKitty/releases/download/v0.2.2/FileKitty-0.2.2.zip"
  sha256 "4f97e43d8b46e9ca8f5363a09eb2cdee196fd24202231a0caa17295e2241b2ae"
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
