import os

user = os.popen("whoami").read().split("\n")[0]+"/"
pathParts = ["home/", user]
path = "/home/"+user
marked = "none"
action = "cp"
showHidden = False
filesInDir = []

def clear():
    for i in range(99):
        print('\n')

def listFiles():
    global filesInDir
    command = "ls -p "
    if showHidden:
        command = "ls -ap "
    filesInDir = os.popen(command+path).read().split()
    counter = 0
    for x in filesInDir:
        print(" "+str(counter)+". "+x)
        counter += 1

def buildPath(option):
    global path, pathParts
    path = "/"
    if type(option) == int:
        if filesInDir[option] == "../" and len(pathParts) != 0:
            pathParts.pop(len(pathParts)-1)
        elif filesInDir[option] == "./":
            print("...")
        elif "/" in filesInDir[option]:
            pathParts.append(filesInDir[option])
    elif option == ".." and len(pathParts) != 0:
        pathParts.pop(len(pathParts)-1)
    for x in pathParts:
        path += x

while True:
    clear()
    listFiles()
    option = input("\n Marked: "+marked+"\n Action: ")
    if " " in option:
        if option.split()[0] == "rm":
            os.popen("rm -rf "+path+filesInDir[int(option.split()[1])])
        elif option.split()[0] == "mk":
            os.popen("mkdir "+path+option.split()[1])
        elif option.split()[0] == "to":
            os.popen("touch "+path+option.split()[1])
        elif option.split()[0] == "rn":
            os.popen("mv "+path+filesInDir[int(option.split()[1])]+" "+path+option.split()[2])
        elif option.split()[0] == "cp":
            action = "cp"
            marked = path+filesInDir[int(option.split()[1])]
        elif option.split()[0] == "mv":
            action = "mv"
            marked = path+filesInDir[int(option.split()[1])]
        elif option.split()[0] == "ta":
            os.popen("cd "+path+" && tar -czf "+filesInDir[int(option.split()[1])][:-1]+".tar.gz "+filesInDir[int(option.split()[1])][:-1])
        elif option.split()[0] == "ut":
            if ".tar.xz" in filesInDir[int(option.split()[1])]:
                os.popen("cd "+path+" && tar -xf "+filesInDir[int(option.split()[1])])
            elif ".tar.gz" in filesInDir[int(option.split()[1])]:
                os.popen("cd "+path+" && tar -xzf "+filesInDir[int(option.split()[1])])
        elif option.split()[0] == "mpv":
            os.popen("mpv "+path+filesInDir[int(option.split()[1])])
        elif option.split()[0] == "pic":
            os.popen("ristretto "+path+filesInDir[int(option.split()[1])])
        elif option.split()[0] == "ff":
            os.popen("firefox file://"+path+filesInDir[int(option.split()[1])])
    else:
        if option == "q":
            clear()
            break
        elif option == "p" and marked != "none":
            os.popen(action+" "+marked+" "+path)
            marked = "none"
        elif option == "h":
            showHidden = not showHidden
        elif option == "..":
            buildPath(option)
        elif option.isnumeric():
            buildPath(int(option))
