#!/bin/bash

scp pkg/*.gem gpg@vshouse.org:vshouse.org/gems/gems
ssh gpg@vshouse.org gem generate_index -d vshouse.org/gems
