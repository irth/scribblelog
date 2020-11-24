#!/usr/bin/env bash

touch hashes
rmapi get Scribblelog
rm -rf notebook
unzip -d notebook Scribblelog.zip
mkdir -p svgs
mkdir -p new_svgs
for i in ./notebook/*/*.rm; do 
    grep -q $(md5sum "$i") ./hashes && {
        mv "svgs/$(basename "$i").svg" new_svgs/
    } || {
        echo processing "$i"
       lines-are-rusty "$i" "new_svgs/$(basename "$i")";
    }
done

rm -rf svgs
mv new_svgs svgs


echo >hashes
for i in ./notebook/*/*.rm; do
    md5sum "$i" >> hashes
done

rm -rf out
mkdir -p out/svgs
cp -R svgs/*.svg out/svgs
cp logo.svg out/logo.svg
cat header.html > out/index.html
ls -1 svgs/*.svg | sort -nr | while read i; do echo "<div class=\"page\"><img src=\"$i\"></div>" >> out/index.html; done;
cat footer.html >> out/index.html
