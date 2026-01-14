{
  description = "WildFly binary wrapper for Nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
  };

  outputs =
    { self, nixpkgs }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" ];
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
          jdk = pkgs.openjdk8;
        in
        {
          wildfly = pkgs.stdenvNoCC.mkDerivation rec {
            pname = "wildfly-bin";
            version = "26.1.3.Final";

            src = pkgs.fetchurl {
              url = "https://github.com/wildfly/wildfly/releases/download/${version}/wildfly-${version}.tar.gz";
              hash = "sha256-qt0xfGJhb2tXNa6SFR0GwfA8RuukSJWNmCxh8CUorlk=";
            };

            nativeBuildInputs = [ pkgs.makeWrapper ];
            buildInputs = [ jdk ];
            phases = [
              "unpackPhase"
              "installPhase"
              "fixupPhase"
            ];

            sourceRoot = ".";

            installPhase = ''
              mkdir -p $out/opt
              cp -r wildfly-${version} $out/opt/wildfly
              mkdir -p $out/bin
              makeWrapper $out/opt/wildfly/bin/standalone.sh $out/bin/wildfly-standalone \
                --set JAVA_HOME ${jdk} \
                --prefix PATH : ${jdk}/bin \
                --run 'export JBOSS_BASE_DIR="$HOME/.wildfly"; mkdir -p "$JBOSS_BASE_DIR/standalone"'

              makeWrapper $out/opt/wildfly/bin/domain.sh $out/bin/wildfly-domain \
                --set JAVA_HOME ${jdk} \
                --prefix PATH : ${jdk}/bin \
                --run 'export JBOSS_BASE_DIR="$HOME/.wildfly"; mkdir -p "$JBOSS_BASE_DIR/standalone"'
            '';

            meta = with pkgs.lib; {
              description = "Binary tarball WildFly application server packaged with Nix";
              homepage = "https://www.wildfly.org/";
              license = licenses.asl20;
              platforms = platforms.linux;
            };
          };

          default = self.packages.${system}.wildfly;
        }
      );
    };
}
