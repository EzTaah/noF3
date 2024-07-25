#!/bin/bash

# Variables
initial_version="1.20.4"
new_version="1.20.5"
website_data='\
minecraft_version=1.20.5
yarn_mappings=1.20.5+build.1
loader_version=0.15.11

# Fabric API
fabric_version=0.97.8+1.20.5
'

# Path to the fabric.mod.json file
fabric_mod_json="./src/main/resources/fabric.mod.json"

# Path to the gradle.properties file
gradle_properties="./gradle.properties"

# Updating the fabric.mod.json file
echo "Updating the file: $fabric_mod_json"
sed -i "s/$initial_version/$new_version/g" "$fabric_mod_json"

# Updating the gradle.properties file
echo "Updating the file: $gradle_properties"

# Using awk to replace a specific block of text
awk -v new_section="$website_data" '
BEGIN { print_flag = 1 }
/^minecraft_version=/ { print_flag = 0; print new_section; next }
/^# Mod Properties/ { print_flag = 1 }
print_flag { print }
' "$gradle_properties" > temp && mv temp "$gradle_properties"

echo "Update completed."



# Git operations
echo "Switching to a new branch for the version update..."
git switch -c "$new_version"
echo "Adding all changes to staging..."
git add .
echo "Committing the changes..."
git commit -m "Automatic update to $new_version"
echo "Pushing changes to remote repository..."
git push --set-upstream origin "$new_version"

echo "All operations completed successfully."




# useful commands 

# -- JAVA -- 
# java -version 
# sudo dnf install java-17-openjdk-devel        | install java 17   
# sudo alternatives --config java               | choose which version of java you want to use

# -- GRADLEW -- 
# ./gradlew clean build   
# ./gradlew runClient