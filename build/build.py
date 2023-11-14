import os
import subprocess

vivado = "/opt/Xilinx/Vivado/2023.1/bin/vivado"


class VivadoBuildError(Exception):
    pass


if not os.access("build.tcl", os.R_OK):
    raise VivadoBuildError("you should pass a build script for us to run!")

print("starting vivado, please wait...")
proc = subprocess.Popen(f"{vivado} -mode batch -source build.tcl",
                        shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)

while True:
    line = proc.stdout.readline()
    if not line:
        break
    else:
        print(str(line.rstrip(), encoding='ascii'))

proc.wait()

if proc.returncode != 0:
    save("vivado.log")
    raise VivadoBuildError(f"vivado exited with code {proc.returncode}")
else:
    save("vivado.log")


# look for out.bit, because we've hard coded that for now i guess
if not os.access("obj/final.bit", os.R_OK):
    raise VivadoBuildError(
        "vivado exited successfully, but no out.bit generated")

save("obj/final.bit")
