import subprocess
print(subprocess.run(["sudo", "passwd", "xyz"], input=b"111111\n111111\n", check=True))
