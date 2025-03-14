--启动外部程序
function translator(input, seg)
	local path0=debug.getinfo(1,"S").source:sub(2)--获取Lua脚本的完整路径
	 pathCY=path0:sub(0,-20)--根目录
	 pathC=pathCY.."weasel\\"--程序目录
	 pathY=pathCY.."user\\"--用户目录
	 pathL=pathY.."lua\\"--lua目录

   if (input == "/jsq") then  --打开计算器
    strProgram = '"C:\\Windows\\system32\\calc.exe"' --此项路径自行修改
    strCmd = 'start "" '..strProgram 
    os.execute(strCmd)
   end
   if (input == "/cmd") then  --打开CMD窗口
    strProgram = '"C:\\Windows\\system32\\cmd.exe"' --此项路径自行修改
    strCmd = 'start "" '..strProgram 
    os.execute(strCmd)
   end
   if (input == "/kz") then  --打开控制面板
    strProgram = '"C:\\Windows\\system32\\control.exe"' --此项路径自行修改
    strCmd = 'start "" '..strProgram 
    os.execute(strCmd)
   end
   if (input == "/tc") then  --打开TC
    strProgram = '"D:\\App\\TC\\TotalCMD64.exe"' --此项路径自行修改
    strCmd = 'start "" '..strProgram 
    os.execute(strCmd)
   end
   if (input == "/wz") then  --打开word
    strProgram = '"D:\\Program Files\\Microsoft Office\\Office16\\WINWORD.EXE"' --此项路径自行修改
    strCmd = 'start "" '..strProgram 
    os.execute(strCmd)
   end
   if (input == "/cx") then  --打开小狼毫程式文件
    strProgram = pathCY..'"weasel"' --此项路径自行修改
    strCmd = 'start "" '..strProgram 
    os.execute(strCmd)
   end
   if (input == "/yh") then  --打开小狼毫用户文件
    strProgram = pathCY..'"user"' --此项路径自行修改
    strCmd = 'start "" '..strProgram 
    os.execute(strCmd)
   end
   if (input == "/bs") then  --部署
    strProgram = pathC..'"WeaselDeployer.exe" /deploy' --此项路径自行修改
    strCmd = 'start "" '..strProgram 
    os.execute(strCmd)
   end
   if (input == "/sdds") then  --设定
    strProgram = pathC..'"WeaselDeployer.exe"'-- /weaseldir' --此项路径自行修改
    strCmd = 'start "" '..strProgram 
    os.execute(strCmd)
   end
   if (input == "/np") then  --打牛码配置
    strProgram = pathY.."_niumawb.schema.yaml" --此项路径自行修改
    strCmd = 'start "" '..strProgram 
    os.execute(strCmd)
   end
   if (input == "/nm") then  --打牛码码表
    strProgram = pathY.."_xklbXY53.dict.yaml" --此项路径自行修改
    strCmd = 'start "" '..strProgram 
    os.execute(strCmd)
   end
   if (input == "/bz") then  --打开B站
    strProgram = '"https://www.bilibili.com/"' 
    strCmd = 'start "" '..strProgram 
    os.execute(strCmd)
   end
   end

return translator
