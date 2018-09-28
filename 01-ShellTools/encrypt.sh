#Author:Allenoyk
#Description:文件加密脚本

echo "Welcome,I am ready to encrypt a file/folder for you"
echo "currently I have a limitation,Please me to the same folder,where afile to be encrypted is present"
echo "Enter the Exact File Name with extension"
read file;
gpg -c $file
echo "I have encrypted the file sucessfully."
echo "Now I will be removing the original file"
rm -rf $file
