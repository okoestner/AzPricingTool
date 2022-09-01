#!/bin/bash
clear
#set -xe
set -e

echo $1
if [[ -z "$1" ]]
then
  echo "Missing parameter."
  echo "Run the tool with the installation directory as first parameter."
  exit 1
fi

installation_dir=$1 #"/home/sergio/azure-pricer/"
lastChar=${installation_dir: -1}

if [[ $lastChar != '/' ]]
then
  installation_dir=$installation_dir"/"
fi

day_of_today=$(date +%Y%m%d)
excel_files_dir=$installation_dir"output/"
max_number_of_xls_files=30

excel_file_of_today=$excel_files_dir"TSI-AzQuote-$day_of_today.xlsx"
readme_file_template=$excel_files_dir"README.MD.template"
readme_file=$installation_dir"README.MD"

echo "------------------------------------------------------------------------"
echo "Excel file of today: $excel_file_of_today"
echo "Readme-Template: $readme_file_template"
echo "Readme-File: $readme_file"
echo "------------------------------------------------------------------------"

cd $installation_dir

git pull
echo "UPDATING CODE FROM OLAF REPO"

python3 $installation_dir"xls_generator.py" $excel_file_of_today 

exit 0


find $excel_file_of_today

if [ $? -ne 0 ]
then
	echo "ERROR"
	exit
fi

sed "s/__DATE__/$day_of_today/g" $readme_file_template > $readme_file

for old_file in $(find $excel_files_dir -type f -name "Azure-Quote-Tool-*.xlsx" -mtime +$max_number_of_xls_files)
do
	git rm $old_file
done

cd $installation_dir
git add $excel_file_of_today $readme_file
git commit -m "Automatic build of $day_of_today"
git push
