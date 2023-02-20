#!/bin/sh

# Setting up ZOSOpenTools the way it should be :)
# wizardofzos 2023

# clear previous muck
rm -rf gitzot
mkdir gitzot


# Get bash, perl, ncurses and git
echo "Getting bash"
curl -k -L -s https://github.com/ZOSOpenTools/bashport/releases/download/bashport_605/bash-5.2.20230218_210446.zos.pax.Z --output bash.pax.Z 
echo " - unpaxing.."
pax -v -f bash.pax.Z > tmpfile
bashpath=`head -n 1 tmpfile | cut -c55-100`
pax -rf bash.pax.Z
rm bash.pax.Z
echo " - moving into place"
mv $bashpath gitzot/bash
rm tmpfile

echo "Getting perl"
curl -k -L -s https://github.com/ZOSOpenTools/perlport/releases/download/perlport_531/perl5-blead.20230210_213003.zos.pax.Z --output perl.pax.Z
echo " - unpaxing.."
pax -v -f perl.pax.Z > tmpfile
perlpath=`head -n 1 tmpfile | cut -c55-100`
pax -rf perl.pax.Z
rm perl.pax.Z
echo " - moving into place"
mv $perlpath gitzot/perl
rm tmpfile

echo "Getting ncurses"
curl -k -L -s https://github.com/ZOSOpenTools/ncursesport/releases/download/ncursesport_618/ncurses-6.3.20230219_035409.zos.pax.Z --output ncurses.pax.Z
echo " - unpaxing.."
pax -v -f ncurses.pax.Z > tmpfile
ncursespath=`head -n 1 tmpfile | cut -c55-100`
pax -rf ncurses.pax.Z
rm ncurses.pax.Z
echo " - moving into place"
mv $ncursespath gitzot/ncurses
rm tmpfile

echo "Getting git"
curl -k -L -s https://github.com/ZOSOpenTools/gitport/releases/download/gitport_519/git-2.39.1.20230210_171810.zos.pax.Z --output git.pax.Z 
echo " - unpaxing.."
pax -v -f git.pax.Z > tmpfile
gitpath=`head -n 1 tmpfile | cut -c55-100`
pax -rf git.pax.Z
rm git.pax.Z
echo " - moving into place"
mv $gitpath gitzot/git
rm tmpfile

echo "All done, packaging with zdopack"
# Use code from to zdopack craft a proper receiver (that takes care of all the .env stuff :) 
srcuss=`pwd`/gitzot
workdir=".pack-work-dir"
echo "Paxing your USS folder to $workdir/paxfile"
pax -o saveext -s ",$srcuss,distfolder," -wzvf  $workdir/file.pax $srcuss
echo "Mime encoding it to $workdir/mimefile"
uuencode -m $workdir/file.pax $workdir/mimefile > $workdir/mimefile
echo "Creating the receiver"
cat template.sh $workdir/mimefile > gitinstaller.sh

