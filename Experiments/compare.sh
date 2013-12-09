# echo "$@"
# echo "$1 $2"
#
if [ "$2" = "7z" ]
then
	zipUnzip="z"
else
	zipUnzip="u"
fi
#
filesDiff=$(cmp "$1"."$2" Reference/"$1"."$2")
# echo "$filesDiff"
if [ "$filesDiff" ]
then
	echo "Files different."
	# echo "$filesDiff"
	# 
	# Unzip the new version to its correct place using Selector.
	/cygdrive/c/Windows/System32/cmd.exe "/c ..\Selector\select.ahk zip.ini RUN $1$zipUnzip"
	#
	# Overwrite the reference version with the new version.
	#
else
	echo "Files match."
	# Done, nothing more to do here.
fi