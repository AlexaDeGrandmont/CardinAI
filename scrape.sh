#!/bin/bash

if [ -d UserHistory ]
then
	mv $1 UserHistory 
	cd UserHistory
else
	mkdir UserHistory
	mv $1 UserHistory
	cd UserHistory 
fi



while read file
do
	target="${file%%_*}"
	echo $target
	if [ -d $target ]
	then
		cd $target
		rm -r *
	else
		mkdir $target
		cd $target 
		rm -r *
	fi
	twint -u "$target" --since "2020-07-01 00:00:00" -o "$target".csv --csv
	twint -u "$target" --following --resume "$target"_reusume.txt --limit 100 | tee "$target"_follows.txt
	
	while read user; do
		echo $user
  		twint -u "$user" --since "2020-07-01 00:00:00" -o "$user".csv --csv
		tail -n+2 "$user".csv >> "$target".csv
		rm "$user".csv
	done < "$target"_follows.txt
	cd ..
done < $1


