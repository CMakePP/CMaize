Building the documentation
==========================

Building is done by running:

```
make html
```

in the `${CMAKEPP_ROOT}/docs` directory, where `${CMAKEPP_ROOT}` is the full
path to the top-level directory of this repository. If this runs successfully
you will get an additional directory `build`. The actual documentation can be
viewed by opening `${CMAKEPP_ROOT}/docs/build/html/index.html` in a web browser.

If the build did not run successfully check that you have installed the
following Python packages (all available in `pip`):

- sphinx_rtd_theme (The Read-The-Docs theme for sphinx)
- sphinx (The thing that makes the documenation)



