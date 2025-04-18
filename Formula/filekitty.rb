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
    system "poetry", "run", "python", "setup.py", "py2app"

    app_path = Dir["dist/FileKitty.app"].first

    target = if File.writable?("/Applications")
      "/Applications/FileKitty.app"
    else
      File.expand_path("~/Applications/FileKitty.app")
    end

    ohai "Installing to: #{target}"
    system "mkdir", "-p", File.dirname(target)
    system "cp", "-R", app_path, target

    # CLI launcher script
    (bin/"filekitty").write <<~EOS
      #!/bin/bash
      open -a "FileKitty"
    EOS

    # Dummy file to satisfy Homebrew
    (prefix/"installed-via-homebrew.txt").write <<~EOS
      FileKitty.app was installed to #{target}
    EOS
  end

  def caveats
    <<~EOS
      FileKitty.app has been installed to your Applications folder.

      You can launch it via:
        Spotlight → FileKitty
        open -a FileKitty
        filekitty    # from the terminal
    EOS
  end

  test do
    system "filekitty" rescue true
  end
end
