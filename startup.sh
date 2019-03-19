echo "You have to accept freescale EULA. Read it carefully and then accept it."
sleep 3
cat /home/user/torizon/layers/meta-freescale/EULA
read -p "Do you accept the EULA? [y/n] " yn
case $yn in
    [Yy]* ) echo 'EULA accepted';;
    [Nn]* ) exit;;
    * ) echo "Please answer yes or no." && exit ;;
esac
cd ~/torizon
MACHINE=$MACHINE source setup-environment
echo 'ACCEPT_FSL_EULA="1"' >> ~/torizon/build-torizon/conf/local.conf
cd ~/torizon/build-torizon
if [ -z "$TARGET" ]
then
    echo "> bitbake torizon-core-docker"
    bitbake torizon-core-docker
else
    echo "> bitbake $TARGET"
    bitbake $TARGET
fi
