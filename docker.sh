#!/usr/bin/env bash

str1="一、正在判断当前账户是否为root"
echo "-----------------------------------------------------------------------"
echo -e "\033[31m${str1}\033[0m"
echo "-----------------------------------------------------------------------"

#获取当前账户权限
ROOT_TYPE=$(whoami)
#echo "$ROOT_TYPE"

#判断当前账户权限是否为root
case $ROOT_TYPE in
    root)
        echo -e "\033[32m当前账户是Root，将继续执行\033[0m"
        ;;
    *)
        echo -e "\033[33m当前账户不是Root，请切换至Root账户下执行\033[0m"
        exit 1
        ;;
esac

str2="二、正在判断当前OS类型"
echo "-----------------------------------------------------------------------"
echo -e "\033[31m${str2}\033[0m"
echo "-----------------------------------------------------------------------"

# 获取操作系统类型
OS_TYPE=$(cat /etc/os-release |grep "^NAME" |awk -F \" '{print $2}')
#echo "$OS_TYPE"

# 判断操作系统类型并进行到相应的步骤
case $OS_TYPE in
    Ubuntu)
        echo -e "\033[32m操作系统版本为：Ubuntu\033[0m"
        # 针对 Ubuntu 系统的步骤
        str3="三、正在一键部署Docker，请稍候"
        echo "-----------------------------------------------------------------------"
        echo -e "\033[31m${str3}\033[0m"
        echo "-----------------------------------------------------------------------"
        echo ""
        echo ""
        echo -e "\033[36m1.正在添加Docker库(阿里)\033[0m"
        apt install apt-transport-https ca-certificates curl software-properties-common gnupg lsb-release -y -q
        curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
        echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        apt update
        echo ""
        echo ""
        echo -e "\033[36m2.正在安装Docker\033[0m"
        apt install docker-ce docker-ce-cli containerd.io docker-compose docker-compose-plugin -y -q
        echo ""
        echo ""
        echo -e "\033[36m3.正在写入Docker国内加速源\033[0m"
        # 国内加速源，可替换
        echo -e "{\n \"registry-mirrors\":[\"https://docker.1panel.live\"]\n}" | tee /etc/docker/daemon.json > /dev/null
        systemctl restart docker
        echo -e "\033[35m当前国内加速源为：\033[0m"
        docker info | grep -A1 "Registry Mirrors"
        echo ""
        echo ""
        echo -e "\033[36m4.正在设置开机自启\033[0m"
        systemctl enable docker
        systemctl restart docker
        echo -e "\033[35m设置完成\033[0m"
        echo ""
        echo ""
        str4="四、安装成功"
        echo "-----------------------------------------------------------------------"
        echo -e "\033[31m${str4}\033[0m"
        echo "-----------------------------------------------------------------------"
        echo -e "\033[35m当前Docker版本为：\033[0m"
        docker version 2>&1 |awk "NR==2"
        echo ""
        ;;
    Rocky*|Centos*)
        echo -e "\033[32m操作系统版本为：RHEL类\033[0m"
        # 针对 RHEL 系统的步骤
        str5="三、正在一键部署Docker，请稍候"
        echo "-----------------------------------------------------------------------"
        echo -e "\033[31m${str5}\033[0m"
        echo "-----------------------------------------------------------------------"
        echo ""
        echo ""
        echo -e "\033[36m1.正在添加Docker库(阿里)\033[0m"
        yum install yum-utils -y -q
        yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/rhel/docker-ce.repo
        sed -i 's+download.docker.com+mirrors.aliyun.com/docker-ce+' /etc/yum.repos.d/docker-ce.repo
        yum makecache
        echo ""
        echo ""
        echo -e "\033[36m2.正在安装Docker\033[0m"
        yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
        echo ""
        echo ""
        echo -e "\033[36m3.正在写入Docker国内加速源\033[0m"
        # 国内加速源，可替换
        echo -e "{\n \"registry-mirrors\":[\"https://docker.1panel.live\"]\n}" | tee /etc/docker/daemon.json > /dev/null
        systemctl restart docker
        echo -e "\033[35m当前国内加速源为：\033[0m"
        docker info | grep -A1 "Registry Mirrors"
        echo ""
        echo ""
        echo -e "\033[36m4.正在设置开机自启\033[0m"
        systemctl enable docker
        systemctl restart docker
        echo -e "\033[35m设置完成\033[0m"
        echo ""
        echo ""
        str6="四、安装成功"
        echo "-----------------------------------------------------------------------"
        echo -e "\033[31m${str6}\033[0m"
        echo "-----------------------------------------------------------------------"
        echo -e "\033[35m当前Docker版本为：\033[0m"
        docker version 2>&1 |awk "NR==2"
        echo ""
        echo ""
        ;;
    *)
        echo -e "\033[33m当前操作系统版本为：$OS_TYPE\033[0m"
        echo -e "\033[33m不支持的操作系统版本，请联系Aimei.Soul@foxmail.com\033[0m"
        exit 1
        ;;
esac
