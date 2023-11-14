import os
import subprocess

xvlog = "/opt/Xilinx/Vivado/2023.1/bin/xvlog"
xelab = "/opt/Xilinx/Vivado/2023.1/bin/xelab"
xsim = "/opt/Xilinx/Vivado/2023.1/bin/xsim"


class VivadoBuildError(Exception):
    pass


if not os.access("xsim_run.tcl", os.R_OK):
    raise VivadoBuildError("you should pass a build script for us to run!")

print("starting vivado, please wait...")
proc = subprocess.Popen(f"{xvlog} ./ip/xfft_128/xfft_128_stub.v --sv ./hdl/biometrics/feature_extractor/dct.sv",
                        shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)

while True:
    line = proc.stdout.readline()
    if not line:
        break
    else:
        print(str(line.rstrip(), encoding='ascii'))

proc.wait()

if proc.returncode != 0:
    # save("vivado.log")
    raise VivadoBuildError(f"vivado exited with code {proc.returncode}")
else:
    pass
    # save("vivado.log")

proc = subprocess.Popen(f"{xelab} -svlog ./sim/dct_tb.sv --debug wave",
                        shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)

while True:
    line = proc.stdout.readline()
    if not line:
        break
    else:
        print(str(line.rstrip(), encoding='ascii'))

proc.wait()

if proc.returncode != 0:
    # save("vivado.log")
    raise VivadoBuildError(f"vivado exited with code {proc.returncode}")
else:
    pass
    # save("vivado.log")


proc = subprocess.Popen(f"{xsim} dct_tb -t xsim_run.tcl",
                        shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)

while True:
    line = proc.stdout.readline()
    if not line:
        break
    else:
        print(str(line.rstrip(), encoding='ascii'))

proc.wait()

if proc.returncode != 0:
    # save("vivado.log")
    raise VivadoBuildError(f"vivado exited with code {proc.returncode}")
else:
    pass
    # save("vivado.log")

proc = subprocess.Popen(f"tar -czvf dump.tar.gz dump.vcd",
                        shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)

while True:
    line = proc.stdout.readline()
    if not line:
        break
    else:
        print(str(line.rstrip(), encoding='ascii'))

proc.wait()

# files to look for:
files = ["dump.tar.gz", "dump.vcd"
         ]

for file in files:
    # look for out.bit, because we've hard coded that for now i guess
    if not os.access(f"{file}", os.R_OK):
        raise VivadoBuildError(
            f"vivado suite exited successfully, but no {file} generated")
    save(f"{file}")
