#!/bin/fish
hugo
cd public/
git add .
git commit -m"update"
git push
cd ..
git add .
git commit -m"update"
git push
