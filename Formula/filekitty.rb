class Filekitty < Formula
  desc "A local LLM prompt toolkit with a macOS GUI"
  homepage "https://github.com/banagale/FileKitty"
  url "https://github.com/banagale/FileKitty/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "REPLACE_WITH_ACTUAL_SHA256"
  license "MIT"

  depends_on "python@3.12"
  depends_on "poetry"
  depends_on "pyqt@5"
  depends_on "py2app"

  def install
    ENV["PYTHON"] = Formula["python@3.12"].opt_bin/"python3"
    system "poetry", "env", "use", ENV["PYTHON"]
    system "poetry", "install", "--no-interaction", "--no-root"
    system "poetry", "run", "python", "setup.py", "py2app"
    prefix.install Dir["dist/FileKitty.app"]
  end

  def caveats
    <<~EOS
      FileKitty.app has been installed to:
        #{opt_prefix}/FileKitty.app

      You can move it to /Applications:
        mv #{opt_prefix}/FileKitty.app /Applications/

      Or launch it directly:
        open #{opt_prefix}/FileKitty.app
    EOS
  end

  test do
    system "true"
  end
end

