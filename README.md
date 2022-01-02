# Lay out images<BR>
<BR>

This script lays out specified images on paper sheet<BR>
<BR>
--<BR>
**Set it up**<BR>
`sudo apt -y install imagemagick git`<BR>
<BR>
Change ImageMagic permissions<BR>
```
sudo apt -y install xmlstarlet
cd /etc/ImageMagick-6  #check if that is correct directory
sudo xmlstarlet edit -L --update "/policymap/policy[@name='disk']/@value" --value "16GiB" policy.xml  #allows to handle files up to 16GB
sudo xmlstarlet edit -L --subnode "/policymap" --type elem --name 'policy domain="coder" rights="read|write" pattern="PDF" ' policy.xml #allows read/write pdfs
```
if you still getting an error:<BR>
`convert-im6.q16: not authorized 'filename.pdf' @ error/constitute.c/WriteImage/1037.`<BR>
you can try disable IM limits all together with<BR>
`sudo mv /etc/ImageMagick-6/policy.xml /etc/ImageMagick-6/policy.xml.BAK`<BR>
<BR>
**Instalation**<BR>
```
git clone git@github.com:SirYaro/arrange_cards.git
cd arrange_cards
```
**Testing**<br>
Try to run `sample_generate.sh` in one of sample_envX directories:<BR>
<BR>
ex:
```
cd sample_env
cat sample_generate.sh # to check what you're about to run
./sample_generate.sh
```
and then look for filename.pdf.<BR>
For much more advanced example please check sample_env3
```
cd sample_env3
cat sample_generate.sh
./sample_generate.sh
```
 
**Note**<BR>
ImageMagick version: 6.7.7-10 2014-03-06 Q16 have/had some bug in flop function which caused unwanted images color changes. ImageMagick version 6.8.9-9 Q16 x86_64 seems to work fine.
  
