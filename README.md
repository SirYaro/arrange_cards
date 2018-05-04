# arrange images<BR>
<BR>
This script arrange specified images on A4 sheet<BR>
<BR>
--<BR>
Try to run arrange.sh in sample_env directory:<BR>
<BR>
arrange.sh -i arrange.txt -o filename.pdf -f karty_setup_poker.png -c 3 -r 3 -s poker.sh<BR>
<BR>
other examples:<BR>
arrange.sh -i arrange.txt -o front.pdf -c 3 -r 3 -s default.sh -y 100 -x 124 -g 0 -f empty.png -k 1<BR>
arrange.sh -i arrange2.txt -o rewers.pdf -c 3 -r 3 -s default.sh -y 100 -x 124 -g 0 -f empty.png -k 1 --mx 43 --my 37<BR>
<BR>
<BR>
  Note:  ImageMagick version: 6.7.7-10 2014-03-06 Q16 have/had some bug in flop function which caused unwanted images color changes. ImageMagick version 6.8.9-9 Q16 x86_64 seems to work fine.
  
