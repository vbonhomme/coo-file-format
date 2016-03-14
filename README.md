`.coo` file format for morphometric data
===========

Work in progress; any comment/question/etc. [is welcome](https://github.com/vbonhomme/coo-file-format/issues/new)

### Rationale
* Easy to read/write by human/machine plain text
* Parsimonious specifications
* If any, covariates included
* If required, easy to extend

### Specifications

A line can consist of:

* space-separated numbers: coordinates in each dimension;
* a word and a number/word: covariate name and value;
* a single word: new partition of coordinates;
* nothing or something else: ignored.

Also:

* Only coordinates are mandatory;
* Covariates can be grouped on top of files;
* A single partition does not need to be introduced, yet `ldk`, `cur` and `out` can help.


### Example
An outline:

```
name brahma
type beer
out
37  561
40  540
40  529
...
33  624
34  603
35  593
```

An open outline with more covariates/cofactors:

```
var Aglan
domes cult
view VD
ind O10
mass 1.123
cur
-0.5000 0.00000
-0.4967 0.01035
-0.4935 0.02414
...
0.4928 0.02396
0.4964 0.01026
0.5000 0.00000
```

Landmarks and 2 partitions of semi-landmarks:

```
id 571
taxa T. mono
ldk
697  977
766  991
704 1046
629 1008
...
731  926
541  962
835  911
cur
541 962
542 965
543 967
...
591 1070
592 1073
593 1075
cur
541 949
542 952
542 954
...
591 1070
592 1073
593 1075
```

### From/to .coo
* `.coo` is intended to be a exchange file format.
* R functions for conversions to/from/via `.coo` are being developped as a standalone package
* [Momocs](https://github.com/vbonhomme/Momocs/) will use it.


