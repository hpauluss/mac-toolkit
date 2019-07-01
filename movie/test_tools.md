# Build test environment

The following is just an example of how to create a directory structure to test the `chk_srt.sh` script.

We build a directory hierarchy containing paired txt and srt files. Some of the files have multiple blank sequences in their filename. Some srt files are removed, so the missing pairs can be retrieved.

First we build the hierarchy structure in `/tmp`:

```bash
DIR_TMP_TEST=/tmp/test_module/
mkdir -p $DIR_TMP_TEST/{a,b}/{q,r,s}
```

Then we create paired txt/srt files in the directory, including file names with multiple blanks:

```bash
for f in a b; 
do 
  for f2 in q r s; 
  do 
    touch $DIR_TMP_TEST/$f/$f2/test_${f}${f2}.{txt,srt}; 
    touch $DIR_TMP_TEST/$f/$f2/test_${f}${f2}\ \ blanks.{txt,srt}; 
  done; 
done
```

For testing purposes, some srt files are removed:

```bash
rm  $DIR_TMP_TEST/{a,b}/r/*srt
rm  $DIR_TMP_TEST/{a,b}/q/*blanks.srt
```

Now you can run the test:

```bash
echo === DIRECTORY SELECTED: $DIR_TMP_TEST ===
for d in $DIR_TMP_TEST/*;
do
  echo === $( echo "$d" | awk -F'/' '{ print $NF }' ); 
  echo ./chk_srt.sh $d
done
```
