import os

licenses = ["mit", "isc", "gpl", "bsd", "mpl"] # Packages with these licenses can be hidden from output
hide = False

def checkNew(pkg):
    pkgs = os.popen("pacman -Si "+pkg+" | grep 'Depends On'").read().split(":")[1].split()
    print(pkg+"\n"+os.popen("pacman -Si "+pkg+" | grep -e 'Name' -e 'License'").read())
    for x in pkgs:
        cmd = ""
        if ".so" in x:
            cmd = "pacman -Qi "+x.split("=")[0]+" | grep -e 'Name' -e 'License'"
        else:
            cmd = "pacman -Si "+x.split("\n")[0]+" | grep -e 'Name' -e 'License'"
        output = os.popen(cmd).read()
        counter = 0
        for y in licenses:
            if y in output.lower() and hide:
                counter += 1
        if counter == 0:
            print(x+"\n"+output)

def checkAll():
    pkgs = os.popen("pacman -Q").read().split("\n")
    for x in pkgs:
        if x != "":
            output = os.popen("pacman -Qi "+x.split()[0]+" | grep -e 'Name' -e 'License'").read()
            counter = 0
            for y in licenses:
                if y in output.lower() and hide:
                    counter += 1
            if counter == 0:
                print(output)

while True:
    arg = input("What to check? [Package name or 'all']: ")
    if arg == "q":
        break
    opt = input("Hide free licenses? [y/N]: ")
    if opt == "y":
        hide = True
    else:
        hide = False
    if arg == "all":
        checkAll()
    else:
        checkNew(arg)
