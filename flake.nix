{
  description = "ncmdump - Netease Cloud Music protected file dump tool";

  inputs = {
    # ✅ 仅保留 nixpkgs 镜像，无需 flake-utils
    # nixpkgs.url = "git+https://mirrors.ustc.edu.edu.cn/git/nixpkgs.git?ref=nixos-unstable";
    nixpkgs.url = "git+https://mirrors.nju.edu.cn/git/nixpkgs.git?ref=nixos-unstable&shallow=1";

  };

  outputs = { self, nixpkgs }:
    let
      # 手动列出需要支持的平台（替代 flake-utils.eachDefaultSystem）
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

      # 为每个平台生成 packages 的辅助函数
      forAllSystems = f:
        nixpkgs.lib.genAttrs supportedSystems (system: f {
          pkgs = nixpkgs.legacyPackages.${system};
        });
    in
    {
      # 📦 供 nix profile install / nix run 使用
      packages = forAllSystems ({ pkgs }: {
        default = pkgs.stdenv.mkDerivation {
          pname = "ncmdump";
          version = "1.5.1";

          src = ./.;

          nativeBuildInputs = with pkgs; [
            cmake
            pkg-config
          ];

          buildInputs = with pkgs; [
            zlib
            taglib
          ];

          meta = with pkgs.lib; {
            description = "Netease Cloud Music protected file (.ncm) dump tool";
            homepage = "https://github.com/taurusxi/ncmdump";
            license = licenses.mit;
            mainProgram = "ncmdump";
            platforms = platforms.unix;
          };
        };
      });
    };
}
