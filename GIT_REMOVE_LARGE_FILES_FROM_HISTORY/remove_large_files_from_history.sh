# Download BFG jar
wget https://repo1.maven.org/maven2/com/madgag/bfg/1.14.0/bfg-1.14.0.jar
chmod +x bfg-1.14.0.jar

# Remove the exact files (example with csv files)
java -jar bfg-1.14.0.jar --delete-files '*.csv' .

# OR target exact filenames (with paths)
java -jar bfg-1.14.0.jar \
  --delete-files 'data/train.csv' \
  --delete-files 'data/test.csv' \
  --delete-files 'data/test_with_emotions.csv' \
  --delete-files 'data/icml_face_data.csv' \
  .


# clean the git history
git reflog expire --expire=now --all
git gc --prune=now --aggressive
git count-objects -vH

# force push the clean history
git push origin main --force --verbose
rm -rf bfg-1.14.0.jar

# modify your git ignore to include these files.