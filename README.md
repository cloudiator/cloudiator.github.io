# The cloudiator webpage

## Editing the page

### Adding a new component

Create a new markdown document in the [components](_components) folder including the
same header as the other ones. Afterwards, include the component in the
[components.yml](_data/components.yml)

### Adding a new project 

Edit the [projects.yml](_data/projects.yml) file.

### Adding a new reference

Edit the [bibtex.bib](_files/bibtex.bib) file and add the new reference. Afterwards
run the [bib.sh](script/bib.sh) script. It will automatically generate the 
[bibliography](_includes/generated/publication.html). You need to have
[bibtex2html](https://www.lri.fr/~filliatr/bibtex2html/) installed and in your
path.

### Adding a new section to the docs.

Create a new mardown document in the [docs](_docs) folder including the 
same header as the other ones. Afterwards edit the [docs.yml](_data/docs.yml)
and add the newly created doc section.

### Adding a new feature to the frontpage.

Create a new .txt file in the [features](_features) folder using the same header
as the other ones. Afterwards edit the [features.yml](_data/features.yml) file
and include the new feature.
