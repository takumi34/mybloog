#!/bin/fish
hugo
cd pulic
git add .
git commit -m"update"
git push
cd ..
git add .
git commit -m"update"
git push
