TARGETDIR="./out"

rm -rf $TARGETDIR

source .env

# copy html

for file in $(find . -type f -name \*.html); do
    dir="./$TARGETDIR/$(dirname ${file})"
    mkdir -p "$dir"
    cp $file "$dir/$(basename ${file%.*}).html"
done

# compile slim templates

for file in $(find . -type f -name \*.slim); do
    dir="./$TARGETDIR/$(dirname ${file})"
    mkdir -p "$dir"
    slimrb -e ${file} "$dir/$(basename ${file%.*}).html"
done

# compile coffee script

for file in $(find . -type f -name \*.coffee); do
    envsubst '$API_KEY' < ${file} > ${file}.tmp
    dir="./$TARGETDIR/$(dirname ${file})"
    mkdir -p "$dir"
    coffee -b  -p ${file}.tmp > "$dir/$(basename ${file%.*}).js"
    rm ${file}.tmp
done

# copy css

cp -r ./css $TARGETDIR

# copy fonts

cp -r ./fonts $TARGETDIR

# copy static js libs

cp -r ./vendor $TARGETDIR/js

cp manifest.json $TARGETDIR
