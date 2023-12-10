{
  description = "Pepper's flake templates";

  outputs = { self, ... }: {
    templates = {
      latex-basic = {
        path = ./basic;
        description = "A basic lualatex setup";
      };
    };
  };
}
