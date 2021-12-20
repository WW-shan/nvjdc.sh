#!/bin/bash

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

welcome () {
    echo
    echo -e "$green安装即将开始"
    echo "如果您想取消安装，"
    echo -e "请在 5 秒钟内按 Ctrl+C 终止此脚本。$plain"
    echo -e "$red 有bug可以联系 https://t.me/wwshan $plain"
    echo
    sleep 5
}


install(){
  echo -e "${green}更新源...${plain}"
  apt update && yum update > /dev/null 2>&1
  
  echo -e "${green}安装依赖 . . .${plain}"
  apt install curl wget unzip -y && yum install curl wget unzip -y > /dev/null 2>&1

  echo -e "$green正在检查 Docker 安装情况 . . .$plain"
  if command -v docker >> /dev/null 2>&1;
  then
    echo -e "${green}Docker 已安装 . . .$plain"
  else
    echo -e "$green开始安装 Docker . . .$plain"
    curl -fsSL get.docker.com -o get-docker.sh > /dev/null 2>&1
    sudo sh get-docker.sh --mirror Aliyun > /dev/null 2>&1
      if command -v docker >> /dev/null 2>&1;
      then
          echo -e "${green}Docker 安装成功 . . .$plain"
          shon_online
      else
          echo -e "${red}Docker 安装失败 . . ."
          echo -e "请尝试手动安装 Docker$plain"
          exit 1
      fi
  fi

  echo -e "$green拉取nvjdcdocker源码中 . . .$plain"
  git clone https://github.com/NolanHzy/nvjdcdocker.git /root/nolanjdc > /dev/null 2>&1
  
  echo -e "$green拉取nvjdc镜像中 . . .$plain"
  sudo docker pull nolanhzy/nvjdc:latest > /dev/null 2>&1

  echo -e "${green}请输入容器名称(如 : nolanjdc) : ${plain}"
  read -p "" name
  echo
  echo -e "${yellow}---------------------------${plain}"
  echo -e "容器名称 = ${green}${name}${plain}"
  echo -e "${yellow}---------------------------${plain}"
  echo

  echo -e "${green}请输入容器端口(如 : 5701) : ${plain}"
  read -p "" port
  echo
  echo -e "${yellow}---------------------------${plain}"
  echo -e "容器端口 = ${green}${port}${plain}"
  echo -e "${yellow}---------------------------${plain}"
  echo

  echo -e "${green}请输入网站标题 : ${plain}"
  read -p "" title
  echo
  echo -e "${yellow}---------------------------${plain}"
  echo -e "网站标题 = ${green}${title}${plain}"
  echo -e "${yellow}---------------------------${plain}"
  echo

  echo -e "${green}请输入网站公告 : ${plain}"
  read -p "" announcement
  echo
  echo -e "${yellow}---------------------------${plain}"
  echo -e "网站公告 = ${green}${announcement}${plain}"
  echo -e "${yellow}---------------------------${plain}"
  echo

  echo -e "${green}请输入XDD PLUS Url (如 : http://IP地址:端口/api/login/smslogin 没有为空) : ${plain}"
  read -p "" XDDurl
  echo
  echo -e "${yellow}---------------------------${plain}"
  echo -e "XDD PLUS Url = ${green}${XDDurl}${plain}"
  echo -e "${yellow}---------------------------${plain}"
  echo

  echo -e "${green}请输入xddToken : ${plain}"
  read -p "" XDDToken
  echo
  echo -e "${yellow}---------------------------${plain}"
  echo -e "xddToken = ${green}${XDDToken}${plain}"
  echo -e "${yellow}---------------------------${plain}"
  echo

  echo -e "${green}请输入青龙服务器名称 (如 : 阿里云): ${plain}"
  read -p "" QLName
  echo
  echo -e "${yellow}---------------------------${plain}"
  echo -e "服务器名称 = ${green}${QLName}${plain}"
  echo -e "${yellow}---------------------------${plain}"
  echo

  echo -e "${green}请输入青龙地址 : ${plain}"
  read -p "" QLurl
  echo
  echo -e "${yellow}---------------------------${plain}"
  echo -e "青龙地址 = ${green}${QLurl}${plain}"
  echo -e "${yellow}---------------------------${plain}"
  echo

  echo -e "${green}请输入青龙2,9 OpenApi Client ID : ${plain}"
  read -p "" QL_CLIENTID
  echo
  echo -e "${yellow}---------------------------${plain}"
  echo -e "青龙2,9 OpenApi Client ID = ${green}${QL_CLIENTID}${plain}"
  echo -e "${yellow}---------------------------${plain}"
  echo

  echo -e "${green}请输入青龙2,9 OpenApi Client Secret : ${plain}"
  read -p "" QL_SECRET
  echo
  echo -e "${yellow}---------------------------${plain}"
  echo -e "青龙2,9 OpenApi Client ID = ${green}${QL_SECRET}${plain}"
  echo -e "${yellow}---------------------------${plain}"
  echo


  cd /root/nolanjdc
  mkdir -p  Config
  cat <<EOF > /root/nolanjdc/Config/Config.json
{
  ///浏览器最多几个网页
  "MaxTab": "4",
  //网站标题
  "Title": "${title}",
  //回收时间分钟 不填默认3分钟
  "Closetime": "3",
  //网站公告
  "Announcement": "${announcement}",
  ///开启打印等待日志卡短信验证登陆 可开启 拿到日志群里回复 默认不要填写
  "Debug": "",
  ///自动滑块次数5次 5次后手动滑块 可设置为0默认手动滑块
  "AutoCaptchaCount": "5",
  ///XDD PLUS Url  http://IP地址:端口/api/login/smslogin
  "XDDurl": "${XDDurl}",
  ///xddToken
  "XDDToken": "${XDDToken}",
  ///青龙配置  注意对接XDD 对接芝士 设置为"Config":[]
  "Config": [
    {
      //序号必填从1 开始
      "QLkey": 1,
      //服务器名称
      "QLName": "${QLName}",
      //青龙地址
      "QLurl": "${QLurl}",
      //青龙2,9 OpenApi Client ID
      "QL_CLIENTID": "${QL_CLIENTID}",
      //青龙2,9 OpenApi Client Secret
      "QL_SECRET": "${QL_SECRET}",
      //CK最大数量
      "QL_CAPACITY": 40,
      "QRurl": ""
    }
  ]
}
EOF

  echo -e "$green开始下载并配置chromium . . .$plain"
  cd /root/nolanjdc && mkdir -p  .local-chromium/Linux-884014 && cd .local-chromium/Linux-884014 > /dev/null 2>&1
  wget https://mirrors.huaweicloud.com/chromium-browser-snapshots/Linux_x64/884014/chrome-linux.zip && unzip chrome-linux.zip > /dev/null 2>&1
  rm  -f chrome-linux.zip
  cd  /root/nolanjdc

  echo -e "${green}开始启动镜像 . . .${plain}"

  sudo docker run   --name $name -p ${port}:80 -d  -v  "$(pwd)":/app \
-v /etc/localtime:/etc/localtime:ro \
-it --privileged=true  nolanhzy/nvjdc:latest > /dev/null 2>&1
  echo -e "${green}镜像启动完成${plain}"
  echo -e "${red}源码安装路径 : /root/nolanjdc ${plain}"
  docker logs -f nolanjdc
  sleep 5
}

[[ $EUID -ne 0 ]] && echo -e "${red}错误：${plain} 必须使用root用户运行此脚本！\n" && exit 1
welcome
install
