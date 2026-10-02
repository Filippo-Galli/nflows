{
  lib,
  python3Packages,
  buildPythonPackage ? python3Packages.buildPythonPackage,
  setuptools ? python3Packages.setuptools,
  wheel ? python3Packages.wheel,
  matplotlib ? python3Packages.matplotlib,
  numpy ? python3Packages.numpy,
  tensorboard ? python3Packages.tensorboard,
  torch ? python3Packages.torch,
  tqdm ? python3Packages.tqdm,
  torchtestcase ? python3Packages.torchtestcase,
  UMNN,
}:

buildPythonPackage (finalAttrs: {
  pname = "nflows";
  version = builtins.head (
    builtins.match ''.*__version__ *= *"([^"]+)".*'' (builtins.readFile ./nflows/version.py)
  );

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./nflows
      ./tests
      ./setup.py
      ./README.md
    ];
  };

  # specific to buildPythonPackage, see its reference
  pyproject = true;
  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    matplotlib
    numpy
    tensorboard
    torch
    tqdm
    UMNN
  ];
  pythonImportsCheck = [ "nflows" ];
  doCheck = true;
  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    torchtestcase
  ];
})
