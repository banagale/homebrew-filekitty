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

      macOS prevents Homebrew from installing apps directly into /Applications.

      To make FileKitty behave like a regular Mac app, you have two options:

      1. **Use Terminal**:
         Copy it into your Applications folder:
           # `ditto` will include .app bundle metadata like file icon, cp will not!
           ditto /opt/homebrew/opt/filekitty/FileKitty.app /Applications/FileKitty.app


      2. **Use Finder**:
         - Open Finder
         - Navigate to: #{opt_prefix}
         - Drag `FileKitty.app` into your /Applications folder

      Once moved, launch with:
        open -a FileKitty
        or just:
         filekitty
    EOS
  end

  test do
    system "filekitty" rescue true
  end
end
