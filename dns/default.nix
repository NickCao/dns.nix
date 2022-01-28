#
# SPDX-FileCopyrightText: 2019 Kirill Elagin <https://kir.elagin.me/>
#
# SPDX-License-Identifier: MPL-2.0 or MIT
#

{ lib }:

let
  dnslib = {
    util = import ./util { inherit lib; };
    inherit types;
  };
  types = import ./types { lib = lib'; };
  lib' = lib // { dns = dnslib; };

  combinators = import ./combinators.nix { lib = lib'; };

  evalZone = zone:
    (lib.evalModules {
      modules = [
        { options = {
            zones = lib.mkOption {
              type = lib.types.attrsOf types.zone;
              description = "DNS zones";
            };
          };
          config = {
            zones = { "@" = zone; };
          };
        }
      ];
    }).config.zones."@";

in

{
  inherit evalZone;

  inherit types;

  inherit combinators;
}
