{
  description = "Ed's flake templates";

  outputs = {self, ...}: {
    templates = {
      lualatex-basic = {
        path = ./lualatex-basic;
        description = "A basic lualatex setup";
      };
    };
  };
}
