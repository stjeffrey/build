# These are project build parameters in TeamCity
# Depending on the branch, we will use different major/minor versions
$version = Get-Content "version.txt"

Write-Host "Version is $version"

# TeamCity's auto-incrementing build counter; ensures each build is unique
$buildCounter = "$env:build_counter" 

# This gets the name of the current Git branch. 
$branch = "$env:build_branch"

# Sometimes the branch will be a full path, e.g., 'refs/heads/master'. 
# If so we'll base our logic just on the last part.
if ($branch.Contains("/")) 
{
  $branch = $branch.substring($branch.lastIndexOf("/")).trim("/")
}

Write-Host "Branch: $branch"


#Is this a bug branch?
if ($branch -match "[a-zA-Z]\-\d+") 
{
 $buildNumber = "${version}.${buildCounter}-${branch}"
}
else
{
 $buildNumber = "${version}.${buildCounter}"
 # If the branch starts with "feature-", just use the feature name
 $branch = $branch.replace("feature-", "")
}

Write-Host $version
Write-Host $buildNumber
Write-Host "##teamcity[buildNumber '$buildNumber']"