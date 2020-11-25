#!/usr/bin/env bash
git pull # pull before changing
touch hashes
rmapi get Scribblelog
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

rm -rf docs
mkdir -p docs/svgs
cp logo.svg docs/logo.svg
cat header.html > docs/index.html
ls -1 svgs/*.svg | sort -nr | while read i; do
    sum=$(md5sum "$i");
    name="${sum%% *}.${i##*.}"
    cp "$i" "docs/svgs/$name";
    echo "<div class=\"page\"><img src=\"svgs/$name\"></div>" >> docs/index.html
done
cat footer.html >> docs/index.html
echo scribble.irth.pl > docs/CNAME
rm Scribblelog.zip 
rm -rf notebook
[[ $# > 0 ]] && git add docs && {
    git commit -m "autobuild: $(date)"
    git push
}
