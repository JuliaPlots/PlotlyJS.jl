julia docs/build_example_docs.jl
mkdocs build -c
mkdocs gh-deploy -c -b gh-pages -r origin -v
