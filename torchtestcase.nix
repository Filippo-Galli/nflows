{
  lib,
  python3Packages,
  buildPythonPackage ? python3Packages.buildPythonPackage,
  fetchPypi ? python3Packages.fetchPypi,
  setuptools ? python3Packages.setuptools,
  numpy ? python3Packages.numpy,
  torch ? python3Packages.torch,
}:

buildPythonPackage rec {
  pname = "torchtestcase";
  version = "2018.2";
  pyproject = true;
  build-system = [ setuptools ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AGHN4ut58JyVAfrmdcUseZNxYG1Sr8/4dTxE4aYlSgA=";
  };

  dependencies = [
    numpy
    torch
  ];

  doCheck = false;
  pythonImportsCheck = [ "torchtestcase" ];
}
